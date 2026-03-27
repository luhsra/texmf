#import "@preview/touying:0.6.3": *
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
#let sra-logo = image.with("../tex/latex/srabeamer/sra.bg/sra-logo.svg")
#let luh-logo = image.with("../tex/latex/srabeamer/sra.bg/luh-logo-rgb.svg")

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
#let title-block(
  title: none,
  fill: luh.blue,
  width: 100%,
  alignment: top + left,
  title-alignment: none,
  body-alignment: none,
  place-alignment: none,
  float: false,
  body,
) = {
  // Change color of list and enum markers
  set list(marker: list-marker.with(fill: fill))
  set enum(numbering: enum-numbering.with(fill: fill))

  if body-alignment == none { body-alignment = alignment }
  if title-alignment == none { title-alignment = alignment }
  if place-alignment == none { place-alignment = alignment }

  context {
    let in_width = width
    let width = width
    if in_width == auto {
      width = calc.max(measure(title).width + 8pt, measure(body).width + 16pt)
    }

    show strong: text.with(fill: fill)
    place(place-alignment, float: float, stack(
      spacing: 0pt,
      if title != none {
        block(
          fill: color.lighten(fill, 80%),
          stroke: 0.5pt + color.lighten(fill, 80%),
          width: width,
          inset: 4pt,
          {
            set align(title-alignment)
            text(fill: fill, title)
          },
        )
      },
      block(
        fill: color.lighten(fill, 90%),
        stroke: 0.5pt + color.lighten(fill, 80%),
        width: width,
        inset: 8pt,
        {
          set align(body-alignment)
          body
        },
      ),
    ))
  }
}

/// Create the header block
///
/// - title (content): Title
/// - left-logo (image): Left logo
/// - right-logo (image): Right logo
#let slide-header(
  title: [],
  left-logo: sra-logo(),
  right-logo: luh-logo(),
  first-subslide: true,
) = box(inset: (x: -7mm + 3mm, y: 1.7mm), grid(
  columns: (auto, 1fr, auto),
  rows: 5.5mm,
  column-gutter: 5mm,
  grid.cell(align: top + left, left-logo),
  grid.cell(align: top + left, block(
    inset: (top: 0.7mm),
    text(fill: luh.blue, size: 16pt, title),
  )),
  grid.cell(align: top + right, right-logo),
))

/// Get the offset of the current heading in the document
#let global-heading-offset(heading) = {
  if heading == none {
    0
  } else {
    query(
      selector(std.heading.where(level: heading.level)).before(
        heading.location(),
      ),
    ).len()
  }
}


/// Create a footer block
///
/// - numbering (auto, content): Show frame number
/// - section (auto, content): Show current section
/// - author (content, none): Show the given author in the footer
#let slide-footer(
  self: none,
  numbering: auto,
  section: auto,
  author: none,
  green-box: true,
  body,
) = align(left + bottom, block(
  fill: luh.lightgray,
  width: 100%,
  height: 5mm,
  outset: (x: 7mm),
  inset: (
    left: -7mm + 3mm + 5.5mm + 5mm,
    right: -7mm + 3mm,
  ),
  {
    set text(size: 7pt, fill: luh.gray)
    show link: set text(size: 7pt, fill: luh.gray)
    show heading: set text(size: 7pt, fill: luh.gray)
    set align(horizon)

    if author != none {
      body = [#author #h(2em) #body]
    }
    if section == auto {
      section = context (
        if self.slide-level > 2 {
          if utils.current-heading(level: self.slide-level - 2) != none {
            link(
              utils.current-heading(level: self.slide-level - 2).location(),
              utils.display-current-heading(level: self.slide-level - 2),
            )
          }
        },
        if utils.current-heading(level: self.slide-level - 1) != none {
          link(
            utils.current-heading(level: self.slide-level - 1).location(),
            utils.display-current-heading(
              level: self.slide-level - 1,
            ),
          )
        },
      )
        .filter(it => it != none)
        .join(" | ")
    }
    if section != none and section != [] {
      body += section
    }

    if numbering in (none, false) {
      numbering = []
    }
    if numbering == auto {
      if self.store.numbering-by-chapter {
        let l2-heading-count = context global-heading-offset(
          utils.current-heading(level: 2),
        )
        numbering = [#l2-heading-count - #context utils.slide-counter.display()]
      } else {
        numbering = {
          let curr = context utils.slide-counter.display()
          [#curr - #utils.last-slide-number]
        }
      }
    }
    grid(
      columns: (1fr, auto),
      rows: 100%,
      body, align(right)[#numbering #h(2mm)],
    )
    if green-box {
      place(top + right, rect(fill: luh.green, width: 19mm, height: 1mm))
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
/// - footer (content): Custom footer content
/// - left-logo (content): Logo for the header
/// - center-logo (content): Logo for the header
/// - right-logo (content): Logo for the header
/// - body (content): Frame content
#let title-slide(
  config: (:),
  footer: none,
  left-logo: auto,
  center-logo: [],
  right-logo: auto,
  body,
) = touying-slide-wrapper(self => {
  let l-logo = if left-logo == auto { self.info.logo } else { left-logo }
  let r-logo = if right-logo == auto { self.store.right-logo } else {
    right-logo
  }

  let self = utils.merge-dicts(
    self,
    config-page(
      header: block(inset: (top: 4.8pt, x: -12pt), grid(
        columns: (1fr, auto, 1fr),
        rows: 40pt,
        gutter: 2.5pt,
        align(horizon + left, l-logo),
        center-logo,
        align(horizon + right, r-logo),
      )),
      footer: slide-footer(
        self: self,
        numbering: false,
        green-box: false,
        align(center, footer),
      ),
      margin: (top: 40pt + 2 * 4.8pt),
    ),
  )
  touying-slide(self: self, config: config, align(
    center + horizon,
    body,
  ))
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
  let footer(self) = utils.call-or-display(self, self.store.footer)
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
    config-page(fill: if background == auto {
      self.colors.primary
    } else {
      background
    }),
  )
  set text(fill: foreground, size: 1.5em)
  touying-slide(self: self, config: config, align(center + horizon, body))
})

#let structure = text.with(fill: luh.blue)
#let Structure = text.with(fill: luh.blue, style: "italic")
#let STRUCTURE = text.with(fill: luh.blue, weight: "bold")

#let alert = it => text(fill: sra.red, it)
#let Alert = it => emph(alert(it))
#let ALERT = it => strong(alert(it))

#let sample = it => text(fill: luh.green, it)
#let Sample = it => emph(sample(it))
#let SAMPLE = it => strong(sample(it))

#let texttt = text.with(font: "DeJaVu Sans Mono", stretch: 80%)


/// Apply basic theming for non-slide content, e.g., figures
///
/// - oss-font (boolean): Use Open Source Software fonts
/// - list-shrink (boolean): Enable list shrinking
/// - body (content): Document body
#let basic-theme(oss-font: false, list-shrink: true, body) = {
  let (font, stretch) = if not oss-font {
    ("Rotis Sans Serif Std", 100%)
  } else {
    ("Universalis ADF Std", 80%)
  }
  set text(size: 12pt, font: font, stretch: stretch, weight: "light")

  show heading: set text(fill: luh.blue, weight: "light")
  show heading.where(level: 1): set text(size: 16pt)

  show strong: set text(weight: 300)

  show link: set text(fill: luh.blue)
  set table.cell(inset: 5pt)
  set table(stroke: 0.5pt + black)

  // set list and enum styles
  set list(marker: list-marker.with(fill: sra.red), body-indent: 0em)
  set enum(numbering: enum-numbering.with(fill: luh.blue), full: true)

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
/// - author (content): Author of the presentation (for the footer)
/// - oss-font (boolean): Use Open Source Software fonts
/// - list-shrink (boolean): Enable list shrinking
/// - enable-pdfpc (boolean): Enable pdfpc export
/// - enable-slidepilot (boolean): Enable SlidePilot export
/// - body (content): Body of the presentation
#let sra-theme(
  title: [],
  author: none,
  date: datetime.today(),
  oss-font: false,
  list-shrink: true,
  enable-pdfpc: true,
  enable-slidepilot: false,
  left-logo: sra-logo(),
  right-logo: luh-logo(),
  numbering-by-chapter: false,
  ..args,
  body,
) = {
  set document(title: title, author: author, date: date)
  show: basic-theme.with(oss-font: oss-font, list-shrink: list-shrink)

  // Style for outlines
  show outline.entry: it => {
    let styled(it) = {
      list(
        block(inset: (bottom: 0.5em), link(
          it.element.location(),
          if it.element.location().page() == here().page() {
            strong(it.body())
          } else {
            it.body()
          },
        )),
      )
    }
    let wrap(it, level) = {
      if level == 1 {
        styled(it)
      } else {
        list(
          marker: [#sym.space.nobreak#sym.space.nobreak#sym.space.nobreak#sym.space.nobreak#sym.space.nobreak#sym.space.nobreak],
          wrap(it, level - 1),
        )
      }
    }
    wrap(it, it.level)
  }

  set heading(numbering: (..nums) => {
    if nums.pos().len() == 1 {
      numbering("A", ..nums)
    } else {
      numbering("1.", ..nums.pos().slice(1))
    }
  })
  show heading.where(level: 1): it => {
    // Count level 2 headings globally
    let l2-offset = query(
      selector(heading.where(level: 2)).before(here()),
    ).len()
    counter(heading).update((..n) => (..n.pos(), l2-offset))
    it
  }

  // chapter-numbering
  show heading.where(level: 2): it => {
    if numbering-by-chapter {
      utils.slide-counter.update(1)
    }
    it
  }

  // no bookmarks for slide-level headings
  let slide-level = utils.merge-dicts(..args).at("slide-level", default: 2)
  show heading.where(level: slide-level): set heading(bookmarked: not numbering-by-chapter)


  show std.title: set text(fill: luh.blue, size: 24pt)

  let header = self => slide-header(
    title: utils.display-current-heading(
      self: self,
      level: self.slide-level,
      numbered: false,
    ),
    left-logo: self.info.logo,
    right-logo: self.store.right-logo,
  )
  let footer = self => slide-footer(
    self: self,
    author: author,
    section: utils.display-current-heading(
      self: self,
      level: 3,
      style: it => [~---~#it.body],
    ),
    self.info.title,
  )

  show: touying-slides.with(
    config-page(
      width: 16cm,
      height: 9cm,
      margin: (top: 5.5mm + 2 * 1.7mm, x: 7mm, bottom: 6mm),
      header-ascent: 0mm,
      footer-descent: 0mm,
      footer: footer,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      zero-margin-header: false,
      zero-margin-footer: false,
      enable-pdfpc: enable-pdfpc or enable-slidepilot,
      reset-page-counter-to-slide-counter: not numbering-by-chapter,
    ),
    config-colors(
      neutral-light: gray,
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
      primary: luh.blue,
      secondary: sra.red,
    ),
    // save the variables for later use
    config-store(
      header: header,
      footer: footer,
      right-logo: right-logo,
      numbering-by-chapter: numbering-by-chapter,
    ),
    config-info(
      title: title,
      // subtitle: [Subtitle],
      author: author,
      date: date,
      institution: [Leibniz Universität Hannover],
      logo: left-logo,
    ),
    ..args,
  )

  if enable-slidepilot {
    context slidepilot.slidepilot-file(here())
  }

  body
}
