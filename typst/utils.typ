#import "logic.typ"
#import "pdfpc.typ"

// SECTIONS

#let sections-state = state("polylux-sections", ())
#let register-section(name) = context {
  let loc = here()
  sections-state.update(sections => {
    sections.push((body: name, loc: loc))
    sections
  })
}

#let current-section = context {
  let sections = sections-state.get()
  if sections.len() > 0 {
    sections.last().body
  } else {
    []
  }
}

#let polylux-outline(enum-args: (:), padding: 0pt) = context {
  let sections = sections-state.final()
  pad(padding, enum(
    ..enum-args,
    ..sections.map(section => link(section.loc, section.body))
  ))
}


// PROGRESS

#let polylux-progress(ratio-to-content) = context {
  let ratio = logic.logical-slide.get().first() / logic.logical-slide.final().first()
  ratio-to-content(ratio)
}

#let last-slide-number = context { logic.logical-slide.final().first() }


// HEIGHT FITTING

#let _size-to-pt(size, styles, container-dimension) = {
  let to-convert = size
  if type(size) == "ratio" {
    to-convert = container-dimension * size
  }
  measure(v(to-convert), styles).height
}

#let _limit-content-width(width: none, body, container-size, styles) = {
  let mutable-width = width
  if width == none {
    mutable-width = calc.min(container-size.width, measure(body, styles).width)
  } else {
    mutable-width = _size-to-pt(width, styles, container-size.width)
  }
  box(width: mutable-width, body)
}

// SIDE BY SIDE

// Put elements next to each other in a row
#let side-by-side(columns: none, gutter: 1em, ..bodies) = {
  let bodies = bodies.pos()
  let columns = if columns ==  none { (1fr,) * bodies.len() } else { columns }
  if columns.len() != bodies.len() {
    panic("number of columns must match number of content arguments")
  }

  grid(columns: columns, gutter: gutter, ..bodies)
}
