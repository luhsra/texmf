#import "@preview/touying:0.7.4": *
#import "sra-colors.typ": *
#import "@preview/cetz:0.4.2" as cetz


// Empty list to open lists on second level directly
#let bii = list.with(marker: [])

// ise an arrow as item marker
#let ra = $#text(fill: sra.red, sym.arrow.r.hook)$
#let item-x(marker: [x], body) = [
  #set list(marker: marker)
  - #body
]
#let item-ra = item-x.with(marker: depth => [
  #box(width: .5em, align(
    center,
    ra,
  ))#h(1em)
])

#let item-pro = item-x.with(marker: text(fill: luh.green)[+#h(.5em)])
#let item-con = item-x.with(marker: text(fill: sra.red)[−#h(.5em)])

// tab content to absolute x offset
#let tab-to(pos, body) = {
  h(0.1pt) // needed for correct positioning on new lines
  context {
    let x = here().position().x
    h(pos - x)
    body
  }
}

#let _bt-tab-position = state("beamertools.btTabPos", none)

/// Save the current horizontal page position after inserting `offset`.
/// the saved tab persists until the next call.
/// Example: `Name: #btSetTab(offset: 1em)Alice\ Ort: #btUseTab()Hannover`
#let btSetTab(offset: 0pt) = {
  h(offset)
  h(0.1pt) // Establish an inline position, including at the start of a line.
  context _bt-tab-position.update(here().position().x)
}

/// Align following content to the saved tab, plus `offset`, without a line break.
/// Call `btSetTab` first. Negative spacing allows moving backwards on the line,
#let btUseTab(offset: 0pt) = {
  h(0.1pt)
  context {
    let pos = _bt-tab-position.get()
    assert(pos != none, message: "Call btSetTab before btUseTab.")
    h(pos + offset - here().position().x)
  }
}

#let debug-else(placeholder: [Noch nicht veröffentlicht], body) = {
  if sys.inputs.at("mode", default: "normal") == "debug" {
    body
  } else {
    [
      #placeholder
      #metadata(none) <disabled-chapter>
    ]
  }
}

/// Link using the lecture numbering scheme, as in the footer.
/// Full form also displays the target heading title.
#let link-chapter(where, form: "short") = {
  show text: set text(fill: luh.gray)
  // ra
  $#text(fill: luh.gray, sym.arrow.r.hook)$
  [~]
  box(
    stroke: luh.gray + .5pt,
    fill: luh.lightgray,
    inset: 2pt,
    context {
      let target = query(where).first()
      let loc = target.location()
      let chapters = query(selector(heading.where(level: 2)).before(loc))
      let chapter-nr = chapters.len()
      let chapter-name = chapters.first().body
      let page = utils.slide-counter.at(loc).first()
      [#link(loc)[#chapter-nr;-#page]#if form == "full" {
          [#chapter-name ~#link(loc, target.body)]
        }]
    },
  )
}


/// Example: `Text #btPinCetz(angle: 30deg)[Annotation]`.
/// For an exact inline label anchor, use `#box[#metadata(none)<p>]` or `#[~<p>]`
/// and pass `anchor: <p>`; bare paragraph metadata is not an inline point.
/// The canvas floats at the call site and does not change the surrounding layout.
#let btPin(
  body,
  angle: 0deg,
  distance: 1.35em,
  text-width: auto,
  scale-content: 100%,
  xshift: 0pt,
  yshift: 0pt,
  visible: none,
  fill: sra.orange,
  anchor: auto,
  stroke: black.lighten(75%) + 0.5pt,
) = {
  set text(fill: black)
  show box: set box(fill: none, stroke: none, inset: 0pt)
  h(0pt)
  let pinned = box[#context {
    let label = block(
      width: text-width,
      inset: 2pt,
      align(center, text(size: 7pt, body)),
    )
    if scale-content != 100% {
      label = scale(scale-content, origin: top + left, reflow: true, label)
    }
    let label-scale = scale-content / 100%
    let shadow-offset = 0.8pt * label-scale
    let label-anchor = (
      "west",
      "south-west",
      "south",
      "south-east",
      "east",
      "north-east",
      "north",
      "north-west",
    ).at(calc.rem(int(calc.round(angle / 45deg)), 8))
    let origin = if anchor == auto {
      (0pt, 0pt)
    } else {
      let current = here().position()
      let target = query(anchor)
        .filter(it => it.location().page() == current.page)
        .first()
        .location()
        .position()
      (target.x - current.x, current.y - target.y)
    }
    place(top + left, cetz.canvas(length: 1pt, {
      // A zero-size, unpainted content node fixes the bounds without drawing an origin mark.
      cetz.draw.content((0pt, 0pt), [])
      cetz.draw.floating({
        cetz.draw.translate((xshift, -yshift))
        cetz.draw.content(
          (rel: (angle, distance), to: origin),
          label,
          anchor: label-anchor,
          name: "label",
        )
        cetz.draw.on-layer(-1, {
          cetz.draw.rect(
            (rel: (shadow-offset, -shadow-offset), to: "label.north-west"),
            (rel: (shadow-offset, -shadow-offset), to: "label.south-east"),
            radius: 2pt * label-scale,
            fill: black.transparentize(75%),
            stroke: none,
          )
          cetz.draw.rect(
            "label.north-west",
            "label.south-east",
            radius: 2pt * label-scale,
            fill: fill,
            stroke: fill + 0.5pt,
            name: "frame",
          )
          cetz.draw.line(origin, "frame", stroke: stroke)
        })
      })
    }))
  }]
  if visible == none {
    pinned
  } else if visible == <handout> {
    handout-only(pinned)
  } else {
    only(visible, pinned)
  }
}
