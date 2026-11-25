#import "sraslides.typ": *


#let title = [My Definitely Very Cool Topic]
#let author = "Hugo Houston"
#let date = datetime(day: 26, month: 10, year: 2026)

#pdfpc.config(
  duration-minutes: 25,
)

#show: sra-lecture-theme.with(
  author: author,
  title: title,
  date: datetime.today(),
  lecture: (
    title: title,
    author: author,
    short: [SI2],
    term-long: "Winter",
    term-short: "WS",
    year: "26",
    sem-short: "WS26",
    sem-long: "Winter 2026",
    overview: [Überblick],
    part: [Teil],
    mail: "si",
    web: "V_SI2",
  ),
  enable-btUseExtraItemSep: true,
)

#title-slide-lecture()[]

#overview-slide-lecture("Veranstaltungsüberblick")

= Options and Theming

== Basics

=== Section about normal slides

==== Some Normal Slide

- With some normal bullet points

- Yes this just works

- Much wow

==== And another
1. enumerating
2. and referencing
3. content #link-chapter(<sec:pdfpc>)

==== Theme Options

Pass presentation-wide options to the initial show rule:

```typ
#show: sra-lecture-theme.with(
  title: title,
  author: author,
  date: date,
  font: fonts.oss,
  colorful-emph: false,
  math-font: (font: "New Computer Modern Math"),
  quote-font: (font: "New Computer Modern", style: "italic"),
  text-size: 10.5pt,    // defaults to smaller sizes
  title-size: 14.5pt,   // than sra-theme
  subtitle-size: 9pt,   // to match latex's
  footer-size: 6pt,     // text sizes
  enable-btUseExtraItemSep: true,
)
```

- `font: fonts.oss` selects Universalis ADF Std instead of Rotis
- `colorful-emph: false` keeps emphasis in the surrounding text color
- `math-font` and `quote-font` customize equation and inline quote text

=== Layout

==== Headings Create Slides

#side-by-side[
  #title-block(fill: luh.gray)[
    ```typ
    = Orga and Intro
    == Organization
    === Topics
    ==== My First Slide
    - Some content
    == My Second Slide

    #overview-slide-lecture("Veranstaltungsüberblick")
    More content here.

    ==== Slide C
    - Some mode content

    == Fundamental Concepts
    === computers
    ==== What is a computer?
    ```
  ]
][
  - ```typ =``` starts a part

  - ```typ ==``` starts a "lecture/topic"
  - ```typ ===``` starts a section
  - ```typ ====``` starts a normal slide

  - The current section appears in \ the footer

  - ```typ #overview-slide-lecture("Agenda")``` creates a linked agenda
]

==== Header Subtitles

#subtitle[Optional context]

```typ
==== Header Subtitles

#subtitle[Optional context]
```

- A subtitle replaces the right-hand logo on this slide
- Keep it short to leave enough room for the slide title
- Other slides keep their normal header


==== Very long titles make the right logo dissappear to make some more space

- more lengthly titles
- more space
- more buzzword bingo in slide titles

= Lecture on Styling

== Borrowed Chapter

=== Styling

#heading-depth-offset(2)[
  #include-chapter("typst/example-shared-content.typ")
]

= Expert stuff

== Tooling

=== Speaker Notes and PDFPC
<sec:pdfpc>

````typ
```note
- Explain the motivation first.
- Leave time for questions.
```
````

Notes are hidden on the slide. Export them from the project root:

```sh
typst eval --root . --in texmf/typst/example-lecture.typ \
  'query(<pdfpc-file>).first().value' > example-lecture.pdfpc
```

```note
- Explain the motivation first.
- Leave time for questions.
```
