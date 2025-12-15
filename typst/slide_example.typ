#import "sraslides.typ": *

#let title = [Making a Good Presentation]
#let subtitle = [An Example Presentation]
#let author = "Max Mustermann"
#let date = datetime.today()

// Apply the sra theme
#show: sra-theme.with(
  title: title,
  author: author,
  date: date,
)

// Configure pdfpc
#pdfpc.config(
  duration-minutes: 20,
  default-transition: none,
)


// Create your own custom title slide
#title-slide(footer: [ Custom Footer ])[
  #text(size: 25pt)[
    *#title*
  ]

  #v(10pt)
  #text(size: 16pt, fill: luh.blue, subtitle)

  #v(30pt)

  *#author*

  #date.display("[day]. [month repr:short] [year]")
]

// Level 2 headings separate slides
== Example Slide

#lorem(20)

#pause
*This is revealed after in the next step.*


// Level 1 headings separate sections
= My new section

// This shows all sections
#outline(title: none, depth: 1)


// This slide is part of the previous section
== Normal Frame
#lorem(50)

```note
- Here you can add your speeker notes
- They can be exported with typst query
```

// New section without a new slide
= Rust Language

== The Rust Programming Language
#side-by-side[
  - Developed by Mozilla in 2015
    - Independent Rust Foundation

  #pause
  - Used in Firefox, Linux (Asahi), Windows

  #pause
  - Increasing relevance for science
    - FGBS'23: 36.84% of the talks \
      mentioned Rust

  #pause
  - Concepts from C/C++, Python, Haskell
][
  #pause
  + Here are more enumerations
  + On the other side of the slide

  + ...
]

== Hello World

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
