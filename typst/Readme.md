# Typst Templates

Just add the following to your typst file:

````typ
#import "texmf/typst/sraslides.typ": *

#let title = "Making a Good Presentation"
#let author = "Max Mustermann"
#let date = datetime.today()

// Sets metadata for the document
#set document(title: title, author: author, date: date)

#show: theme.with(title: title)

// Then you can use the #title-frame and #frame functions:
#title-frame(footer: align(center)[ Custom Footer ])[
    #text(size: 45pt, fill: luh.blue)[
        *My Lecture*
    ]

    = #title

    *#author*

    Institute for Systems Engineering

    #date.display("[day]. [month repr:short] [year]")
]

// This aggregates all sections
#frame(title: "Outline")[
  #utils.polylux-outline()
]

#frame(
  title: [The Rust Programming Language],
  // This creates a new section visible in the footer and the outline.
  // You can also pass a custom name here
  new-section: true,
)[
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

// This slide is part of the previous section
#frame(title: "Hello World")[
    #box(
      inset: 1em,
      fill: luma(240),
      stroke: luma(200) + 1pt,
      radius: 0.5em
    )[```rust
      fn main() {
        println!("Hello, World!");
      }
      ```]
]
````

For more documentation, take a look at the [Polylux book](https://polylux.dev/book/polylux.html).
