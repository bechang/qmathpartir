---
title: "Mathpartir Example"
filters:
- qmathpartir
css: _extensions/qmathpartir/qmathpartir.css
---

$\infer{ }{ \Gamma, x : \tau \vdash x : \tau }$

::: {.mathpar}
e

\text{expression}\quad e ::= n \mid e_1 + e_2

\text{expression $e$}
:::

::: {.mathpar}
\text{text $\alpha\;\text{inner text}$}
:::

::: {.mathpar}
\text{alpha $\frac{1}{2}$}\quad\text{def}
:::

::: {.mathpar}
\alpha\\;\beta
:::

::: {.mathpar}
\text{softbreak}
\and

\text{hardbreak}
\\
:::

\newcommand{\tInt}{\text{int}}

::: {.mathpar}
\infer[TypePlus]{
  \Gamma \vdash e_1 : \tInt
  \and
  \Gamma \vdash e_1 : \tInt
}{
  \Gamma \vdash e_1 + e_2 : \tInt
}

\infer[TypePlus]{
  \Gamma \vdash e_1 : \tInt
  \and
  \Gamma \vdash e_1 : \tInt
}{
  \Gamma \vdash e_1 + e_2 : \tInt
}

\infer[TypePlus]{
  \Gamma \vdash e_1 : \tInt
  \and
  \Gamma \vdash e_1 : \tInt
}{
  \Gamma \vdash e_1 + e_2 : \tInt
}
:::

::: {.mathpar}
\tInt \Gamma
:::

``` {.mathpar}
\tInt \Gamma
```

```math {.mathpar}
\tInt \Gamma
```

```mathpar
\tInt \Gamma
```

```scala
val x = 3
```

$$
\Sigma
$$