# Typst-Klausur-Template

Template für Klausuren mit Multiple-Choice-, Zuordnungs-, Freitext- und Mathe-Aufgaben.
Jede Aufgabe bekommt automatisch ein Antwortfeld auf dem **Antwortbogen** am Ende.
Im PDF springt man per Link von der Aufgabe zum Antwortfeld (`→ Zum Antwortfeld`) und zurück (`↑ Zurück zur Aufgabe`).

Ein fertiges Beispiel liegt auf dem Branch `beispiel` (`beispiel.typ`).

## Benutzung

```typst
#import "klausur.typ": *

#show: klausur.with(
  titel: "Klausur Mathematik I",
  fach: "Mathematik",
  datum: "09.10.2026",
  dauer: "90 Minuten",
  hinweise: [Erlaubte Hilfsmittel: keine.],   // optional
)

#aufgabe(
  titel: "Hauptstädte",
  art: "mc",
  punkte: 2,
  frage: [Welche Stadt ist die Hauptstadt von Frankreich?],
  optionen: ([Berlin], [Paris], [Rom]),
  antwort: (1,),
)
```

Kompilieren:

```sh
typst compile klausur.typ                          # Klausur (leere Antwortfelder)
typst compile --input loesungen=true klausur.typ   # Musterlösung
```

Alternativ `loesungen: true` in `klausur.with(...)` setzen.

## `klausur.with(...)`

| Parameter | Bedeutung |
|---|---|
| `titel`, `fach`, `datum`, `dauer` | Titelkopf |
| `hinweise` | optionaler Hinweiskasten unter dem Kopf |
| `loesungen` | `true`/`false`; Standard: `--input loesungen=true`, sonst `false` |

Die Gesamtpunktzahl wird automatisch aus den Aufgaben berechnet.

## `aufgabe(...)`

| Parameter | Bedeutung |
|---|---|
| `titel` | Titel der Aufgabe |
| `art` | `"mc"`, `"zuordnung"`, `"freitext"` oder `"mathe"` |
| `punkte` | erreichbare Punkte (Standard 1) |
| `frage` | Aufgabentext |
| `antwort` | Musterlösung, nur sichtbar im Lösungsmodus |
| `optionen` | Antwortoptionen (nur `mc`) |
| `links`, `rechts` | linke und rechte Spalte (nur `zuordnung`) |
| `zeilen` | Zeilen des Freitextfelds (Standard 8) |
| `hoehe` | Höhe des Rechenfelds (nur `mathe`, Standard `6cm`) |

### Aufgabenarten

| `art` | Antwortfeld | `antwort` |
|---|---|---|
| `mc` | Kästchen A, B, C … | Array von Indizes ab 0, z. B. `(1, 3)` |
| `zuordnung` | Tabelle: linker Eintrag und Kästchen für den Buchstaben | je linkem Eintrag der Index (ab 0) des rechten Eintrags, z. B. `(2, 0, 1)` |
| `freitext` | liniertes Feld | Content |
| `mathe` | kariertes Feld | Content, z. B. `[$f'(x) = 2x$]` |

## Hilfsfunktionen

`checkbox(gefuellt: false)`, `linienfeld(zeilen:, inhalt:)`, `rasterfeld(hoehe:, inhalt:)`
