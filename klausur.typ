// klausur.typ – Typst-Template für Klausuren
// Aufgabentypen: "mc", "zuordnung", "freitext", "mathe"
// Doku: siehe README.md

#let _aufgaben = state("klausur-aufgaben", ())
#let _mit-loesung = state("klausur-mit-loesung", false)

#let _blau = rgb("#1f4e9c")
#let _gruen = rgb("#1b7a3a")
#let _grau = luma(150)

#let _buchstabe(i) = str.from-unicode(65 + i)

#let _punkte-text(p) = if p == 1 [1 Punkt] else [#p Punkte]

/// Ein Ankreuzkästchen; gefuellt = true zeigt ein Kreuz (für die Lösung).
#let checkbox(gefuellt: false) = box(
  width: 4.5mm,
  height: 4.5mm,
  stroke: 0.7pt,
  baseline: 15%,
  if gefuellt { place(center + horizon, text(size: 13pt, weight: "bold", fill: _gruen)[×]) },
)

/// Liniertes Feld für Freitext. `inhalt` wird (Lösung) in das Feld gesetzt.
#let linienfeld(zeilen: 8, inhalt: none) = block(
  width: 100%,
  height: zeilen * 7.5mm,
  stroke: 0.7pt + _grau,
  radius: 2pt,
  clip: true,
  {
    place(top, stack(..range(zeilen).map(_ => v(7.5mm - 0.4pt) + line(length: 100%, stroke: 0.4pt + luma(200)))))
    if inhalt != none { pad(x: 3mm, y: 1mm, text(fill: _gruen, inhalt)) }
  },
)

/// Kariertes Feld für Rechnungen. `inhalt` wird (Lösung) in das Feld gesetzt.
#let rasterfeld(hoehe: 6cm, inhalt: none) = block(
  width: 100%,
  height: hoehe,
  stroke: 0.7pt + _grau,
  radius: 2pt,
  clip: true,
  fill: tiling(
    size: (5mm, 5mm),
    {
      place(line(start: (0mm, 0mm), end: (5mm, 0mm), stroke: 0.3pt + luma(210)))
      place(line(start: (0mm, 0mm), end: (0mm, 5mm), stroke: 0.3pt + luma(210)))
    },
  ),
  if inhalt != none { pad(x: 3mm, y: 2mm, text(fill: _gruen, inhalt)) },
)

// ---------------------------------------------------------------- Aufgabenteil

#let _aufgaben-koerper(a) = {
  a.frage
  if a.art == "mc" {
    v(0.3em)
    for (i, o) in a.optionen.enumerate() {
      grid(columns: (auto, 1fr), column-gutter: 0.6em, [*#_buchstabe(i))*], o)
      v(0.2em)
    }
  } else if a.art == "zuordnung" {
    v(0.3em)
    grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      row-gutter: 0.5em,
      ..range(calc.max(a.links.len(), a.rechts.len())).map(i => {
        let l = if i < a.links.len() { [*#(i + 1).* #a.links.at(i)] } else { [] }
        let r = if i < a.rechts.len() { [*#_buchstabe(i)).* #a.rechts.at(i)] } else { [] }
        (l, r)
      }).flatten(),
    )
  }
}

/// Definiert eine Aufgabe.
///
/// - titel: Titel der Aufgabe
/// - art: "mc" | "zuordnung" | "freitext" | "mathe"
/// - punkte: erreichbare Punkte
/// - frage: Aufgabentext
/// - antwort: Musterlösung (mc: Array von Indizes ab 0; zuordnung: Array von
///   Indizes der rechten Spalte, je einer pro linkem Eintrag; sonst Content)
/// - optionen: Antwortoptionen (mc)
/// - links, rechts: Spalten der Zuordnung
/// - zeilen: Zeilenzahl des Freitextfelds (auto: doppelt so hoch wie die Lösung)
/// - hoehe: Höhe des Rechenfelds, mathe (auto: doppelt so hoch wie die Lösung)
#let aufgabe(
  titel: "",
  art: "freitext",
  punkte: 1,
  frage: [],
  antwort: none,
  optionen: (),
  links: (),
  rechts: (),
  zeilen: auto,
  hoehe: auto,
) = {
  assert(
    art in ("mc", "zuordnung", "freitext", "mathe"),
    message: "Unbekannte Aufgabenart: " + repr(art),
  )
  let a = (
    titel: titel,
    art: art,
    punkte: punkte,
    frage: frage,
    antwort: antwort,
    optionen: optionen,
    links: links,
    rechts: rechts,
    zeilen: zeilen,
    hoehe: hoehe,
  )
  _aufgaben.update(s => s + (a,))
  context {
    let n = _aufgaben.get().len()
    [#block(width: 100%, above: 1.6em, below: 1em, breakable: false)[
      #grid(
        columns: (1fr, auto),
        text(weight: "bold", size: 1.1em)[Aufgabe #n: #titel],
        text(fill: _grau)[#_punkte-text(punkte)],
      )
      #v(-0.4em)
      #line(length: 100%, stroke: 0.5pt + _grau)
      #_aufgaben-koerper(a)
      #v(0.4em)
      #align(right, text(size: 0.85em, fill: _blau)[
        #link(label("ant-" + str(n)))[→ Zum Antwortfeld]
        #if _mit-loesung.get() [ #h(1em) #link(label("lsg-" + str(n)))[→ Zur Lösung]]
      ])
    ]#label("aufg-" + str(n))]
  }
}

// ---------------------------------------------------------------- Antwortbogen

// Höhe der Lösung inkl. Innenabstand des Feldes (Antwortfelder sind doppelt so hoch).
#let _loesungshoehe(inhalt, breite) = measure(width: breite - 6mm, inhalt).height + 4mm

#let _antwortfeld(a, loesung) = {
  let l = loesung and a.antwort != none
  if loesung and a.antwort == none {
    text(fill: _grau)[(keine Lösung angegeben)]
  } else if a.art == "mc" {
    let gewaehlt = if l { a.antwort } else { () }
    for (i, _) in a.optionen.enumerate() {
      box(inset: (right: 1.5em), [#checkbox(gefuellt: i in gewaehlt) #_buchstabe(i)])
    }
  } else if a.art == "zuordnung" {
    grid(
      columns: (auto, auto, auto),
      column-gutter: 0.8em,
      row-gutter: 0.7em,
      ..a.links.enumerate().map(((i, x)) => {
        let k = if l and i < a.antwort.len() { text(weight: "bold", fill: _gruen, _buchstabe(a.antwort.at(i))) } else { [] }
        ([*#(i + 1).*], x, box(width: 9mm, height: 7mm, stroke: 0.7pt, baseline: 25%, align(center + horizon, k)))
      }).flatten(),
    )
  } else if a.art == "freitext" {
    layout(size => {
      let z = a.zeilen
      if z == auto {
        z = if a.antwort == none { 8 } else {
          calc.max(4, calc.ceil(2 * _loesungshoehe(a.antwort, size.width) / 7.5mm))
        }
      }
      linienfeld(zeilen: z, inhalt: if l { a.antwort })
    })
  } else {
    layout(size => {
      let h = a.hoehe
      if h == auto {
        h = if a.antwort == none { 6cm } else {
          calc.max(3cm, calc.ceil(2 * _loesungshoehe(a.antwort, size.width) / 5mm) * 5mm)
        }
      }
      rasterfeld(hoehe: h, inhalt: if l { a.antwort })
    })
  }
}

#let _abschnitt(loesung) = context {
  let praefix = if loesung { "lsg-" } else { "ant-" }
  let alle = _aufgaben.final()
  if alle.len() > 0 {
    pagebreak()
    text(size: 1.5em, weight: "bold")[#if loesung [Lösung] else [Antwortbogen]]
    v(0.3em)
    for (i, a) in alle.enumerate() {
      let n = i + 1
      [#block(width: 100%, above: 1.4em, below: 0.8em, breakable: false)[
        #grid(
          columns: (1fr, auto),
          text(weight: "bold")[Aufgabe #n: #a.titel],
          text(fill: _grau)[#_punkte-text(a.punkte)],
        )
        #v(-0.4em)
        #line(length: 100%, stroke: 0.5pt + _grau)
        #_antwortfeld(a, loesung)
        #v(0.2em)
        #align(right, text(size: 0.85em, fill: _blau, link(label("aufg-" + str(n)))[↑ Zurück zur Aufgabe]))
      ]#label(praefix + str(n))]
    }
  }
}

// ---------------------------------------------------------------- Template

/// Haupt-Template: `#show: klausur.with(...)`
///
/// - loesungen: true = Lösungsteil am Ende anhängen und in den Aufgaben
///   verlinken. Standard: an; abschaltbar mit `--input loesungen=false`.
#let klausur(
  titel: "Klausur",
  fach: "",
  datum: "",
  dauer: "",
  hinweise: none,
  loesungen: auto,
  body,
) = {
  let loesung = if loesungen == auto {
    sys.inputs.at("loesungen", default: "true") != "false"
  } else {
    loesungen
  }

  set document(title: titel)
  _mit-loesung.update(loesung)
  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2.8cm, bottom: 2.4cm),
    header: context {
      if counter(page).get().first() > 1 {
        set text(size: 0.85em, fill: _grau)
        grid(columns: (1fr, auto), titel, if fach != "" [#fach])
        v(-0.6em)
        line(length: 100%, stroke: 0.4pt + luma(200))
      }
    },
    footer: context align(center, text(size: 0.85em, fill: _grau)[
      Seite #counter(page).display() von #counter(page).final().first()
    ]),
  )
  set text(lang: "de", size: 11pt)
  set par(justify: false)

  // Titelkopf
  block(width: 100%, stroke: (bottom: 1pt), inset: (bottom: 0.8em))[
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      [
        #text(size: 1.8em, weight: "bold", titel)
        #linebreak()
        #text(fill: _grau)[#fach]
      ],
      [
        #if datum != "" [Datum: #datum #linebreak()]
        #if dauer != "" [Dauer: #dauer #linebreak()]
        #context [Gesamtpunkte: *#_aufgaben.final().map(a => a.punkte).sum(default: 0)*]
      ],
    )
  ]
  v(0.6em)
  {
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
      [Name:], line(length: 100%, stroke: 0.5pt),
    )
  }
  if hinweise != none {
    v(0.8em)
    block(width: 100%, fill: luma(245), inset: 0.8em, radius: 3pt, hinweise)
  }

  body
  _abschnitt(false)
  if loesung { _abschnitt(true) }
}
