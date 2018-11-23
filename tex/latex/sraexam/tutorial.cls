% Created:  Wed Jul 23 16:55:19 2008 by Werne
% Modified: Thu Apr 15 17:26:00 2010 by hamari
% Modified: Thu Nov 20 17:00:00 2018 by snaums
%\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{tutorial}[2018/11/20 ver 1.0]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Optionen:
%
%  - solution: Erstellt Lösungsblatt
%  - tutor: Erstellt Tutorenanweisungen
%  - globalcounting: Zählung der Aufgaben global (über Hausaufgaben und Aufgaben
%                    hinweg
%  - exam: Erstellt Klausur
%          - Punktetabelle, 
%          - Organisatorisches, 
%          - Platz für eigene Lösung bei solution-block)
%  - color: Logos in Farbe
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifprintsolution
\printsolutionfalse
\DeclareOption{solution}{\printsolutiontrue}
\DeclareOption{nosolution}{\printsolutionfalse}

\newif\ifprinttutor
\printtutorfalse
\DeclareOption{tutor}{\printtutortrue}
\DeclareOption{notutor}{\printtutorfalse}

\newif\ifexam
\examfalse
\DeclareOption{exam}{\examtrue}

\newif\ifcolor
\colorfalse
\DeclareOption{color}{\colortrue}
\DeclareOption{colour}{\colortrue}

\newif\ifglobalcounting
\globalcountingfalse
\DeclareOption{globalcounting}{\globalcountingtrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\PassOptionsToClass{a4paper,parskip=half}{scrartcl}
\ProcessOptions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LoadClass{scrartcl}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
%\RequirePackage{ngerman}
\RequirePackage{a4wide}
\RequirePackage{graphicx}
\RequirePackage{calc}
\RequirePackage{verbatim}
\RequirePackage{framed}
\RequirePackage{color}
\RequirePackage{paralist}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{geometry}
\RequirePackage{hyperref}
\RequirePackage[a-1b]{pdfx}
\RequirePackage{url}
\RequirePackage{listings}
\RequirePackage{lstautogobble}
\RequirePackage{xcolor}
\RequirePackage{textcomp}
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\RequirePackage{environ}
\RequirePackage{dataref}

%\RequirePackage{sra-tikz}
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

\newcommand{\@tut@course}{}
\newcommand{\@tut@title}{}
\newcommand{\@tut@tutor}{}
\newcommand{\@tut@tutormail}{}
\newcommand{\@tut@semester}{}
\newcommand{\@tut@uni}{}
\newcommand{\@tut@institute}{}
\newcommand{\@tut@group}{}
\newcommand{\@tut@author}{}
\newcommand{\@tut@date}{}
\newcommand{\@tut@time}{}
\newcommand{\@tut@resources}{}

\DeclareRobustCommand{\course}[1]{\renewcommand{\@tut@course}{#1}}
\DeclareRobustCommand{\title}[1]{\renewcommand{\@tut@title}{#1}}
\DeclareRobustCommand{\tutor}[1]{\renewcommand{\@tut@tutor}{#1}}
\DeclareRobustCommand{\tutormail}[1]{\renewcommand{\@tut@tutormail}{#1}}
\DeclareRobustCommand{\semester}[1]{\renewcommand{\@tut@semester}{#1}}
\DeclareRobustCommand{\uni}[1]{\renewcommand{\@tut@uni}{#1}}
\DeclareRobustCommand{\institute}[1]{\renewcommand{\@tut@institute}{#1}}
\DeclareRobustCommand{\group}[1]{\renewcommand{\@tut@group}{#1}}
\DeclareRobustCommand{\author}[1]{\renewcommand{\@tut@author}{#1}}
\DeclareRobustCommand{\date}[1]{\renewcommand{\@tut@date}{#1}}
\DeclareRobustCommand{\time}[1]{\renewcommand{\@tut@time}{#1}}
\DeclareRobustCommand{\resources}[1]{\renewcommand{\@tut@resources}{#1}}

\newcommand\csif[3]{\ifthenelse{\equal{#1}{}}{#2}{#3}}

\csif{StringTask}{}{\csdef{StringTask}{Task}}
\csif{StringSolution}{}{\csdef{StringSolution}{Solution}}
\csif{StringHomework}{}{\csdef{StringHomework}{Homework}}
\csif{StringDeadline}{}{\csdef{StringDeadline}{Deadline}}
\csif{StringPoints}{}{\csdef{StringPoints}{Points}}
\csif{StringPage}{}{\csdef{StringPage}{Page}}
\csif{StringOf}{}{\csdef{StringOf}{of}}
\csif{StringPrename}{}{\csdef{StringPrename}{First name}}
\csif{StringSurname}{}{\csdef{StringSurname}{Surname}}
\csif{StringMatriculation}{}{\csdef{StringMatriculation}{Matriculation Number}}
\csif{StringMaxPoints}{}{\csdef{StringMaxPoints}{Max points}}
\csif{StringYourPoints}{}{\csdef{StringYourPoints}{Achieved points}}
\csif{StringName}{}{\csdef{StringName}{Name}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\colorlet{darkgray}{gray!75!black}
\renewcommand{\ttdefault}{pcr}
\lstset{
  language=C,
  tabsize=4,
  basicstyle=\scriptsize\ttfamily,
  commentstyle=\color{darkgray}\slshape,
  stringstyle=\itshape,
  keywordstyle=\bfseries,
  mathescape=true,
  upquote=true,
  columns=fixed,
  showstringspaces=false,
  extendedchars=true,
  breaklines=true,
  prebreak = \raisebox{0ex}[0ex][0ex]{\ensuremath{\hookleftarrow}},
  frame=single,
  showtabs=false,
  showspaces=false,
  showstringspaces=false,
  %identifierstyle=\ttfamily\textbf,
  numbers=left, 
  numberstyle=\tiny, 
  numbersep=7pt,
}

\geometry{left=20mm,textwidth=17cm,top=20mm,textheight=25cm}
%\setlength{\parindent}{0em}

\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\lfoot{\@tut@course}
\cfoot{\csuse{StringPage} \thepage{} \csuse{StringOf} \pageref*{LastPage}}
\rfoot{\@tut@semester}

\AtBeginDocument{\titlepage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{cntask}                    % Zähler für laufende Aufgaben
\newcounter{cnsubtask}
\newcounter{cnhomework}
\newcounter{cnsubhomework}

\ifglobalcounting
  \newcommand\hwc{cntask}
  \newcommand\hwsc{cnsubtask}
\else
  \newcommand\hwc{cnhomework}
  \newcommand\hwsc{cnsubhomework}
\fi 
\let\parentTask\relax

\newenvironment{task}[2][]
{
  \refstepcounter{cntask}
  \setcounter{cnsubtask}{0}
  \csif{#2}{\csdef{tasktitle}{}}{\csdef{tasktitle}{- #2}} % title
  \csif{#1}{\csdef{points}{}}{\csdef{points}{\hfill {\normalfont\normalsize{#1 \csuse{StringPoints}}}}} %% points  
  
  \section*{\textsc{\csuse{StringTask} \arabic{cntask} \csuse{tasktitle} \csuse{points}}}%
  \addcontentsline{toc}{section}{\csuse{StringTask} \arabic{cntask} \csuse{tasktitle}}
  
  \nopagebreak[4]
}
{
}

\newenvironment{subtask}[2][]
{
  \refstepcounter{cnsubtask}
  \csif{#2}{\csdef{tasktitle}{}}{\csdef{tasktitle}{- #2}} % title
  \csif{#1}{\csdef{points}{}}{\csdef{points}{\hfill {\normalfont\normalsize{#1 \csuse{StringPoints}}}}} %% points
  
  \subsection*{\textsc{\csuse{StringTask} \arabic{cntask}.\arabic{cnsubtask} \csuse{tasktitle} \csuse{points}}}%
  \addcontentsline{toc}{subsection}{\csuse{StringTask} \arabic{cntask}.\arabic{cnsubtask} \csuse{tasktitle}}
  \nopagebreak[4]
}
{
}

\newenvironment{homework}[2][]
{
  \refstepcounter{\hwc}
  \setcounter{\hwsc}{0}
  \csif{#1}{\csdef{hometitle}{}}{\csdef{hometitle}{- #1}}
  \section*{\textsc{\csuse{StringHomework} \arabic{\hwc} \csuse{hometitle} \hfill {\normalfont\normalsize{#2 \csuse{StringPoints}}}}}%
  \addcontentsline{toc}{section}{\csuse{StringHomework} \arabic{\hwc} \csuse{hometitle}}
  \nopagebreak[4]
}
{

}

\newenvironment{subhomework}[2][]
{
  \refstepcounter{\hwsc}
  \csif{#1}{\csdef{hometitle}{}}{\csdef{hometitle}{- #1}}
  \subsection*{\textsc{\csuse{StringHomework} \arabic{\hwc}.\arabic{\hwsc} \csuse{hometitle} \hfill {\normalfont\normalsize{#2 \csuse{StringPoints}}}}}%
  \addcontentsline{toc}{subsection}{\csuse{StringHomework} \arabic{\hwc}.\arabic{\hwsc} \csuse{hometitle}}
  \nopagebreak[4]
}
{
}


\NewEnviron{solution}[1][]
{
  \ifprintsolution
    \definecolor{shadecolor}{rgb}{0.9,0.9,0.9}%
    \ifprintsolution\medskip\snugshade\begingroup\smallskip%
    \setlength{\linewidth}{\textwidth}%
    \setlength{\@totalleftmargin}{\z@}%
    \list{}{%
      \setlength{\leftmargin}{0.8em}%
      \setlength{\rightmargin}{0.8em}%
      \setlength{\listparindent}{\parindent}%
      \setlength{\itemindent}{\z@}%
      \setlength{\topsep}{\z@}%
      \setlength{\parsep}{\parskip}%
      \setlength{\partopsep}{\z@}%
      \setlength{\labelwidth}{\z@}%
      \let\makelabel\@gobble%
      \@listdepth=0}%
    \item\relax%
    \else\expandafter\comment\fi
      \BODY
    \ifprintsolution\endlist%
    \smallskip\endgroup\endsnugshade\medskip%
    \else\expandafter\endcomment\fi
  \else
    \ifexam
      \vspace*{#1}
    \fi 
  \fi
}

\newenvironment{tutornote}
{\definecolor{shadecolor}{rgb}{0.9,0.9,0.9}%
\ifprinttutor\medskip\snugshade\begingroup\smallskip%
\setlength{\linewidth}{\textwidth}%
\setlength{\@totalleftmargin}{\z@}%
\list{}{%
  \setlength{\leftmargin}{0.8em}%
  \setlength{\rightmargin}{0.8em}%
  \setlength{\listparindent}{\parindent}%
  \setlength{\itemindent}{\z@}%
  \setlength{\topsep}{\z@}%
  \setlength{\parsep}{\parskip}%
  \setlength{\partopsep}{\z@}%
  \setlength{\labelwidth}{\z@}%
  \let\makelabel\@gobble%
  \@listdepth=0}%
\item\relax%
\else\expandafter\comment\fi}
{\ifprinttutor\endlist%
\smallskip\endgroup\endsnugshade\medskip%
\else\expandafter\endcomment\fi}

\newcommand\examName{
  \begin{center}
    \renewcommand*{\arraystretch}{2}
    \begin{tabular}{|l|p{7cm}|}
    \hline
      \csuse{StringPrename}: & \\
    \hline
      \csuse{StringSurname}: & \\
    \hline
      \csuse{StringMatriculation}: & \\
    \hline
    \end{tabular}
  \end{center}
}

\def\do#1{\accumulateTasks #1\@end}
\newcommand\examPoints{
    \renewcommand*{\arraystretch}{2}
    \begin{center}
    \begin{tabular}{|l|l|l|}\hline
        \csuse{StringTask} & \csuse{StringMaxPoints} & \csuse{StringYourPoints} \\
        \hline

        \hline\hline
        Total & - & \\
        \hline
    \end{tabular}
    \end{center}
}

\newcommand\examOrg{
  %\ifthenelse{\equal{\@tut@resources}{}}{\csdef{res}{Es sind keine Hilfsmittel zugelassen.}{Folgende Hilfsmittel sind zugelassen: \begin{itemize}\@tut@resources\end{itemize}}}

  \subsection*{Hinweise zur Klausur}
    \begin{itemize}
      \item Überprüfen Sie die Aufgabenblätter auf Vollständigkeit. Die Klausur umfasst \pageref*{LastPage} Seiten inkl. Deckblatt. Schreiben Sie Ihren Namen und Matrikelnummer leserlich auf jedes zu bewertende Blatt.
      \item Schreiben Sie Ihre Lösungen in die freien Flächen bzw. an die dafür vorgesehenen Stellen. Zusätzliche Blätter sind zugelassen und zur Korrektur bitte mit abzugeben.
      \item Für die Klausur haben Sie eine Bearbeitungszeit von \@tut@time{} Minuten.
      \item Bitte schalten Sie Ihr Handy aus. 
      \item \csuse{res}
    \end{itemize}
}
\newcommand\examExtra{}


\renewcommand{\titlepage}
{

  \vspace*{-1cm}
  \begingroup
  \sffamily
  \noindent
  \begin{minipage}[c]{10cm}
    \begin{minipage}[l]{1.5cm}
      \ifcolor
        \includegraphics[height=1.5cm,keepaspectratio]{fig/sra_color}
      \else
        \includegraphics[height=1.5cm,keepaspectratio]{fig/sra_bw}
      \fi
    \end{minipage}
    \hfill 
    \ifexam
      \begin{minipage}[r]{8.25cm}{\small
        \@tut@uni\\
        \@tut@institute \\
        \@tut@group
        }
      \end{minipage}
    \else
      \begin{minipage}[r]{8.25cm}{\small
        \@tut@tutor \\
        \@tut@tutormail \\ 
        \@tut@semester}
      \end{minipage}
    \fi
  \end{minipage}
  \hfill
  \begin{minipage}[r]{6cm}
    \hfill
    \ifcolor
      \includegraphics[height=1.5cm,keepaspectratio]{fig/luh_color}
    \else
      \includegraphics[height=1.5cm,keepaspectratio]{fig/luh_bw}
    \fi
  \end{minipage}
  
  \begin{center}
  \ifexam
    {\Huge\@tut@course} \\[1.6ex]
    {\bfseries\LARGE\@tut@author} \\[3.5ex]
    {\large\@tut@date}
  \else
    {\bfseries\LARGE\@tut@course} \\[3.5ex]
    {\Huge\@tut@title} \\[1.6ex]
    \vspace{.4cm}
  \fi 
  \normalsize
  %\begin{tabular}[t]{c}
  %\@tut@tutor\\
  %(\@tut@tutormail)
  %\end{tabular}
  \end{center}
  \endgroup
  
  \ifexam
    \examName{}
    \examPoints{}
    \examOrg{}
    \examExtra{}
    \cleardoublepage
    \renewcommand{\headrulewidth}{0.4pt}
    \lhead{\csuse{StringName}: \hfill \csuse{StringMatriculation}:\hspace*{4cm}}
    %\renewcommand{\headrulewidth}{0.1mm}
    %\lhead{\csuse{StringSurname}, \csuse{StringPrename}: \hfill \csuse{StringMatriculation}:\hspace*{4cm}}
  
  \fi
  %\bigskip
  %\bigskip

}

\endinput
