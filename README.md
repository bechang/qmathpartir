# Qmathpartir: Mathpartir Extension For Quarto

This Quarto (and Pandoc) filter implements a partial compatibility package for Didier Remy's LaTeX 2e package `mathpartir.sty`.

## Installing

```bash
quarto add bechang/qmathpartir
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Loading

To use the extension, add the following to your document's metadata:

```yaml
filters:
- quarto
- qmathpartir
format:
  html:
    css: _extensions/bechang/qmathpartir/qmathpartir.css
```

While not required, you may apply the `qmathpartir` filter after the `quarto` filters have been applied as shown above.

For any html format, the css file `_extensions/qmathpartir/qmathpartir.css` should be included to apply flex-flow styles to the `.mathpar` blocks. We intentionally do not make this extension a custom format to enable to use this extension with any appropriate format.

## Using

Div blocks with the `.mathpar` class are processed so that each paragraph is an inline math element `$...$`:

```
::: {.mathpar}
e

\text{expression}\quad e ::= n \mid e_1 + e_2

\text{expression $e$}
:::
```

Text wrapped in the `\text{...}` command prevents the element from being placed into math.

The `\text{...}` works just at the top-level of a `.mathpar`.

A limited form of the `\inferrule` (or `\infer`) command can be used for type setting inference rules.

```
::: {.mathpar}
\infer[TypePlus]{
  \Gamma \vdash e_1 : \int
  \and
  \Gamma \vdash e_1 : \int
}{
  \Gamma \vdash e_1 + e_2 : \int
}
:::
```

You can also use code blocks with the `.mathpar` class:

```
```mathpar
```

```
``` {.mathpar}
```

```
```math {.mathpar}
```

## Quirks

Commands with symbols (e.g., `\;`) require an extra backslash, as in the following:

```
::: {.mathpar}
\alpha\\;\beta
:::
```

## Example

Here is the source code for a minimal example: [example.md](example.md).

## Version History

- v1.2.2 2024-10-09 Remove \small for better Mathjax compatibility
- v1.2.1 2024-10-09 Update \small to \small{} for better Mathjax compatibility (#14)
- v1.2.0 2024-09-28 Add basic css for mathpar blocks (#10-#13)
- v1.1.2 2024-09-24 Bugfix: Fix inferrule commands (#9)
- v1.1.1 2024-09-20 Bugfix: Non-mathpar code blocks should not be translated (#8)
- v1.1.0 2024-09-20 Add support for mathpar code blocks (#4-#7)
- v1.0.2 2024-01-12 Bugfix: Only insert commands in non-tex output (#3)
- v1.0.1 2024-01-12 Bugfix: Insert tex commands for Mathjax (#1)
- v1.0.0 2023-12-26 Initial version.
