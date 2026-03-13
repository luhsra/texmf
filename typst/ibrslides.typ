#import "@preview/touying:0.6.1": *
#import "slidepilot.typ"
// Backward compatibility
#import components: side-by-side

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

// TUBS Colors
#let tubs = (
  black: rgb(0,0,0),
  red: rgb(190,30,60),
  white: rgb(255,255,255),
  yellow: rgb(255,205,0),
  orange: rgb(250,110,0),
  green: rgb(137,164,0),
  greenlight: rgb(198,238,0),
  greendark: rgb(0,113,86),
  blue: rgb(0,128,180),
  bluelight: rgb(124,205,230),
  bluedark: rgb(0,83,116),
  violet: rgb(118,0,118),
  violetlight: rgb(204,0,153),
  violetdark: rgb(118,0,84),
  gray: rgb(128, 128, 128),
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
#let right-logo = image.with("../tex/latex/srabeamer/tubs.bg/tubs-logo.svg")
#let left-logo = image.with("../tex/latex/srabeamer/tubs.bg/ibr-logo.pdf")

// Background is rendered from a PDF
#let bg-file = "../tex/latex/srabeamer/tubs.bg/beamerthemetubs169_bg.pdf"
#let bg-title = image(bg-file, page:1, width: 100%, height: 100%)
#let bg-normal = image(bg-file, page:2, width: 100%, height: 100%)
#let bg-plain = image(bg-file, page:3, width: 100%, height: 100%)

// Counter for the list depth
#let list-depth = counter("list-depth")

#let list-marker(fill: sra.red, depth) = {
  if depth == 0 {
    block(inset: (right: 1em), height: 2em / 3, align(horizon, square(
      size: 0.5em,
      fill: fill,
    )))
  } else {
    block(inset: (right: 0.5em), height: 2em / 3, align(horizon, square(
      size: 0.4em,
      fill: tubs.gray,
    )))
  }
}
#let enum-numbering(fill: tubs.gray, ..numbers) = {
  text(fill: fill, [#numbers.pos().map(n => [#n]).join[.].])
}

/// Create a block with a title and a body
///
/// - title (none, content): The title of the block
/// - fill (color): The block color
/// - body (content): The block content
#let title-block(title: none, fill: tubs.blue, width: 100%, body) = {
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

/// Create the header block
///
/// - title (content): Title
/// - left-logo (image): Left logo
/// - right-logo (image): Right logo
#let slide-header(
  title: [],
  left-logo: left-logo(),
  right-logo: right-logo(),
  first-subslide: true,
) = box(inset: (x: -5mm + 3mm, y: 1.7mm), grid(
  columns: (auto, 1fr, auto),
  rows: 5.5mm,
  column-gutter: 5mm,
  grid.cell(align: top + left, []),
  grid.cell(align: top + left, block(
    inset: (top: 0.7mm),
    text(size: 16pt, title), // FIXME: Heading?
  )),
  grid.cell(align: top + right, right-logo),
))


/// Create a footer block
///
/// - numbering (bool): Show frame number
/// - section (bool): Show current section
/// - author (content, none): Show the given author in the footer
#let slide-footer(
  numbering: true,
  section: none,
  author: none,
  body,
) = align(left + bottom, block(
  width: 100%,
  height: 5mm,
  outset: (x: 7mm),
  inset: (
    left: -7mm + 3mm + 5.5mm + 5mm,
    right: -7mm + 3mm + if not numbering { 5.5mm + 5mm },
  ),
  {
    set text(size: 7pt, fill: tubs.gray)
    set align(horizon)

    if author != none {
      body = [#author #h(2em) #body]
    }
    if section != none and section != [] {
      body += section
    }

    if numbering {
      grid(
        columns: (1fr, auto),
        rows: 100%,
        body,
        [
          #let curr = context utils.slide-counter.display()
          #align(right)[#curr - #utils.last-slide-number #h(2mm)]
        ],
      )
    } else {
      body
    }
  },
))

/// Default slide function for the presentation.
///
/// - config (dictionary): The configuration of the slide.
///
///   You can use `config-xxx` to set the configuration of the slide.
///   For more several configurations, you can use `utils.merge-dicts`
///   to merge them.
///
/// - repeat (int, auto): The number of subslides. Default is `auto`,
///   which means touying will automatically calculate the number of subslides.
///
///   The `repeat` argument is necessary when you use
///   `#slide(repeat: 3, self => [ .. ])` style code to create a slide.
///   The callback-style `uncover` and `only` cannot be detected by
///   touying automatically.
///
/// - setting (function): The setting of the slide.
///   You can use it to add some set/show rules for the slide.
///
/// - composer (function): The composer of the slide.
///   You can use it to set the layout of the slide.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the
///   slide into three parts. The first and the last parts will take 1/4 of the
///   slide, and the second part will take 1/2 of the slide.
///
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`,
///   it will be assumed to be the first argument of the
///   `components.side-by-side` function.
///
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]]`
///   will make the `Footer` cell take 2 columns.
///
///   If you want to customize the composer, you can pass a function to the
///   `composer` argument. The function should receive the contents of the
///   slide and return the content of the slide, like
///   `#slide(composer: grid.with(columns: 2))[A][B]`.
///
/// - bodies (array): The contents of the slide.
///   You can call the `slide` function with syntax like `#slide[A][B][C]`
///   to create a slide.
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  set align(horizon)
  let header(self) = utils.call-or-display(self, self.store.header)
  let footer(self) = utils.call-or-display(self, self.store.footer)
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
      background: bg-normal,
    ),
  )
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: setting,
    composer: composer,
    ..bodies,
  )
})


/// Title slide for the presentation.
///
/// - config (dictionary): The configuration of the slide.
///   You can use `config-xxx` to set the configuration of the slide.
///   For more several configurations, you can use `utils.merge-dicts`
///   to merge them.
/// - body (content): Frame content
#let title-slide(
  config: (:),
  body,
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-page(
      margin: (top: 160pt),
      footer: [],
      background: bg-title
    ),
  )
  touying-slide(self: self, config: config, body)
})


/// New section slide for the presentation.
///
/// - config (dictionary): The configuration of the slide.
///   You can use `config-xxx` to set the configuration of the slide.
///   For more several configurations, you can use `utils.merge-dicts`
///   to merge them.
#let new-section-slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  set align(horizon)
  let header = slide-header(
    title: utils.display-current-heading(self: self, level: 1),
    left-logo: self.info.logo,
    right-logo: self.store.right-logo,
  )
  let footer = slide-footer(author: self.info.author, self.info.title)
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
    ),
  )
  // Ensure at least one body
  // let bodies = bodies.pos()
  // if bodies.len() == 0 or bodies.at(0) == none or bodies.at(0) == [] {
  //   bodies = (outline(depth: 1, title: none),)
  // }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: setting,
    composer: composer,
    ..bodies,
  )
})


/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - config (dictionary): The configuration of the slide.
///   You can use `config-xxx` to set the configuration of the slide.
///   For more several configurations, you can use `utils.merge-dicts`
///   to merge them.
///
/// - background (color, auto): The background color of the slide.
///   Default is `auto`, which means the primary color of the slides.
///
/// - foreground (color): The foreground color of the slide.
#let focus-slide(
  config: (:),
  background: auto,
  foreground: white,
  body,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(background: bg-plain,
    fill: if background == auto {
      self.colors.primary
    } else {
      background
    }),
  )
  set text(fill: foreground, size: 2em)
  touying-slide(self: self, config: config, align(center + horizon, body))
})



/// Apply basic theming for non-slide content, e.g., figures
///
/// - oss-font (boolean): Use Open Source Software fonts
/// - list-shrink (boolean): Enable list shrinking
/// - body (content): Document body
#let basic-theme(oss-font: false, list-shrink: true, body) = {
  let (font, stretch) = if not oss-font {
    ("NexusSansPro", 100%)
  } else {
    ("Universalis ADF Std", 80%)
  }
  set text(size: 12pt, font: font, stretch: stretch, weight: "light")

  show heading: set text(fill: tubs.blue, weight: "light")
  show heading.where(level: 1): set text(size: 16pt)

  show strong: set text(fill: tubs.bluedark, weight: 300)
  show emph: set text(fill: tubs.red)
  show link: set text(fill: tubs.bluedark)
  set table.cell(inset: 5pt)
  set table(stroke: 0.5pt + black)

  // set list and enum styles
  set list(marker: list-marker.with(fill: sra.red), body-indent: 0em)
  set enum(numbering: enum-numbering.with(fill: tubs.gray), full: true)

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

  set footnote.entry(separator: line(stroke: 0.5pt + tubs.gray, length: 45mm))
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
/// - author (content): Author of the presentation (for the footer)
/// - oss-font (boolean): Use Open Source Software fonts
/// - list-shrink (boolean): Enable list shrinking
/// - enable-pdfpc (boolean): Enable pdfpc export
/// - enable-slidepilot (boolean): Enable SlidePilot export
/// - body (content): Body of the presentation
#let ibr-theme(
  title: [],
  author: none,
  date: datetime.today(),
  oss-font: true,
  list-shrink: true,
  enable-pdfpc: true,
  enable-slidepilot: false,
  left-logo: left-logo(),
  right-logo: right-logo(),
  ..args,
  body,
) = {
  set document(title: title, author: author, date: date)
  show: basic-theme.with(oss-font: oss-font, list-shrink: list-shrink)

  // Style for outlines
  show outline.entry: it => list(block(inset: (bottom: 0.2cm), link(
    it.element.location(),
    {
      if it.element.location().page() == here().page() {
        strong(it.body())
      } else {
        it.body()
      }
    },
  )))

  show std.title: set text(fill: tubs.blue, size: 24pt)

  let header = self => slide-header(
    title: utils.display-current-heading(self: self, level: self.slide-level),
    left-logo: self.info.logo,
    right-logo: self.store.right-logo,
  )
  let footer = self => slide-footer(
    author: author,
    section: utils.display-current-heading(
      self: self,
      level: 1,
      style: it => [~---~#it.body],
    ),
    self.info.title,
  )

  show: touying-slides.with(
    config-page(
      width: 16cm,
      height: 9cm,
      margin: (top: 5.5mm + 2 * 1.7mm, x: 2.55mm + 5.78mm, bottom: 6mm),
      header-ascent: 0mm,
      footer-descent: 0mm,
      footer: footer,
      background: bg-normal,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      zero-margin-header: false,
      zero-margin-footer: false,
      enable-pdfpc: enable-pdfpc or enable-slidepilot,
    ),
    config-colors(
      neutral-light: gray,
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
      primary: tubs.blue,
      secondary: tubs.red,
    ),
    // save the variables for later use
    config-store(
      header: header,
      footer: footer,
      right-logo: right-logo,
    ),
    config-info(
      title: title,
      // subtitle: [Subtitle],
      author: author,
      date: date,
      institution: [Technische Universität Braunschweig],
      logo: left-logo,
    ),
      ..args,
  )

  if enable-slidepilot {
    context slidepilot.slidepilot-file(here())
  }

  body
}
