/// The current sub-slide
#let subslide = counter("subslide")
/// Number of pauses in the current slide
#let pause-counter = counter("pause-counter")
/// The current slide number
#let logical-slide = counter("logical-slide")
/// The maximal number of sublides
#let repetitions = counter("repetitions")

#let _slides-cover(mode, body) = {
  if mode == "invisible" {
    hide(body)
  } else if mode == "transparent" {
    text(gray.lighten(50%), body)
  } else {
    panic("Illegal cover mode: " + mode)
  }
}

/// Parse the subslide expression.
///
/// - s (string): The subslides
/// -> array
#let _parse-subslide-indices(s) = {
  let parts = s.split(",").map(p => p.trim())
  let parse-part(part) = {
    let match-until = part.match(regex("^-([[:digit:]]+)$"))
    let match-beginning = part.match(regex("^([[:digit:]]+)-$"))
    let match-range = part.match(regex("^([[:digit:]]+)-([[:digit:]]+)$"))
    let match-single = part.match(regex("^([[:digit:]]+)$"))
    if match-until != none {
      let parsed = int(match-until.captures.first())
      ( until: parsed )
    } else if match-beginning != none {
      let parsed = int(match-beginning.captures.first())
      ( beginning: parsed )
    } else if match-range != none {
      let parsed-first = int(match-range.captures.first())
      let parsed-last = int(match-range.captures.last())
      ( beginning: parsed-first, until: parsed-last )
    } else if match-single != none {
      let parsed = int(match-single.captures.first())
      parsed
    } else {
      panic("failed to parse visible slide idx:" + part)
    }
  }
  parts.map(parse-part)
}

/// Check if an index is visible
///
/// - idx (int): Current index
/// - visible-subslides (int, array, dictionary, string): The subslides
/// -> bool
#let _check-visible(idx, visible-subslides) = {
  if type(visible-subslides) == "integer" {
    idx == visible-subslides
  } else if type(visible-subslides) == "array" {
    visible-subslides.any(s => _check-visible(idx, s))
  } else if type(visible-subslides) == "string" {
    let parts = _parse-subslide-indices(visible-subslides)
    _check-visible(idx, parts)
  } else if type(visible-subslides) == "dictionary" {
    let lower-okay = if "beginning" in visible-subslides {
      visible-subslides.beginning <= idx
    } else {
      true
    }

    let upper-okay = if "until" in visible-subslides {
      visible-subslides.until >= idx
    } else {
      true
    }

    lower-okay and upper-okay
  } else {
    panic("you may only provide a single integer, an array of integers, or a string")
  }
}

/// Number of required subslides
///
/// - visible-subslides (int, array, dictionary, string): The subslides
#let _last-required-subslide(visible-subslides) = {
  if type(visible-subslides) == "integer" {
    visible-subslides
  } else if type(visible-subslides) == "array" {
    calc.max(..visible-subslides.map(s => _last-required-subslide(s)))
  } else if type(visible-subslides) == "string" {
    let parts = _parse-subslide-indices(visible-subslides)
    _last-required-subslide(parts)
  } else if type(visible-subslides) == "dictionary" {
    let last = 0
    if "beginning" in visible-subslides {
      last = calc.max(last, visible-subslides.beginning)
    }
    if "until" in visible-subslides {
      last = calc.max(last, visible-subslides.until)
    }
    last
  } else {
    panic("you may only provide a single integer, an array of integers, or a string")
  }
}

/// Conditionally show content on subslides
///
/// - visible-subslides (int, array, dictionary, string): The subslides
/// - reserve-space (bool): Preserve space of hidden element
/// - mode (str): Make element "invisible" or "transparent"
/// - body (content): Content
/// -> content
#let _conditional-display(
  visible-subslides,
  reserve-space,
  mode,
  body
) = context {
  let vs = visible-subslides;
  repetitions.update(rep => calc.max(rep, _last-required-subslide(vs)))
  if _check-visible(subslide.get().first(), vs) {
    body
  } else if reserve-space {
    _slides-cover(mode, body)
  }
}

/// Show the content on the given subslides, but reserve space anyway.
///
/// - mode (str): Make element "invisible" or "transparent"
/// - visible-subslides (int, array, dictionary, string): The subslides
/// - body (content): Content
#let uncover(visible-subslides, mode: "invisible", body) = {
  _conditional-display(visible-subslides, true, mode, body)
}

/// Put the content only on the given subslide, not reserving any space when hidden.
///
/// - visible-subslides (int, array, dictionary, string): The subslides
/// - body (content): Content
#let only(visible-subslides, body) = {
  _conditional-display(visible-subslides, false, "doesn't even matter", body)
}

/// Show the children on separate subslides one after another.
///
/// - start (int): Start with this subslide
/// - mode (str): Make element "invisible" or "transparent"
/// - children (content): The children
#let one-by-one(start: 1, mode: "invisible", ..children) = {
  for (idx, child) in children.pos().enumerate() {
    uncover((beginning: start + idx), mode: mode, child)
  }
}

#let alternatives-match(subslides-contents, position: bottom + left) = {
  let subslides-contents = if type(subslides-contents) == "dictionary" {
    subslides-contents.pairs()
  } else {
    subslides-contents
  }

  let subslides = subslides-contents.map(it => it.first())
  let contents = subslides-contents.map(it => it.last())
  context {
    let sizes = contents.map(c => measure(c))
    let max-width = calc.max(..sizes.map(sz => sz.width))
    let max-height = calc.max(..sizes.map(sz => sz.height))
    for (subslides, content) in subslides-contents {
      only(subslides, box(
        width: max-width,
        height: max-height,
        align(position, content)
      ))
    }
  }
}

#let alternatives(
  start: 1,
  repeat-last: false,
  ..args
) = {
  let contents = args.pos()
  let kwargs = args.named()
  let subslides = range(start, start + contents.len())
  if repeat-last {
    subslides.last() = (beginning: subslides.last())
  }
  alternatives-match(subslides.zip(contents), ..kwargs)
}

#let alternatives-fn(
  start: 1,
  end: none,
  count: none,
  ..kwargs,
  fn
) = {
  let end = if end == none {
    if count == none {
      panic("You must specify either end or count.")
    } else {
      start + count
    }
  } else {
    end
  }

  let subslides = range(start, end)
  let contents = subslides.map(fn)
  alternatives-match(subslides.zip(contents), ..kwargs.named())
}

#let alternatives-cases(cases, fn, ..kwargs) = {
  let idcs = range(cases.len())
  let contents = idcs.map(fn)
  alternatives-match(cases.zip(contents), ..kwargs.named())
}

#let line-by-line(start: 1, mode: "invisible", body) = {
  let items = if repr(body.func()) == "sequence" {
    body.children
  } else {
    ( body, )
  }

  let idx = start
  for item in items {
    if repr(item.func()) != "space" {
      uncover((beginning: idx), mode: mode, item)
      idx += 1
    } else {
      item
    }
  }
}


#let _items-one-by-one(fn, start: 1, mode: "invisible", ..args) = {
  let kwargs = args.named()
  let items = args.pos()
  let covered-items = items.enumerate().map(
    ((idx, item)) => uncover((beginning: idx + start), mode: mode, item)
  )
  fn(
    ..kwargs,
    ..covered-items
  )
}

#let list-one-by-one(start: 1, mode: "invisible", ..args) = {
  _items-one-by-one(list, start: start, mode: mode, ..args)
}

#let enum-one-by-one(start: 1, mode: "invisible", ..args) = {
  _items-one-by-one(enum, start: start, mode: mode, ..args)
}

#let terms-one-by-one(start: 1, mode: "invisible", ..args) = {
  let kwargs = args.named()
  let items = args.pos()
  let covered-items = items.enumerate().map(
    ((idx, item)) => terms.item(
      item.term,
      uncover((beginning: idx + start), mode: mode, item.description)
    )
  )
  terms(
    ..kwargs,
    ..covered-items
  )
}

/// Hides/shows content based on `pause` state.
#let paused-content(body) = context {
  if subslide.get().first() > pause-counter.get().first() {
    body
  } else {
    hide(body)
  }
}

#let pause = context {
  pause-counter.step()
  context {
    let p = pause-counter.get().first()
    repetitions.update(rep => calc.max(rep, p + 1))
  }
}

/// Create a new polylux slide.
///
/// - body (content): Slide body
/// - margin (:): Additional margins
/// - header (auto, content): Custom header for this slide
/// - footer (auto, content): Custom footer for this slide
#let polylux-slide(body, margin: (:), header: auto, footer: auto) = {
  // Having this here is a bit unfortunate concerning separation of concerns
  // but I'm not comfortable with logic depending on pdfpc...
  let pdfpc-slide-markers(curr-subslide) = context [
    #metadata((t: "NewSlide")) <pdfpc>
    #metadata((t: "Idx", v: counter(page).get().first() - 1)) <pdfpc>
    #metadata((t: "Overlay", v: curr-subslide - 1)) <pdfpc>
    #metadata((t: "LogicalSlide", v: logical-slide.get().first())) <pdfpc>
  ]

  // Optional header/footer overwrites
  let page-header-footer = if header != auto and footer != auto {
    page.with(header: header, footer: footer)
  } else if header != auto {
    page.with(header: header)
  } else if footer != auto {
    page.with(footer: footer)
  } else {
    page
  };

  let body = {
    show par: paused-content
    show math.equation: paused-content
    show box: paused-content
    show block: paused-content
    show path: paused-content
    show rect: paused-content
    show square: paused-content
    show circle: paused-content
    show ellipse: paused-content
    show line: paused-content
    show polygon: paused-content
    show image: paused-content
    show list: paused-content
    show enum: paused-content

    body
  }

  page-header-footer(margin: margin, {
    logical-slide.step()
    subslide.update(1)
    repetitions.update(1)
    pause-counter.update(0)

    pdfpc-slide-markers(1)


    body

    // place(dx: -10pt, dy: -25pt, context text(size: 8pt)[P #pause-counter.get().first()])
    // place(dx: -10pt, dy: -15pt, context text(size: 8pt)[S #subslide.display()/#repetitions.display()])

    subslide.step()
  })

  context {
    let reps = repetitions.get().first()
    for curr-subslide in range(2, reps + 1) {
      page-header-footer(margin: margin, {

        pause-counter.update(0)

        pdfpc-slide-markers(curr-subslide)

        body

        // place(dx: -10pt, dy: -15pt, context text(size: 8pt)[S #subslide.display()/#repetitions.display()])
        // place(dx: -10pt, dy: -25pt, context text(size: 8pt)[P #pause-counter.get().first()])

        subslide.step()
      })
    }
  }
}