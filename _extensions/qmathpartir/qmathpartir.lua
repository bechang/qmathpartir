-- Create a Math(InlineMath, ...) node
local function math(t)
  return pandoc.Math('InlineMath', t)
end

-- Parse text into an inline node.
local function text(t)
  return pandoc.read(t).blocks[1].content
end

-- In a mathpar, process Str 
local function mathparStr(el)
  -- Spacing commands turn into Spans with a given class for styling.
  local mathparCommands = { ['\\and'] = 'softbreak', ['\\'] = 'linebreak' }
  local cl = mathparCommands[el.text]
  if cl then
    return pandoc.Span('', { class = cl })
  end

  -- Symbol commmands need to be escaped in the input (e.g., \\;)
  _, _, t = string.find(el.text, '^\\%p$')
  if t then
    t = string.format('\\%s', t)
  else
    t = el.text
  end

  -- Return a inline Math element.
  return math(t)
end

-- In a mathpar, process a Raw element, continuations text and math for creating text and math elements, respectively.
local function mathparRaw(text, math)
  return function(el)
    if el.format == 'tex' then
      -- TODO need a stack
      _, _, t = string.find(el.text, '^\\text{(.*)}$')
      if t then
        -- Leave as a text element if there is a \text{...} command.
        return text(t)
      else
        return math(el.text)
      end
    end
  end
end

-- In a mathpar, process a RawInline
local function mathparRawInline(el)
  return mathparRaw(function(t) return pandoc.Span(text(t), { class = 'text' }) end, math)(el)
end

-- In a mathpar, process a RawBlock
local function mathparRawBlock(el)
  local function para(sc)
    return function(t) return pandoc.Para(sc(t)) end
  end
  return mathparRaw(para(text), para(math))(el)
end

-- In a mathpar, process a Para
local function mathparPara(el)
  el = el:walk { Str = mathparStr, RawInline = mathparRawInline }
  -- After processing, merge consecutive Math(InlineMath, ...) and Space nodes.
  content = pandoc.List()
  mathstr = ''
  local function resetMathstr()
    if mathstr ~= '' then 
      content:insert(pandoc.Math('InlineMath', mathstr))
      mathstr = ''
    end
  end

  for _, inline in ipairs(el.content) do
    if inline.t == 'Math' and inline.mathtype == 'InlineMath' then
      mathstr = mathstr ~= '' and string.format('%s %s', mathstr, inline.text) or inline.text
    elseif mathstr ~= '' and inline.t == 'Space' then
      mathstr = mathstr .. ' '
    else
      resetMathstr()
      content:insert(inline)
    end
  end
  resetMathstr()

  el.content = content
  return el
end

--- Add beginEnv/endEnv tex strings to divEl element.
--- Citation: https://github.com/quarto-ext/latex-environment
function texEnvironment(divEl, beginEnv, endEnv)
  if #divEl.content > 0 and divEl.content[1].t == "Para" and divEl.content[#divEl.content].t == "Para" then
    table.insert(divEl.content[1].content, 1, pandoc.RawInline('tex', beginEnv .. "\n"))
    table.insert(divEl.content[#divEl.content].content, pandoc.RawInline('tex', "\n" .. endEnv))
  else
    table.insert(divEl.content, 1, pandoc.RawBlock('tex', beginEnv))
    table.insert(divEl.content, pandoc.RawBlock('tex', endEnv))
  end
end

-- For a tex output, fix up \\ from escaping
local function texStr(el)
  t = el.text
  if t == '\\' then
    t = '\\\\'
  end
  return pandoc.RawInline('tex', t)
end

-- The main entrpoint.
-- Process the mathpar Div.
-- If the output is tex, then simply create a mathpar enviroment. Otherwise, process to minmic it.
local function mathparDiv(el)
  if el.attr.classes:includes('mathpar') then
    if FORMAT == 'latex' then
      el = el:walk { Str = texStr }
      texEnvironment(el, "\\begin{mathpar}", "\\end{mathpar}")
      return el
    else
      el = el:walk { Para = mathparPara, RawBlock = mathparRawBlock }
      return el
    end
  end
end

local function mathparCodeBlock(el)
  return mathparDiv(pandoc.Div(pandoc.read(el.text).blocks, { class = 'mathpar' }))
end

local function deep_find_if(pred)
  return function(x)
    if type(x.find_if) == 'function' then
      return x:find_if(deep_find_if(pred))
    else
      return pred(x)
    end
  end
end

-- Entry point for Meta data.
-- Add loading mathpartir if the output is tex.
local function mathparMeta(meta)
  if FORMAT == 'latex' then
    pkg = "\\usepackage{mathpartir}"
    meta['header-includes'] = meta['header-includes'] or pandoc.MetaList({})
    includes = meta['header-includes']

    pkg_block = deep_find_if(function(m)
      return m.text == pkg
    end)(includes)

    -- Add the mathpartir package only it isn't already loaded in existing meta data.
    if pkg_block == nil then
      table.insert(includes, pandoc.MetaBlocks({
        pandoc.RawBlock("latex", pkg)
      }))
      return meta
    end
  end
end

-- Tex commands to insert as a Mathjax block
local mathjaxAdapter = pandoc.Span(math([[
\newcommand{TirName}[1]{\text{\small #1}}
\newcommand{inferrule}[3][]{
  \let\and\qquad
  \begin{array}{@{}l@{}}
  \TirName{#1}
  \\
  \displaystyle
  \frac{#2}{#3}
  \end{array}
}
\newcommand{infer}[3][]{\inferrule[#1]{#2}{#3}}
]]))

-- Entry point for the Pandoc document.
function Pandoc(el)
  el = el:walk { Meta = mathparMeta, Div = mathparDiv, CodeBlock = mathparCodeBlock }

  if FORMAT ~= 'latex' then
    -- After processing, insert some commands as a Mathjax block
    table.insert(el.blocks, 1, mathjaxAdapter) 
  end

  return el
end