#import "@preview/polylux:0.3.1": *

#let texmf = ".."

// Colors
#let sra = (
    red: rgb(208, 38, 38),
)
#let luh = (
    green: rgb(177, 201, 32),
    blue: rgb(0, 80, 155),
    gray: rgb(128, 128, 128),
    lightgray: rgb(220, 220, 221),
)

// Images
#let sra-logo = image.with(
    texmf + "/tex/latex/srabeamer/sra.bg/sra-logo.svg")
#let luh-logo = image.with(
    texmf + "/tex/latex/srabeamer/sra.bg/luh-logo-rgb.svg")

// Functions

/// Display and set the current chapter that is shown in the footer
#let chapter(body) = strong([#body <chapter>])

#let footer-block(body) = block(
    fill: luh.lightgray, width: 100%, height: 30pt,
    outset: (left: 20pt, right: 20pt),
    [
        #set text(size: 14pt, fill: luh.gray)
        #set align(horizon)
        #body
    ]
)

/// Create a new title slide with an optional custom footer
#let title-frame(body, footer: []) = {
    // Overwrite footer
    set page(footer: footer-block(footer))

    polylux-slide([
        #set align(top + center)
        #grid(
            columns: (50%, 50%),
            rows: (80pt),
            gutter: 5pt,
            align(horizon + left, sra-logo(height: 80pt)),
            align(horizon + right, luh-logo(height: 80pt)),
        )
        #body
    ])
}

/// Create a new slide with the given title
#let frame(body, title: []) = polylux-slide([
    #grid(
        columns: (60pt, 100% - 230pt, 160pt),
        rows: (auto),
        gutter: 5pt,
        sra-logo(height: 30pt),
        [
            #set align(left + horizon)
            = #title
        ],
        align(horizon + right, luh-logo(height: 30pt))
    )
    #align(horizon + left, body)
])

/// Create a block with a title and a body
#let title-block(title: (), fill: luh.blue, body) = [
    #set list(marker: (
        move(dx: 3pt, dy: 3pt, square(size: 10pt, fill: fill)),
        move(dx: 4pt, dy: 4pt, square(size: 8pt, fill: luh.gray))
    ))
    #stack(spacing: 0pt,
        block(fill: color.lighten(fill, 70%), width: 100%, inset: 10pt)[
            #text(size: 26pt, fill: fill, title)
        ],
        block(fill: color.lighten(fill, 90%), width: 100%, inset: 15pt)[
            #body
        ]
    )
]

/// Initializes the theme
#let theme(title: [], footer-title: [], body) = {
    set text(size: 22pt, font: "Rotis Sans Serif Std", weight: "thin")

    if footer-title == [] {
        footer-title = title
    }

    let footer = footer-block(locate(loc => {
        let suffix = {
            let sections = utils.sections-state.at(loc)
            if sections.len() == 0 {
                []
            } else {
                [--- #sections.last().body]
            }
        }
        if logic.logical-slide.at(loc).at(0) > 1 {
            grid(
                columns: (100% - 100pt, 100pt),
                rows: (30pt),
                [#footer-title #suffix],
                align(right, [
                    #logic.logical-slide.display() -- #utils.last-slide-number
                ])
            )
        }
    }))

    set page(
        paper: "presentation-16-9",
        margin: (top: 20pt, left: 20pt, right: 20pt, bottom: 30pt),
        fill: white,
        footer-descent: 0pt,
        footer: footer,
    )

    show heading: set text(fill: luh.blue, weight: "thin")
    show strong: set text(weight: 300, fill: luh.blue)
    show emph: set text(fill: sra.red)
    show link: set text(fill: luh.blue)
    set enum(numbering: n => text(fill: luh.gray, [#n.]))

    set list(marker: (
        move(dx: 3pt, dy: 3pt, square(size: 10pt, fill: sra.red)),
        move(dx: 4pt, dy: 4pt, square(size: 8pt, fill: luh.gray))
    ))

    body
}
