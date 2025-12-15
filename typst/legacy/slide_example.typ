#import "sraslides.typ": *

#let title = [Making a Good Presentation]
#let author = "Max Mustermann"
#let date = datetime.today()

// Sets metadata for the document
#set document(title: title, author: author, date: date)

#show: theme.with(title: title)

// Then you can use the #title-frame and #frame functions:
#title-frame(footer: align(center)[ Custom Footer ])[
  #text(size: 25pt)[
    *My Lecture*
  ]

  = #title

  #v(30pt)

  *#author*

  #date.display("[day]. [month repr:short] [year]")
]

// This aggregates all sections
#sections-frame()

// You can also create new sections with an overview frame
#sections-frame(new: [My New Section])

// This slide is part of the previous section
#frame(title: [Normal Frame])[
  #lorem(50)

  ```note
  - Here you can add your speeker notes
  - They can be exported with typst query
  ```
]

// New frame AND new section
#frame(
  title: [The Rust Programming Language],
  // This creates a new section visible in the footer and the outline.
  // You can also pass a custom name here
  section: true,
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
    + Here are more enumerations

    + On the other side of the slide

    + ...
  ]
]

#frame(title: [Hello World])[
  #title-block(title: [Normal Block])[
    With some text as content
    - And also bullet points
  ]
  #title-block(title: [Red Error Block], fill: sra.red)[
    + This is probably very important!
  ]
  #title-block(title: [Just Some Code], fill: luh.gray)[
    ```rust
    fn main() {
        println!("Hello, World!");
    }
    ```
  ]
]
