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

// yellow from Jürgen's RS slides.
#let rs-yellow = rgb("ffff99")

