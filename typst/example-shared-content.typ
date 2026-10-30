#import "sraslides.typ": *

= Components

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

= Titled Blocks, aka btBlock

== Titled Blocks
#title-block(
  fill: orange,
  position: (7cm, -.8cm),
  title: [abs. placement],
  width: 5cm,
  colorful-emph: true,
)[*somewhere* else on the _page_]

#side-by-side[
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
```typ
#title-block(author: [Tim])[
  Lass das Licht aus, sonst wird der Bass leiser.
]
```

#title-block(author: [Florian])[
  Ich fahre Fahrrad immer nach Geruch, damit ich beim Fahren gleichzeitig Podcast hören und Youtube schauen kann.
]

#title-block(author: <vitruvius:27bc>)[
  Schönheit, Stabilität, Nützlichkeit --- _Venustas_, _Firmitas_, _Utilitas_.
]

- The `author` option adds quotation marks and a right-aligned attribution.
- if author is a ref (`<vitruvius:27bc>`), it get's formated

= Environments


== Colors
Defined in sra-colors.typ

#for (space-name, space) in (sra: sra, luh: luh, safe: safe, rs: rs) [

  == #space-name Colors
  #show: columns.with(4)
  #for (k, c) in space [
    #show: par
    #box(fill: c, width: 3mm, height: 3mm) #raw(space-name + "." + k)
  ]
]
== Other colors
#for (k, c) in (badbee: badbee, beamergreen: beamergreen) [
  #show: par
  #box(fill: c, width: 3mm, height: 3mm) #raw(k)
]


= Environments

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

= Bibliography
#show heading: set heading(outlined: false, bookmarked: true)
#let bib-files = (
  // "bib/sra/sra-ext.bib",
  // "bib/sra/sra-own.bib",
  "example.bib",
  // "bib/wosch.bib",
)

#slide(config: utils.merge-dicts(
  (:),
  config-page(
    header: slide-header(title: [Quellenverzeichnis]),
    footer: none,
  ),
  config-common(breakable: true),
))[
  #set text(size: 7.4pt)
  #set par(leading: 0.4em, spacing: 0.5em)
  #bibliography(bytes(bib-files.map(read).join("\n")), title: none)
]
