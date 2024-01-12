# Qmathpartir: Mathpartir Extension For Quarto

This Quarto (and Pandoc) filter implements a partial compatibility package for Didier Remy's LaTeX 2e package `mathpartir.sty`.

## Installing

```bash
quarto add bechang/qmathpartir
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

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

## Quirks

Commands with symbols (e.g., `\;`) require an extra backslash, as in the following:

```
::: {.mathpar}
\alpha\\;\beta
:::
```

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

## Version History

v1.0.1 2023-01-12 Bugfix: Insert tex commands for Mathjax (#1)
v1.0.0 2023-12-26 Initial version.