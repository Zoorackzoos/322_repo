# LaTeX Compendium (Overleaf Reference)

## 1. Basic Document Structure

```latex
\documentclass{article}

\usepackage[utf8]{inputenc}
\usepackage{amsmath, amssymb}
\usepackage{graphicx}
\usepackage{hyperref}

\title{Your Title}
\author{Your Name}
\date{\today}

\begin{document}

\maketitle

\section{Introduction}
Hello world!

\end{document}
```

---

## 2. Sections & Organization

```latex
\section{Section}
\subsection{Subsection}
\subsubsection{Subsubsection}
\paragraph{Paragraph}
```

Table of contents:

```latex
\tableofcontents
```

---

## 3. Text Formatting

```latex
\textbf{Bold}
\textit{Italic}
\underline{Underline}
\texttt{Monospace}
\emph{Emphasis}
```

---

## 4. Math Mode

### Inline Math

```latex
$ a^2 + b^2 = c^2 $
```

### Display Math

```latex
\[ a^2 + b^2 = c^2 \]
```

### Equation Environment

```latex
\begin{equation}
E = mc^2
\end{equation}
```

Unnumbered:

```latex
\begin{equation*}
E = mc^2
\end{equation*}
```

---

## 5. Common Math Symbols

```latex
\alpha \beta \gamma \delta
\pi \theta \lambda

\sum \int \infty
\approx \neq \leq \geq
```

---

## 6. Fractions, Powers, Roots

```latex
\frac{a}{b}
x^2
\sqrt{x}
\sqrt[n]{x}
```

---

## 7. Brackets & Sizing

```latex
\left( \frac{a}{b} \right)
\left[ x^2 \right]
\left\{ x \right\}
```

---

## 8. Matrices & Linear Algebra

```latex
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
```

Augmented matrix:

```latex
\begin{bmatrix}
1 & 2 & | & 3 \\
0 & 1 & | & 4
\end{bmatrix}
```

Other types:

```latex
pmatrix  % ()
vmatrix  % determinant
```

Vectors:

```latex
\vec{v}
\mathbf{v}
```

---

## 9. Aligning Equations

```latex
\begin{align}
a &= b + c \\
d &= e + f
\end{align}
```

No numbering:

```latex
\begin{align*}
...
\end{align*}
```

---

## 10. Cases / Piecewise Functions

```latex
\begin{cases}
x^2 & x > 0 \\
0 & x \leq 0
\end{cases}
```

---

## 11. Systems of Equations

```latex
\begin{cases}
x + y = 1 \\
2x - y = 3
\end{cases}
```

---

## 12. Lists

### Itemized

```latex
\begin{itemize}
  \item Item 1
  \item Item 2
\end{itemize}
```

### Enumerated

```latex
\begin{enumerate}
  \item First
  \item Second
\end{enumerate}
```

---

## 13. Tables (Advanced)

```latex
\usepackage{booktabs}

\begin{tabular}{cc}
\toprule
A & B \\
\midrule
1 & 2 \\
\bottomrule
\end{tabular}
```

---

## 14. Images

```latex
\begin{figure}[h]
  \centering
  \includegraphics[width=0.5\textwidth]{image.png}
  \caption{Your caption}
  \label{fig:example}
\end{figure}
```

---

## 15. References & Labels

```latex
\label{sec:intro}
\ref{sec:intro}
```

---

## 16. Hyperlinks

```latex
\href{https://example.com}{Link text}
```

---

## 17. Comments

```latex
% This is a comment
```

---

## 18. Useful Packages

```latex
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{geometry}
\usepackage{xcolor}
\usepackage{fancyhdr}
\usepackage{booktabs}
```

---

## 19. Page Layout & Headers

```latex
\usepackage[margin=1in]{geometry}

\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhead[L]{Left}
\fancyhead[R]{Right}
```

---

## 20. Code Blocks (Better)

```latex
\usepackage{listings}

\begin{lstlisting}
int main() {
  return 0;
}
\end{lstlisting}
```

---

## 21. Custom Commands

```latex
\newcommand{\R}{\mathbb{R}}
\newcommand{\vecb}[1]{\mathbf{#1}}
```

---

## 22. Math Tricks

Text in math:

```latex
\text{if } x > 0
```

Operators:

```latex
\sin \cos \log \ln
```

Limits:

```latex
\lim_{x \to \infty}
```

---

## 23. Spacing

```latex
a\,b   % small space
a\quad b
a\qquad b
```

---

## 24. Theorem Environments

```latex
\usepackage{amsthm}

\newtheorem{theorem}{Theorem}

\begin{theorem}
Statement here
\end{theorem}
```

---

## 25. Colors

```latex
\usepackage{xcolor}

\textcolor{red}{Hello}
```

---

## 26. Footnotes

```latex
Hello\footnote{This is a footnote}
```

---

## 27. Bibliography (Basic)

```latex
\begin{thebibliography}{9}
\bibitem{ref1} Author, Title
\end{thebibliography}
```

---

## 28. Common Errors & Fixes

* Missing `$` → math won’t compile
* Forgetting `\end{}` → crash
* Extra `&` → alignment error
* File not found → check path

---

## 29. Debugging Strategy

1. Comment out sections
2. Recompile
3. Narrow error
4. Fix syntax

---

## 30. Minimal Template

```latex
\documentclass{article}
\usepackage{amsmath, amssymb, graphicx}

\begin{document}

Your content here.

\end{document}
```

## 31. New page
\ newpage


---

End of Compendium
