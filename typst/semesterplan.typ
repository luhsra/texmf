#import "sraslides.typ": *

#let mappings = (
  PRIMARY: luh.blue,
  SUCCESS: safe.green,
  INFO: safe.blue,
  WARN: badbee,
  DANGER: sra.red,
  NOTE: luh.gray,
)

#let types = (
  V: "PRIMARY", // Vorlesung
  S: "PRIMARY", // Seminar
  U: "INFO", // Übung
  A: "SUCCESS", // Aufgabe
  T: "WARN", // Teilabgabe
  D: "DANGER", // Deadline
)

#let style-event(event) = {
  if not event.contains(": ") {
    return event
  }
  let (ty, desc) = event.split(": ")

  let color = mappings.NOTE
  if ty in mappings {
    color = mappings.at(ty)
    ty = desc
    desc = none
  } else {
    let kind = types.at(ty.at(0), default: "NOTE")
    color = mappings.at(kind, default: color)
  }

  align(horizon, stack(
    dir: ltr,
    spacing: 0.6em,
    box(fill: color, outset: 0.2em, radius: 0.2em, text(size: 0.9em, fill: white, ty)),
    desc,
  ))
}

#let style-date(date) = {
  let (d, m, y) = date.split(".").map(int)
  let date = datetime(year: 2000 + y, month: m, day: d)
  [#text(size: 0.8em, fill: luh.gray, date.display("[week_number]:")) #date.display(
      "[day].[month].[year repr:last_two]",
    )]
}

/// Create a semesterplan table from a CSV (array of array of strings)
///
/// - csv (array): Array of rows, each row is an array of strings
/// - offset (int): Optional offset for the table rows
/// - len (int, none): Optional number of rows to include
/// - wrapper (function): Optional wrapper function for the table cells
/// - args (arguments): Additional arguments for the table
#let semesterplan(csv, offset: 0, len: none, wrapper: text, ..args) = table(
  columns: csv.at(0).len(),
  ..args,
  table.header(..csv.at(0).map(c => eval(c, mode: "markup")).map(strong).map(wrapper)),
  ..for row in csv.slice(1 + offset, if len != none { 1 + offset + len }) {
    (wrapper(style-date(row.at(0))), ..row.slice(1).map(style-event).map(wrapper))
  }
)


#let semesterplan-test(wrapper: text, ..args) = {
  let test = ```csv
  Datum,Di 11:30,Fr 8:15
  14.10.25,,
  21.10.25,V1: Vorlesung,V2: Vorlesung
  28.10.25,V3: Vorlesung,
  04.11.25,V4: Vorlesung,U1: Übung
  11.11.25,V5: Vorlesung,U2: Übung
  18.11.25,V6: Vorlesung,V7: Vorlesung
  25.11.25,V8: Vorlesung,U3: Übung
  02.12.25,V9: Vorlesung,U4: Übung
  09.12.25,V10: Vorlesung,U5: Übung
  16.12.25,V11: Vorlesung,U6: Übung
  23.12.25,,
  30.12.25,,
  06.01.26,V12: Vorlesung,U7: Übung
  13.01.26,V13: Vorlesung,U8: Übung
  20.01.26,V14: Vorlesung,U9: Übung
  27.01.26,V15: Vorlesung,WARN: Repetitorium
  ```
  semesterplan(csv(bytes(test.text)), wrapper: wrapper, ..args)
}
