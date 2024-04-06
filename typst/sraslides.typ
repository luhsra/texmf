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
    lightgray: rgb(220, 222, 222),
)

// Images
#let sra-logo = image.with(
    texmf + "/tex/latex/srabeamer/sra.bg/sra-logo.svg")
#let luh-logo = image.with(
    texmf + "/tex/latex/srabeamer/sra.bg/luh-logo-rgb.svg")

// Functions

/// Display and set the current chapter that is shown in the footer
#let chapter(name) = {
    utils.register-section(name)
    strong([#name <chapter>])
}

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
#let title-frame(body, footer: []) = {
    // Overwrite footer
    set page(footer: footer-block(numbering: false, footer))

    polylux-slide([
        #set align(top + center)
        #grid(
            columns: (50%, 50%),
            rows: (40pt),
            gutter: 2.5pt,
            align(horizon + left, sra-logo(height: 40pt)),
            align(horizon + right, luh-logo(height: 40pt)),
        )
        #body
    ])
}

/// Create a new slide with the given title
#let frame(body, title: []) = polylux-slide([
    #grid(
        columns: (30pt, 1fr, 80pt),
        rows: (auto, 1fr),
        gutter: 2.5pt,
        sra-logo(height: 16pt),
        align(left + horizon, heading(title)),
        align(horizon + right, luh-logo(height: 16pt)),
        grid.cell(colspan: 3, align(horizon + left, block(inset: (left: 12pt, right: 12pt), width: 100%, height: 100%, body)))
    )
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
        paper: "presentation-16-9",
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
    set enum(numbering: n => text(fill: luh.gray, [#n.]))
    set table.cell(inset: 5pt)
    set table(stroke: 0.5pt + black)

    set list(marker: depth => {
        if depth == 0 {
            move(dx: 2pt, dy: 2pt, square(size: 5pt, fill: sra.red))
        } else {
            move(dx: 2.5pt, dy: 2.5pt, square(size: 4pt, fill: luh.gray))
        }
    })

    body
}
