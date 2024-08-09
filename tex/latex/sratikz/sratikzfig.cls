\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sratikzfig}[2020/10/01 The SRA TikZ/Beamer Figure Class]  % YYYY/MM/DD
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax

\IfFileExists{luatex85.sty}{\RequirePackage{luatex85}}{}
\LoadClass{beamer}

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{beamertools}
\RequirePackage[active,tightpage]{preview}
\RequirePackage{wasysym}
\RequirePackage{marvosym}
\RequirePackage{helvet}
\RequirePackage{lmodern}
\RequirePackage[scaled=0.85]{beramono}


\RequirePackage{tikz}

\PreviewEnvironment{tikzpicture}
  \usetikzlibrary{
    calc,
    fit,
    decorations.pathreplacing,
    backgrounds,
    decorations.text,
    shapes,
    shapes.misc,
    shapes.geometric,
    patterns,
    positioning,
    tikzmark,
    matrix,
    arrows,
    arrows.meta,
    chains,
    sra
  }
  \pgfdeclarelayer{background2}
  \pgfdeclarelayer{background}
  \pgfdeclarelayer{foreground}
  \pgfsetlayers{background2,background,main,foreground}


\RequirePackage{sra-color}

\RequirePackage{pgffor}


\tikzset{
  >=Stealth,
  every tikzpicture/.style={\sffamily},
}

\newcommand{\tikznode}[2][]{%
  \tikz[baseline]\node[anchor=base,#1]{#2};%
}

\setbeamercolor{structure}{fg=luhblue,bg={}}
\setbeamercolor{alerted text}{fg=srared}
\colorlet{beamergreen}{luhgreen!80!black}
\setbeamercolor{example text}{fg=beamergreen}

\newenvironment<>{visible}[1][]{\begin{scope}[visible on={#2},#1]}{\end{scope}}

\setbeamercolor{itemize item}{fg=srared}
\setbeamercolor{itemize subitem}{fg=luhgray}
\setbeamercolor{itemize subsubitem}{fg=luhgray}

\setbeamertemplate{itemize item}{\raise.5pt\hbox{\vrule width 1ex height 1ex}}
\setbeamertemplate{itemize subitem}{\raise.5pt\hbox{\vrule width 0.8ex height 0.8ex}}
\setbeamertemplate{itemize subsubitem}{\raise.5ex\hbox{\vrule width 1ex height 0.2ex}}

\setlength{\labelwidth}{2em}
\setlength{\labelsep}{0.5em}
\setlength{\leftmargini}{1em}
\setlength{\leftmarginii}{1em}
\setlength{\leftmarginiii}{1em}
