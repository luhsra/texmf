#import "sraslides.typ": *

== Lists

#side-by-side[
  - A top-level point
    - A smaller nested point
      - One more level
      #item-ra[other marker]

  - *Strong* and _emphasized_ text

  + First step
  + Second step
][
  #title-block(fill: luh.gray)[
    ```typ
    - A top-level point
      - A smaller nested point
        - One more level
        #item-ra[other marker]

    - *Strong* and _emphasized_ text

    + First step
    + Second step
    ```
  ]
]

== Slide-local list spacing

#btNoExtraItemSep()

- `#btUseExtraItemSep()` adds `6.75pt` / `3.75pt` / `0.75pt` to normal list spacing.
- `#btNoExtraItemSep()` disables it for this slide.
- Without a marker, `enable-btUseExtraItemSep` supplies the default.

```typ
== A compact slide
#btNoExtraItemSep()
- First point
- Second point

== A spacious slide
#btUseExtraItemSep()
- First point
- Second point
```

Markers apply to the whole slide, regardless of placement. The last marker wins.
Explicit per-list spacing is preserved. Numbered lists count toward nesting depth but retain their own spacing.

== Slide with normal spacing
#btNoExtraItemSep()
- Top
  + second
    - third
      - fourth
    - third
  + second again
- top again
  - second second
  - second fooo
  - bar
- foobar
  - barfoo

== Slide with extra spacing
#btUseExtraItemSep()
- Top
  + second
    - third
      - fourth
    - third
  + second again
- top again
  - second second
  - second fooo
  - bar
- foobar
  - barfoo

== Emphasis

#side-by-side[
  #structure[structure] / #Structure[Structure] / #STRUCTURE[STRUCTURE]

  #alert[alert] /   #Alert[Alert] / #ALERT[ALERT]

  #sample[sample] / #Sample[Sample] / #SAMPLE[SAMPLE]
][

  #title-block(fill: luh.gray)[
    ```typ
    #structure[structure]
    #Structure[Structure]
    #STRUCTURE[STRUCTURE]

    #alert[alert]
    #Alert[Alert]
    #ALERT[ALERT]

    #sample[sample]
    #Sample[Sample]
    #SAMPLE[SAMPLE]
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
#title-block(
  fill: orange,
  position: (7cm, -.8cm),
  title: [abs. placement],
  width: 5cm,
  colorful-emph: true,
)[*somewhere* else on the _page_]

#side-by-side[
  #v(-1pt) // fix content overflow
  #title-block(fill: luh.gray, local-emph: false)[
    ```typ
    #title-block(title: [Information])[
      A ^normal^ block.
    ]
    #title-block(
      title: [Warning],
      fill: sra.red,
      visible: "2"
    )[visible on slide 2]
    #title-block(fill: beamergreen)[
      A block #local[without] a title.
    ]
    #title-block(
      fill: orange,
      position: (7cm, -.8cm),
      title: [abs. placement],
      width: 4cm,
      colorful-emph: true
    )[*somewhere* else on the _page_]
    ```
  ]
][
  #title-block(title: [Information])[
    A ^normal^ block.
  ]

  #title-block(title: [Warning], fill: sra.red, visible: 2)[
    visible on slide 2
  ]

  #title-block(fill: luh.green)[
    A block #local[without] a title.
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

Simple citation @murray:93:sarc

#title-block(author: [Florian])[
  Ich fahre Fahrrad immer nach Geruch, damit ich beim Fahren gleichzeitig Podcast hören und Youtube schauen kann.
]

#title-block(author: <vitruvius:27bc>)[
  Schönheit, Stabilität, Nützlichkeit --- _Venustas_, _Firmitas_, _Utilitas_.
]

- The `author` option adds quotation marks and a right-aligned attribution.
- if author is a ref (`<vitruvius:27bc>`), it get's formated

== Colors
Defined in sra-colors.typ

#let show-colors(prefix, ..colors) = {
  for (k, c) in colors.named() [
    #show: par
    #set text(0.9em)
    #box(fill: c, width: 3mm, height: 3mm)~#raw(if prefix != none { prefix + "." } else { "" } + k)
  ]
}

#side-by-side[
  *SRA*
  #show-colors("sra", ..sra)
  *RS von Jürgen*
  #show-colors("rs", ..rs)
][
  *General*
  #show-colors(none, badbee: badbee, beamergreen: beamergreen)
]

#for (space-name, space) in (luh: luh, safe: safe) [
  == #space-name Colors
  #columns(3, show-colors(space-name, ..space))
]

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

== In-Line Figures with cetz
#cetz.canvas({
  import cetz.draw: *
  content((), name: "start", frame: "rect", padding: 4pt)[From here]
  content((rel: (5, 2), to: "start"), name: "end", frame: "rect", padding: 4pt)[To here]
  rounded-line(
    "start.east",
    (rel: (10pt, 0pt)),
    (rel: (10pt, 10pt)),
    (rel: (20pt, -10pt)),
    (rel: (20deg, 50pt)),
    (),
    (rel: (100deg, 50pt)),
    (rel: (30deg, 15pt)),
    (rel: (10pt, 0pt)),
    (rel: (0pt, 10pt), to: "end.north"),
    "end.north",
    radius: 20pt,
    stroke: 2pt + sra.red,
    name: "line",
  )
  circle(
    (rel: (20deg, 50pt), to: (rel: (40pt, 0pt), to: "line.start")),
    radius: 5pt,
    stroke: 1.5pt + black,
    name: "edge",
  )
  content("edge", anchor: "north-west", padding: 4pt)[Sharp edge]
})

== Animation: Reveal Points Step by Step

#btNoExtraItemSep()

```typ
- Visible immediately
  #pause

- Revealed on the next subslide
  #pause

- Revealed on the final subslide
```

- Visible immediately
  #pause

- Revealed on the next subslide
  #pause

- Revealed on the final subslide

== Animation: Uncover and Only

```typ
#uncover("2-")[Reveal from subslide two; reserve space before that.]
#only(1)[Show this text only on subslide one.]
#only("2-")[Replace it from subslide two onward.]
```

#uncover("2-")[Reveal from subslide two; reserve space before that.]

#only(1)[Show this text only on subslide one.]
#only("2-")[Replace it from subslide two onward.]

== Advanced: Callback-Based Overlays

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

== Quellenverzeichnis

#slide(config: config-common(breakable: true))[
  #let bib-files = (
    // "bib/sra/sra-ext.bib",
    // "bib/sra/sra-own.bib",
    "example.bib",
    // "bib/wosch.bib",
  )

  #set par(leading: 0.4em, spacing: 0.5em)
  #bibliography(bytes(bib-files.map(read).join("\n")), title: none)
]
