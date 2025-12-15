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
