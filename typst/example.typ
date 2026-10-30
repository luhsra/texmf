#import "sraslides.typ": *

#import "@preview/pinit:0.2.2": *
#import "@preview/tiaoma:0.3.0"
#import "@preview/cetz:0.5.3"

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

#include "example-shared-content.typ"

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
