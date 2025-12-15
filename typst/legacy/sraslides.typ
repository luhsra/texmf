#import "logic.typ" as logic

#import "logic.typ": (
  alternatives, alternatives-cases, alternatives-fn, alternatives-match,
  enum-one-by-one, line-by-line, list-one-by-one, one-by-one, only, pause,
  paused-content, polylux-slide, terms-one-by-one, uncover,
)

#import "utils.typ" as utils
#import "utils.typ": polylux-outline, side-by-side

#import "pdfpc.typ" as pdfpc

/// SRA Colors
#let sra = (
  red: rgb(208, 38, 38),
  /// Daniel tends to use this
  orange: orange.lighten(70%),
)
/// LUH Colors
#let luh = (
  green: rgb(177, 201, 32),
  blue: rgb(0, 80, 155),
  lightblue: rgb(204, 220, 235),
  lighterblue: rgb(230, 238, 245),
  gray: rgb(128, 128, 128),
  lightgray: rgb(220, 222, 222),
)

// Additional colors
// Colors Daniel tends to use in his slides
#let beamergreen = luh.green.darken(20%)
#let badbee = rgb("#cbb750")

/// Black'n White Safe colorbrewer colors
#let safe = (
  yellow: rgb("#ffffbf"),
  orange: rgb("#fc8d59"),
  red: rgb("#d95f0e"),
  lightred: rgb("#fee0d2"),
  blue: rgb("#2b8cbe"),
  middleblue: rgb("#a6bddb"),
  lightblue: rgb("#ece7f2"),
  green: rgb("#31a354"),
  middlegreen: rgb("#addd8e"),
  lightgreen: rgb("#f7fcb9"),
)

// Images
#let sra-logo = image.with("../../tex/latex/srabeamer/sra.bg/sra-logo.svg")
#let luh-logo = image.with("../../tex/latex/srabeamer/sra.bg/luh-logo-rgb.svg")

// Counter for the list depth
#let list-depth = counter("list-depth")

/// Create the header block
///
/// - title (content): Title
/// - left-logo (image): Left logo
/// - right-logo (image): Right logo
#let frame-header(
  title: [],
  left-logo: sra-logo,
  right-logo: luh-logo,
  first-subslide: true,
) = box(inset: (x: -7mm + 3mm, y: 1.7mm), grid(
  columns: (auto, 1fr, auto),
  column-gutter: 5mm,
  grid.cell(align: top + left, left-logo(height: 5.5mm)),
  grid.cell(align: top + left, block(
    inset: (top: 0.7mm),
    // only register a heading for the first logical slide
    if first-subslide {
      heading(depth: 2, text(fill: luh.blue, size: 16pt, title))
    } else {
      text(fill: luh.blue, size: 16pt, title)
    },
  )),
  grid.cell(align: top + right, right-logo(height: 5.5mm)),
))


/// Create a footer block
///
/// - numbering (bool): Show frame number
/// - section (bool): Show current section
/// - authors (content, none): Show the given authors in the footer
#let frame-footer(
  numbering: true,
  section: false,
  authors: none,
  body,
) = align(left + bottom, block(
  fill: luh.lightgray,
  width: 100%,
  height: 5mm,
  outset: (x: 7mm),
  inset: (
    left: -7mm + 3mm + 5.5mm + 5mm,
    right: -7mm + 3mm + if not numbering { 5.5mm + 5mm },
  ),
  {
    set text(size: 7pt, fill: luh.gray)
    set align(horizon)

    if authors != none {
      body = [#authors #h(2em) #body]
    }
    if section {
      let suffix = context {
        let sections = utils.sections-state.get()
        if sections.len() > 0 {
          [--- #sections.last().body]
        }
      }
      body = [#body #suffix]
    }

    if numbering {
      grid(
        columns: (1fr, auto),
        rows: 100%,
        body,
        [
          #let curr = context {
            logic.logical-slide.display()
          }
          #place(top + right, rect(fill: luh.green, width: 19mm, height: 1mm))
          #align(right)[#curr - #utils.last-slide-number #h(2mm)]
        ],
      )
    } else {
      body
    }
  },
))

/// Create a new title slide with an optional custom footer
///
/// - footer (content): Custom footer content
/// - left-logo (content): Logo for the header
/// - right-logo (content): Logo for the header
/// - body (content): Frame content
#let title-frame(
  footer: frame-footer(numbering: false, []),
  left-logo: sra-logo(),
  center-logo: [],
  right-logo: luh-logo(),
  body,
) = polylux-slide(
  footer: footer,
  header: (first-subslide: bool) => block(inset: (top: 4.8pt, x: -12pt), grid(
    columns: (1fr, auto, 1fr),
    rows: 40pt,
    gutter: 2.5pt,
    align(horizon + left, left-logo),
    center-logo,
    align(horizon + right, right-logo),
  )),
  margin: (top: 40pt + 2 * 4.8pt),
  align(center + horizon, body),
)


/// Create a new slide with the given title
///
/// - title (content): The title of this slide
/// - section (bool, content): Create a new section, if `true` use the `title`
#let frame(title: [], section: false, body, footer: auto) = {
  if section == true {
    utils.register-section(title)
  } else if type(section) == content {
    utils.register-section(section)
  }
  polylux-slide(
    margin: (top: 5.5mm + 2 * 1.7mm),
    header: frame-header.with(title: title),
    footer: footer,
    align(horizon + left, block(
      width: 100%,
      height: 1fr,
      body,
    )),
  )
}

/// Generate a chapter outline, which (optionally) highlights the
/// current section
///
/// - enum-args (dictionary): Extra parameters for the underlying enum
/// - highlight (bool): Highlight the current section
#let sections-outline(enum-args: (:), highlight: true) = (
  context {
    let sections = utils.sections-state.final()
    let current-i = utils.sections-state.get().len() - 1

    enum(..enum-args, ..sections
      .enumerate()
      .map(((i, section)) => link(section.loc, if not highlight {
        section.body
      } else if i == current-i {
        heading(text(section.body, size: 12pt, weight: "bold"))
      } else {
        text(section.body, fill: luh.gray)
      })))
  }
)

/// Show a list of all chapters and optionally create a new one
///
/// - title (content): The title of this slide
/// - new (bool, content): Create a new section and highlight it
/// - spacing (length, fraction): Spacing between items
/// - body (content): Add this to the bottom of the frame
#let sections-frame(
  title: [Agenda],
  new: false,
  spacing: 20pt,
  body: [],
) = frame(title: title, section: new)[
  #sections-outline(
    enum-args: (tight: false, spacing: spacing),
    highlight: new == true or type(new) == content,
  )
  #body
]

#let list-marker(fill: sra.red, depth) = {
  if depth == 0 {
    block(inset: (right: 1em), height: 2em / 3, align(horizon, square(
      size: 0.5em,
      fill: fill,
    )))
  } else {
    block(inset: (right: 0.5em), height: 2em / 3, align(horizon, square(
      size: 0.4em,
      fill: luh.gray,
    )))
  }
}
#let enum-numbering(fill: luh.gray, ..numbers) = {
  text(fill: fill, [#numbers.pos().map(n => [#n]).join[.].])
}

/// Create a block with a title and a body
///
/// - title (none, content): The title of the block
/// - fill (color): The block color
/// - body (content): The block content
#let title-block(title: none, fill: luh.blue, width: 100%, body) = {
  // Change color of list and enum markers
  set list(marker: list-marker.with(fill: fill))
  set enum(numbering: enum-numbering.with(fill: fill))
  show strong: text.with(fill: fill)
  stack(
    spacing: 0pt,
    if title != none {
      block(
        fill: color.lighten(fill, 80%),
        stroke: 0.5pt + color.lighten(fill, 80%),
        width: width,
        inset: 4pt,
        text(fill: fill, title),
      )
    },
    block(
      fill: color.lighten(fill, 90%),
      stroke: 0.5pt + color.lighten(fill, 80%),
      width: width,
      inset: 8pt,
      body,
    ),
  )
}

/// Apply basic theming for non-slide content, e.g., figures
#let basic-theme(oss-font: false, list-shrink: true, body) = {
  let (font, stretch) = if not oss-font {
    ("Rotis Sans Serif Std", 100%)
  } else {
    ("Universalis ADF Std", 80%)
  }
  set text(size: 12pt, font: font, stretch: stretch, weight: "light")

  show heading: set text(fill: luh.blue, weight: "light")
  show heading.where(level: 1): set text(size: 16pt)

  show strong: set text(fill: luh.blue, weight: 300)
  show emph: set text(fill: sra.red)
  show link: set text(fill: luh.blue)
  set table.cell(inset: 5pt)
  set table(stroke: 0.5pt + black)

  // set list and enum styles
  set list(marker: list-marker.with(fill: sra.red), body-indent: 0em)
  set enum(numbering: enum-numbering.with(fill: luh.gray), full: true)

  // Shrinking text for inner lists
  show list: it => {
    if list-shrink {
      list-depth.step()
      context {
        set text(size: 0.9em) if list-depth.get().at(0) > 1
        it
      }
      list-depth.update(it => it - 1)
    } else {
      it
    }
  }
  show enum: it => {
    if list-shrink {
      list-depth.step()
      context {
        set text(size: 0.9em) if list-depth.get().at(0) > 1
        it
      }
      list-depth.update(it => it - 1)
    } else {
      it
    }
  }

  set footnote.entry(separator: line(stroke: 0.5pt + luh.gray, length: 45mm))
  show footnote.entry: set text(size: 0.9em)

  set figure(numbering: none, gap: 5pt)
  show figure.caption: it => text(10pt, it)

  // Convert note block into pdfpc notes
  show raw.where(lang: "note"): it => pdfpc.speaker-note(raw(
    it.text,
    lang: "md",
    block: true,
  ))

  body
}

/// Initializes the theme
///
/// - title (content): Title of the presentation (for the footer)
/// - footer-authors (none, content): If authors should be added to the footer
/// - oss-font (bool): Use an open-source font instead of LUH's proprietary one
/// - list-shrink (bool): Shrink the text in inner lists
/// - body (content): The rest of the presentation
#let theme(
  title: [],
  footer-authors: none,
  oss-font: false,
  list-shrink: true,
  body,
) = {
  show: basic-theme.with(oss-font: oss-font, list-shrink: list-shrink)

  let footer = frame-footer(
    numbering: true,
    section: true,
    authors: footer-authors,
    title,
  )

  set page(
    width: 16cm,
    height: 9cm,
    margin: (top: 5.5mm + 2 * 1.7mm, x: 7mm, bottom: 6mm),
    header: [],
    header-ascent: 0mm,
    footer-descent: 0mm,
    footer: footer,
  )

  // collect the metadata for pdfpc
  context pdfpc.pdfpc-file(here())

  body
}
