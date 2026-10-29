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
  maphy: rgb(0, 105, 77),
  darkgreen: rgb(0, 105, 77),
  nawi: rgb(0, 140, 66),
  jura: rgb(165, 22, 82),
  berry: rgb(165, 22, 82),
  phil: rgb(235, 105, 11),
  orange: rgb(235, 105, 11),
  arch: rgb(248, 212, 0),
  yellow: rgb(248, 212, 0),
  bau: rgb(0, 165, 209),
  fei: rgb(85, 189, 203),
  macshbau: rgb(0, 111, 137),
  wiwi: rgb(226, 0, 38),
  red: rgb(226, 0, 38),
  lse: rgb(99, 111, 107),
  lsop: rgb(109, 127, 143),
  quest: rgb(168, 178, 173),
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
#let rs = (
  yellow: rgb("ffff99"),
  green: rgb("00af50"),
)
