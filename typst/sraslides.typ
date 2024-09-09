#import "@preview/polylux:0.3.1": *

#let texmf = ".."

// Colors
#let sra = (
    red: rgb(208, 38, 38),
)
#let luh = (
    green: rgb(177, 201, 32),
    blue: rgb(0, 80, 155),
    lightblue: rgb(204, 220, 235),
    lighterblue: rgb(230, 238, 245),
    gray: rgb(128, 128, 128),
    lightgray: rgb(220, 222, 222),
)

// Images
#let sra-logo = image.with(
    texmf + "/tex/latex/srabeamer/sra.bg/sra-logo.svg")
#let luh-logo = image.with(
    texmf + "/tex/latex/srabeamer/sra.bg/luh-logo-rgb.svg")

/// Create a footer block
#let footer-block(numbering: true, body) = block(
    fill: luh.lightgray, width: 100%, height: 0.5cm,
    outset: (left: 10pt, right: 10pt),
    [
        #set text(size: 7pt, fill: luh.gray)
        #set align(horizon)
        #{
            if numbering {
                place(top + right, dx: 10pt - 0.3cm, rect(fill: luh.green, width: 1.96cm, height: 0.1cm))
            }
        }
        #grid(
            columns: (39pt, 1fr, 39pt),
            rows: (15pt),
            [],
            [#body],
            align(right,
                if numbering {
                    [#logic.logical-slide.display() - #utils.last-slide-number]
                }
            )
        )
    ]
)

/// Create a new title slide with an optional custom footer
///
/// - footer (content): Custom footer content
/// - body (content): Frame content
#let title-frame(footer: [], left-logo: sra-logo(), right-logo: luh-logo(), body) = {
    // Overwrite footer
    set page(footer: footer-block(numbering: false, footer))

    polylux-slide([
        #set align(top + center)
        #grid(
            columns: (50%, 50%),
            rows: (40pt),
            gutter: 2.5pt,
            align(horizon + left, left-logo),
            align(horizon + right, right-logo),
        )
        #body
    ])
}

/// Create a new slide with the given title
///
/// - title (content): The title of this slide
/// - section (bool, content): Create a new section, if `true` use the `title`
#let frame(title: [], section: false, body) = polylux-slide({
    // register new section here, so it doesn't leak into the previous slide
    context {
        if logic.subslide.get().at(0) == 1 {
            if section == true {
                utils.register-section(title)
            } else if type(section) == content {
                utils.register-section(section)
            }
        }
    }

    grid(
        columns: (30pt, 1fr, 80pt),
        rows: (auto, 1fr),
        gutter: 2.5pt,
        sra-logo(height: 16pt),
        align(left + horizon, heading(title)),
        align(horizon + right, luh-logo(height: 16pt)),
        grid.cell(colspan: 3, align(horizon + left, block(
            inset: (left: 12pt, right: 12pt), width: 100%, height: 100%, body
        )))
    )
})

/// Generate a chapter outline, which (optionally) highlights the
/// current section
#let sections-outline(enum-args: (:), highlight: true) = locate(loc => {
    let sections = utils.sections-state.final(loc)
    let current-i = utils.sections-state.at(loc).len() - 1
    enum(
        ..enum-args,
        ..sections.enumerate().map(((i, section)) =>
            link(section.loc,
                if not highlight {
                    section.body
                } else if i == current-i {
                    strong(section.body)
                } else {
                    text(section.body, fill: luh.gray)
                }
            )
        )
    )
})

/// Show a list of all chapters and optionally create a new one
///
/// - title (content): The title of this slide
/// - new (bool, content): Create a new section and highlight it
/// - body (content): Add this to the bottom of the frame
#let sections-frame(
    title: [Agenda],
    new: false,
    spacing: 20pt,
    body: []
) = frame(
    title: title,
    section: new
)[
    #sections-outline(
        enum-args: (tight: false, spacing: spacing),
        highlight: new == true or type(new) == content,
    )
    #body
]

#let list-marker(fill: sra.red, depth) = {
    if depth == 0 {
        move(dx: 2pt, dy: 2pt, square(size: 5pt, fill: fill))
    } else {
        move(dx: 2.5pt, dy: 2.5pt, square(size: 4pt, fill: luh.gray))
    }
}
#let enum-numbering(fill: luh.gray, ..numbers) = {
    text(fill: fill, [#numbers.pos().map(n => [#n]).join[.].])
}

/// Create a block with a title and a body
#let title-block(title: none, fill: luh.blue, body) = [
    // Change color of list and enum markers
    #set list(marker: list-marker.with(fill: fill))
    #set enum(numbering: enum-numbering.with(fill: fill))

    #stack(spacing: 0pt,
        if title != none {
            block(fill: color.lighten(fill, 80%), width: 100%, inset: 4pt)[
                #text(fill: fill, title)
            ]
        },
        block(fill: color.lighten(fill, 90%), width: 100%, inset: 8pt)[
            #body
        ]
    )
]

/// Initializes the theme
#let theme(title: [], body) = {
    set text(size: 12pt, font: "Rotis Sans Serif Std", weight: "light")

    let footer = footer-block(numbering: true, locate(loc => {
        let suffix = {
            let sections = utils.sections-state.at(loc)
            if sections.len() == 0 {
                []
            } else {
                [--- #sections.last().body]
            }
        }
        [#title #suffix]
    }))

    set page(
        width: 16cm,
        height: 9cm,
        margin: (top: 4.8pt, left: 8pt, right: 8pt, bottom: 0.5cm),
        footer-descent: 0pt,
        footer: footer,
    )

    show heading: set text(fill: luh.blue, weight: "light")
    show heading.where(level: 1): set text(size: 16pt)

    show strong: set text(fill: luh.blue, weight: 300)
    show emph: set text(fill: sra.red)
    show link: set text(fill: luh.blue)
    set table.cell(inset: 5pt)
    set table(stroke: 0.5pt + black)

    // set list and enum styles
    set list(marker: list-marker.with(fill: sra.red))
    set enum(numbering: enum-numbering.with(fill: luh.gray), full: true)

    // Convert note block into pdfpc notes
    show raw.where(lang: "note"): it => pdfpc.speaker-note(
        raw(it.text, lang: "md", block: true)
    )

    body
}
