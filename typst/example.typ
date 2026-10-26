#import "sraslides.typ": *

#import "@preview/pinit:0.2.2": *
#import "@preview/tiaoma:0.3.0"
#import "@preview/cetz:0.4.2"

#let title = [My Definitely Very Cool Topic]
#let author = "Hugo Houston"
#let date = datetime(day: 26, month: 10, year: 2026)

#pdfpc.config(
  duration-minutes: 25,
)

#show: sra-theme.with(
  title: title,
  author: author,
)

#title-slide(footer: [Abschlussvortrag Bachelorarbeit])[
  #text(size: 20pt)[
    *#title*
  ]

  #text(size: 16pt, fill: luh.blue)[
    #date.display("[year]")
  ]

  #v(30pt)

  #text(fill: luh.blue)[*#author* -- #link("mailto:hugo@sra.uni-hannover.de")]

  #date.display("[day]. [month repr:short] [year]")

  ```note
  Some notes...
  ```
]

== Some Normal Slide

- With some normal bullet points

- Yes this just works

- Much wow

== Theme Options

Pass presentation-wide options to the initial show rule:

```typ
#show: sra-theme.with(
  title: title,
  author: author,
  date: date,
  oss-font: true,
  colorful-emph: false,
  math-font: (font: "New Computer Modern Math"),
  quotation-font: (font: "New Computer Modern", style: "italic"),
)
```

- `oss-font` selects Universalis ADF Std instead of Rotis
- `colorful-emph: false` keeps emphasis in the surrounding text color
- Custom math and quotation fonts

= Layout and Styling

#outline(title: none, depth: 1)

== Headings Create Slides

#side-by-side[
  #title-block(fill: luh.gray)[
    ```typ
    = Layout and Styling

    #outline(title: none, depth: 1)

    == My First Slide

    - Some content

    == My Second Slide

    More content here.
    ```
  ]
][
  - ```typ =``` starts a section

  - ```typ ==``` starts a normal slide

  - The current section appears in \ the footer

  - ```typ #outline()``` creates a linked agenda
]

== Header Subtitles

#subtitle[Optional context]

```typ
== Header Subtitles

#subtitle[Optional context]
```

- A subtitle replaces the right-hand logo on this slide
- Keep it short to leave enough room for the slide title
- Other slides keep their normal header

== Lists and Emphasis

#side-by-side[
  - A top-level point
    - A smaller nested point
      - One more level

  - *Strong* and _emphasized_ text

  + First step
  + Second step
][
  #structure[Structure] / #STRUCTURE[STRUCTURE]

  #alert[Alert] / #ALERT[ALERT]

  #sample[Sample] / #SAMPLE[SAMPLE]

  #title-block(fill: luh.gray)[
    ```typ
    #structure[Structure]
    #alert[Alert]
    #sample[Sample]
    #texttt[monospace]
    ```
  ]
]

== Side-by-Side Layouts

#title-block(fill: luh.gray)[
  ```typ
  #side-by-side[
    Left column
  ][
    Right column
  ]
  ```
]

#side-by-side[
  #title-block(title: [Left Column])[
    - Explain the idea
    - Keep related points together
  ]
][
  #title-block(title: [Right Column], fill: luh.green)[
    + Show the result
    + Compare alternatives
  ]
]

== Titled Blocks

#side-by-side[
  #title-block(fill: luh.gray)[
    ```typ
    #title-block(title: [Information])[
      A normal block.
    ]

    #title-block(
      title: [Warning],
      fill: sra.red,
    )[Check your assumptions.]

    #title-block(fill: luh.green)[
      A block without a title.
    ]
    ```
  ]
][
  #title-block(title: [Information])[
    A normal block.
  ]

  #title-block(title: [Warning], fill: sra.red)[
    Check your assumptions.
  ]

  #title-block(fill: luh.green)[
    A block without a title.
  ]
]

== Customize a Block

#side-by-side[
  #title-block(fill: luh.gray)[
    ```typ
    #title-block(
      title: [Takeaway],
      fill: white,
      title-bg: sra.red,
      body-bg: luh.blue,
      title-alignment: center,
      body-alignment: left,
      radius: 0pt,
    )[
      #set text(fill: white)
      - A centered heading
      - A left-aligned body
    ]
    ```
  ]
][
  #title-block(
    title: [Takeaway],
    fill: white,
    title-bg: sra.red,
    body-bg: luh.blue,
    title-alignment: center,
    body-alignment: left,
    radius: 0pt,
  )[
    #set text(fill: white)
    - A centered heading
    - A left-aligned body
  ]
]

== Quotes and Attribution

```typ
#title-block(author: [Tim])[
  Lass das Licht aus, sonst wird der Bass leiser.
]
```

#title-block(author: [Florian])[
  Ich fahre Fahrrad immer nach Geruch, damit ich beim Fahren gleichzeitig Podcast hören und Youtube schauen kann.
]

The `author` option adds quotation marks and a right-aligned attribution.

== Code and Mathematics

#side-by-side[
  *Syntax-highlighted code*

  ```rust
  fn sum(values: &[u64]) -> u64 {
      values.iter().sum()
  }
  ```

  Use fenced code blocks with a language name, such as `rust` or `python`.
][
  *Inline and display equations*

  Inline math: $T(n) = O(n)$.

  $ sum_(i=1)^n i = (n(n + 1))/2 $

  ```typ
  Inline math: $T(n) = O(n)$.

  $ sum_(i=1)^n i = (n(n + 1))/2 $
  ```
]

== Figures and Tables

#side-by-side[
  #figure(
    image("../tex/latex/srabeamer/sra.bg/sra-logo.svg", width: 55%),
    caption: [A figure with a caption.],
  )

  #title-block(fill: luh.gray)[
    ```typ
    #figure(
      image("some/image.png", width: 55%),
      caption: [A figure with a caption.],
    )
    ```
  ]
][
  #table(
    columns: 2,
    table.header([*Variant*], [*Time*]),
    [Baseline], [10 ms],
    [Improved], [6 ms],
  )

  #title-block(fill: luh.gray)[
    ```typ
    #table(
      columns: 2,
      table.header([*Variant*], [*Time*]),
      [Baseline], [10 ms],
      [Improved], [6 ms],
    )
    ```
  ]
]

#focus-slide[
  Klausurrelevant!

  #text(size: 12pt)[
    Useful for very important messages.
  ]

  ```
  #focus-slide[Klausurrelevant!]
  ```
]

= Animations

#outline(title: none, depth: 1)

== Reveal Points Step by Step

```typ
- Visible immediately
#pause
- Revealed on the next subslide
#pause
- Revealed on the final subslide
```

- Visible immediately #pause

- Revealed on the next subslide #pause

- Revealed on the final subslide

== Uncover and Only

```typ
#uncover("2-")[Reveal from subslide two; reserve space before that.]
#only(1)[Show this text only on subslide one.]
#only("2-")[Replace it from subslide two onward.]
```

#uncover("2-")[Reveal from subslide two; reserve space before that.]

#only(1)[Show this text only on subslide one.]
#only("2-")[Replace it from subslide two onward.]

== Callback-Based Overlays <touying:skip>

#slide(repeat: 3, self => [
  #let (uncover, only) = utils.methods(self)

  ```typ
  #slide(repeat: 3, self => [
    #let (uncover, only) = utils.methods(self)
    Step #self.subslide of 3
    #uncover("2-")[An additional detail.]
    #only(3)[The final result.]
  ])
  ```

  Step #self.subslide of 3

  #uncover("2-")[An additional detail.]

  #only(3)[The final result.]
])

= Tooling

#outline(title: none, depth: 1)

== Speaker Notes and PDFPC

````typ
```note
- Explain the motivation first.
- Leave time for questions.
```
````

Notes are hidden on the slide. Export them from the project root:

```sh
typst eval --root . --in texmf/typst/example.typ \
  'query(<pdfpc-file>).first().value' > example.pdfpc
```

```note
- Explain the motivation first.
- Leave time for questions.
```
