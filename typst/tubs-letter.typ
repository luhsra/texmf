// Geschäftsbrief im TU-Braunschweig-Design (DIN 5008, Form B).
// Maße wie in der LaTeX-Klasse tubslttr2 (tubs.lco).
//
// #import "texmf/typst/tubs-letter.typ": tubs-letter
// #show: tubs-letter.with(
//   recipient: [Name \ Straße 1 \ 12345 Ort],
//   opening: [Sehr geehrte Damen und Herren,],
//   closing: [Mit freundlichen Grüßen,],
// )
//
// Absender ist Christian Mengert-Dietrich (IBR/VSS); einzelne Felder
// lassen sich überschreiben: sender: (name: [..], signature: [..], ..)
// Brieftext …
#import "ibrslides.typ": tubs

#let tubs-logo = image.with("../tex/latex/srabeamer/tubs.bg/tubs-logo.svg")
#let ibr-logo = image.with("../tex/latex/srabeamer/tubs.bg/ibr-logo.pdf")

#let default-sender = (
  university: [TU Braunschweig],
  institute: [Institut für Betriebssysteme und Rechnerverbund],
  department: [Abt. Verlässliche Systemsoftware],
  street: [Mühlenpfordtstraße 23],
  city: [38106 Braunschweig],
  country: [Deutschland],
  title: [Prof. Dr.-Ing.],
  name: [Christian Mengert-Dietrich],
  // Name unter der Unterschrift, none: wie name
  signature: [Prof. Christian Mengert-Dietrich],
  // Durchwahlen, ergeben +49 (0) 531 391-…
  phone-direct: "3294",
  fax-direct: "3109",
  email: "christian.dietrich@tu-braunschweig.de",
  url: "https://ibr.cs.tu-bs.de/vss",
)

#let labels = (
  de: (
    date: [Datum], page: [Seite], of: [von],
    your-ref: [Ihr Zeichen], your-mail: [Ihre Nachricht vom],
    my-ref: [Unser Zeichen], my-mail: [Unsere Nachricht vom],
    months: ("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli",
      "August", "September", "Oktober", "November", "Dezember"),
  ),
  en: (
    date: [Date], page: [Page], of: [of],
    your-ref: [Your ref.], your-mail: [Your letter of],
    my-ref: [Our ref.], my-mail: [Our letter of],
    months: ("January", "February", "March", "April", "May", "June", "July",
      "August", "September", "October", "November", "December"),
  ),
)

#let phone-number(direct) = [+49 (0) 531 391-#direct]

/// Brief im TU-Design.
///
/// - sender (dictionary): Felder wie in `default-sender`
/// - recipient (content): Anschrift
/// - date (datetime, content): Datum in der Absenderspalte
/// - subject (content, none): fetter Betreff über der Anrede
/// - references (dictionary): Bezugszeichen unter dem Datum, Schlüssel
///   your-ref, your-mail, my-ref, my-mail
/// - opening (content): Anrede
/// - closing (content): Grußformel
/// - signature (content, auto): Name unter der Unterschrift,
///   auto: sender.signature bzw. sender.name
/// - logo (content): Logo rechts oben, `none` für keines
/// - lang (str): "de" oder "en"
#let tubs-letter(
  sender: (:),
  recipient: [],
  date: datetime.today(),
  subject: none,
  references: (:),
  opening: none,
  closing: none,
  signature: auto,
  logo: ibr-logo(width: 81mm),
  lang: "de",
  font: ("NexusSansPro", "Universalis ADF Std"),
  body,
) = {
  let s = default-sender + sender
  let l = labels.at(lang)
  if signature == auto {
    signature = if s.signature != none { s.signature } else { s.name }
  }
  let date = if type(date) == datetime {
    [#date.day(). #l.months.at(date.month() - 1) #date.year()]
  } else { date }

  // Absenderspalte rechts: Kontakt, Datum und Bezugszeichen
  let sender-column = {
    set text(size: 9pt)
    set par(leading: 0.72em)
    let opt(x, f: x => x) = if x != none { (f(x),) } else { () }
    let lines = (
      s.university,
      strong(s.institute),
      ..if s.department != none { ([], s.department) },
      [],
      ..opt(s.street),
      s.city,
      ..opt(s.country),
      ..if s.title != none or s.name != none { ([],) },
      ..opt(s.title),
      ..opt(s.name),
      [],
      ..opt(s.phone-direct, f: d => [Tel. #phone-number(d)]),
      ..opt(s.fax-direct, f: d => [Fax #phone-number(d)]),
      ..opt(s.email, f: e => link("mailto:" + e, e)),
      ..opt(s.url, f: u => link(u)),
      [],
      [],
      [#l.date: #date],
    )
    let refs = ("your-ref", "your-mail", "my-ref", "my-mail")
      .filter(k => references.at(k, default: none) != none)
    if refs.len() > 0 {
      lines.push([])
      for k in refs { lines.push([#l.at(k): #references.at(k)]) }
    }
    lines.join(linebreak())
  }

  // Briefkopf, Rücksendezeile, Anschrift und Absenderspalte auf Seite 1
  let first-page = {
    let at(x, y, body) = place(top + left, dx: x, dy: y, body)

    at(17.5mm, 34.8mm, line(length: 185mm, stroke: 1.2pt + tubs.red))
    at(17.5mm, 17.8mm, tubs-logo(width: 63.5mm))
    if logo != none { at(122.2mm, 9.7mm, logo) }

    at(24.5mm, 47.5mm, block(width: 85mm, {
      set text(size: 8pt, weight: "bold")
      set par(leading: 0.74em)
      [#s.university | #s.institute \ ]
      (s.street, s.city, s.country).filter(x => x != none).join[ | ]
    }))
    at(24.5mm, 63mm, block(width: 85mm, {
      set par(leading: 0.95em)
      recipient
    }))
    at(155mm, 48.5mm, block(width: 52mm, sender-column))
  }

  set document(title: subject) if subject != none
  set text(lang: lang, size: 11pt, font: font)
  // 1,5-zeilig mit kleinem Absatzabstand
  set par(leading: 0.8em, spacing: 1.35em)
  show link: set text(fill: black)

  set page(
    paper: "a4",
    // tubslttr2 setzt ab Seite 2 16 cm Textbreite, auf Seite 1 12,2 cm.
    // Typst kann die Breite nicht seitenweise ändern, daher gilt 12,2 cm.
    margin: (top: 33mm, bottom: 35mm, left: 24.5mm, right: 63.5mm),
    header-ascent: 5mm,
    header: context if here().page() > 1 {
      block(height: 22mm, width: 122mm, align(horizon, text(size: 9pt)[
        #s.university \
        *#s.institute*
        #if s.department != none [\ #s.department]
      ]))
    },
    footer-descent: 14.5mm,
    footer: context [
      #l.page #counter(page).display() #l.of #counter(page).final().first()
    ],
    background: context {
      if here().page() == 1 {
        first-page
        // Falzmarken (105 mm, 210 mm) und Lochmarke (148,5 mm)
        let mark(y, len) = place(top + left, dx: 8mm, dy: y,
          line(length: len, stroke: 0.5pt + tubs.red))
        mark(105mm, 2mm)
        mark(148.5mm, 4mm)
        mark(210mm, 2mm)
      }
    },
  )

  // Der Brieftext beginnt auf Höhe der ersten Falzmarke (105 mm)
  v(73.2mm - 0.75em)
  if subject != none {
    strong(subject)
    v(0.9em)
  }
  if opening != none {
    opening
    v(0.9em)
  }

  body

  if closing != none or signature != none {
    block(above: 2.2em, breakable: false, {
      closing
      v(11.2mm)
      signature
    })
  }
}
