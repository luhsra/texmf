/// Create a new speaker note.
///
/// - text (string, raw): The note.
#let speaker-note(text) = {
  let text = if type(text) == str {
    text + "\n"
  } else if type(text) == content and text.func() == raw {
    text.text.trim() + "\n"
  } else {
    panic("A note must either be a string or a raw block")
  }
  [ #metadata((t: "Note", v: text)) <pdfpc> ]
}

#let end-slide = [
  #metadata((t: "EndSlide")) <pdfpc>
]

#let save-slide = [
  #metadata((t: "SaveSlide")) <pdfpc>
]

#let hidden-slide = [
  #metadata((t: "HiddenSlide")) <pdfpc>
]

/// Pdfpc configuration
///
/// - duration-minutes (int, none): Duration of the presentation, in minutes
/// - start-time (datetime, string, none): Intended start time, in the HH:MM format
/// - end-time (datetime, string, none): Intended end time, in the HH:MM format
/// - last-minutes (int, none): Number of last minutes when the timer color changes
/// - note-font-size (int, none): Font size used to display slide notes
/// - disable-markdown (bool, none): Interpret notes as plain text
/// - default-transition (string, none): Default slide transition
#let config(
  duration-minutes: none,
  start-time: none,
  end-time: none,
  last-minutes: none,
  note-font-size: none,
  disable-markdown: false,
  default-transition: none,
) = {
  if duration-minutes != none {
    [ #metadata((t: "Duration", v: duration-minutes)) <pdfpc> ]
  }

  let _time-config(time, msg-name, tag-name) = {
    let time = if type(time) == "datetime" {
      time.display("[hour padding:zero repr:24]:[minute padding:zero]")
    } else if type(time) == "string" {
      time
    } else {
      panic(msg-name + " must be either a datetime or a string in the HH:MM format.")
    }

    [ #metadata((t: tag-name, v: time)) <pdfpc> ]
  }

  if start-time != none {
    _time-config(start-time, "Start time", "StartTime")
  }
  if end-time != none {
    _time-config(end-time, "End time", "EndTime")
  }
  if last-minutes != none {
    [ #metadata((t: "LastMinutes", v: last-minutes)) <pdfpc> ]
  }
  if note-font-size != none {
    [ #metadata((t: "NoteFontSize", v: note-font-size)) <pdfpc> ]
  }

  [ #metadata((t: "DisableMarkdown", v: disable-markdown)) <pdfpc> ]

  if default-transition != none {
    let dir-to-angle(dir) = if dir == ltr {
      "0"
    } else if dir == rtl {
      "180"
    } else if dir == ttb {
      "90"
    } else if dir == btt {
      "270"
    } else {
      panic("angle must be a direction (ltr, rtl, ttb, or btt)")
    }

    let transition-str = (
      default-transition.at("type", default: "replace"),
      str(default-transition.at("duration-seconds", default: 1)),
      dir-to-angle(default-transition.at("angle", default: rtl)),
      default-transition.at("alignment", default: "horizontal"),
      default-transition.at("direction", default: "outward"),
    ).join(":")

    [ #metadata((t: "DefaultTransition", v: transition-str)) <pdfpc> ]
  }
}

/// Collects the entire metadata for pdfpc, to be exportable with typst query.
///
/// ```sh
/// typst query --root . ./slides.typ --field value --one "<pdfpc-file>" > ./slides.pdfpc
/// ```
#let pdfpc-file(loc) = {
  let arr = query(<pdfpc>).map(it => it.value)
  let (config, ..slides) = arr.split((t: "NewSlide"))
  let pdfpc = (
    pdfpcFormat: 2,
    disableMarkdown: false,
  )
  for item in config {
    pdfpc.insert(lower(item.t.at(0)) + item.t.slice(1), item.v)
  }
  let pages = ()
  for slide in slides {
    let page = (
      idx: 0,
      label: 1,
      overlay: 0,
      forcedOverlay: false,
      hidden: false,
    )
    for item in slide {
      if item.t == "Idx" {
        page.idx = item.v
      } else if item.t == "LogicalSlide" {
        page.label = "Page " + str(item.v)
      } else if item.t == "Overlay" {
        page.overlay = item.v
        page.forcedOverlay = item.v > 0
      } else if item.t == "HiddenSlide" {
        page.hidden = true
      } else if item.t == "SaveSlide" {
        if "savedSlide" not in pdfpc {
          pdfpc.savedSlide = page.label - 1
        }
      } else if item.t == "EndSlide" {
        if "endSlide" not in pdfpc {
          pdfpc.endSlide = page.label - 1
        }
      } else if item.t == "Note" {
        page.note = item.v
      } else {
        pdfpc.insert(lower(item.t.at(0)) + item.t.slice(1), item.v)
      }
    }
    pages.push(page)
  }
  pdfpc.insert("pages", pages)
  [#metadata(pdfpc)<pdfpc-file>]
}

/// Collects the speaker notes (RTF format) for sidepilot,
/// to be exportable with typst query.
///
/// ```sh
/// typst query --root . ./slides.typ --field value --one "<slidepilot-file>" | xargs printf '%b' > ./slides.rtf
/// ```
#let slidepilot-file(loc) = {
  let pagebreak = "#SLIDEPILOT-NOTES-PAGE-SEPARATOR#-"
  let arr = query(<pdfpc>).map(it => it.value)
  let (config, ..slides) = arr.split((t: "NewSlide"))
  let notes = ""
  for slide in slides {
    for item in slide {
      if item.t == "Idx" {
        notes += pagebreak + "Page-" + str(item.v + 1) + "\n"
      } else if item.t == "Note" {
        notes += item.v + "\n"
      }
    }
  }
  // Newlines
  notes = notes.replace("\n", "\\\n")
  // Encode non-ASCII characters
  let out = notes
    .codepoints()
    .map(c => {
      let uc = str.to-unicode(c)
      if uc < 128 {
        c
      } else if uc < 0xffff {
        "\\u" + str(uc)
      } else {
        // RTF only supports 16-bit unicode
        // create surrogate pairs for characters above
        let high = 0xd800 + (uc - 0x10000).bit-rshift(10)
        let low = 0xdc00 + uc.bit-and(0x3ff)
        "\\u" + str(high) + "\\u" + str(low)
      }
    })
    .join()
  let rtf = "{\rtf1\ansi\n" + out + "\n}"
  [#metadata(rtf)<slidepilot-file>]
}
