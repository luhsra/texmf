# Typst Templates

Just add the following to your typst file:

```typ
#import "texmf/typst/sraslides.typ": *

#let title = [ Making a Good Presentation ]

#show: theme.with(title: title)

// Then you can use the #title-frame and #frame functions:
#title-frame(footer: align(center)[ Custom Footer ])[
    #text(size: 45pt, fill: luh.blue)[
        *My Lecture*
    ]

    = #title

    #v(45pt)

    *Max Mustermann*

    Institute for Systems Engineering

    #datetime.today().display("[day]. [month repr:short] [year]")
]

#frame(title: [The Rust Programming Language])[
    #side-by-side[
        - Developed by Mozilla in 2015
            - Independent Rust Foundation

        - Used in Firefox, Linux (Asahi), Windows

        - Increasing relevance for science
            - FGBS'23: 36.84% of the talks \
                mentioned Rust

        - Concepts from C/C++, Python, Haskell
    ][
        - Here are more bullet points

        - On the other side of the slide

        - ...
    ]
]
```
