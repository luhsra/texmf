
#let dref-values = state("dref-values", (:))
#let dref-re = regex("^\\\\drefset\\{([^}]+)\\}\\{([^}]+)\\}$")

/// Import a dref file
///
/// ```typ #dref-import(read("my/data.dref"))```
#let dref-import(data) = dref-values.update(dref-values => {
  for line in data.split("\n") {
    let match = line.trim().match(dref-re)
    if match != none {
      dref-values.insert(match.captures.at(0), float(match.captures.at(1)))
    }
  }
  dref-values
})

/// Embed a previously imported value.
///
/// - key: Name of the value (or multipe)
/// - map: Function to transform the value(s), required of multiple values
/// - precision: Maximum number of digits
#let dref(..keys, map: x => x, precision: 2) = {
  context {
    let values = dref-values.get()
    let vals = keys.pos().map(k => values.at(k))
    let val = map(..vals)
    if type(val) == float {
      val = calc.round(digits: precision, val)
    }
    [#val<dref>]
  }
}

#let dref-rel-raw(first, rel) = {
  if rel == none {
    return first
  }
  if type(rel) == array {
    let (rel, second) = rel
    if rel == "scale by" {
      return first * second
    } else if rel == "divide by" {
      return first / second
    } else if rel == "factor of" {
      return first / second
    } else if rel == "percent of" {
      return first / second * 100
    } else if rel == "increase from" {
      return first - second
    } else if rel == "decrease from" {
      return second - first
    } else if rel == "increase factor from" {
      return (first - second) / second
    } else if rel == "decrease factor from" {
      return (second - first) / second
    } else if rel == "increase percent from" {
      return (first - second) / second * 100
    } else if rel == "decrease percent from" {
      return (second - first) / second * 100
    }
  } else if rel == "percent" {
    return first * 100
  } else if rel == "negate" {
    return -first
  } else if rel == "abs" {
    return calc.abs(first)
  }
  panic("Invalid operation!")
}

/// Embed a previously imported value after applying an operation.
///
/// - key: Name of the value
/// - rel: Put this value in relation to another one (increase, decrease, factor, percent...)
/// - precision: Number of digits
///
/// The rel parameter accepts the following values:
/// - `none`: Do not change the value
/// - `"percent"`: Multiply by 100
/// - `"negate"`: Mutliply by -1
/// - `"abs"`: Absolute value
/// - `("scale by", "Another key")`
/// - `("divide by", "Another key")`
/// - `("factor of", "Another key")`
/// - `("percent of", "Another key")`
/// - `("increase from", "Another key")`
/// - `("decrease from", "Another key")`
/// - `("increase factor from", "Another key")`
/// - `("decrease factor from", "Another key")`
/// - `("increase percent from", "Another key")`
/// - `("decrease percent from", "Another key")`
#let dref-rel(key, rel, precision: 2) = {
  context {
    let values = dref-values.get()
    let first = values.at(key)
    let rel = rel
    if type(rel) == array {
      let (op, key) = rel
      rel = (op, values.at(key))
    }
    let val = dref-rel-raw(first, rel)
    val = calc.round(digits: precision, val)
    [#val<dref>]
  }
}
