# Typst-Klausur-Template

Template für Klausuren mit Multiple-Choice-, Zuordnungs-, Freitext- und Mathe-Aufgaben.
Jede Aufgabe bekommt automatisch ein leeres Antwortfeld auf dem **Antwortbogen** am Ende.
Danach folgt ein **Lösungsteil** mit den Musterlösungen aus `antwort:`.
Im PDF springt man per Link von der Aufgabe zum Antwortfeld (`→ Zum Antwortfeld`) und zur Lösung (`→ Zur Lösung`); von dort führt `↑ Zurück zur Aufgabe` zurück.

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
typst compile klausur.typ                           # mit Lösungsteil
typst compile --input loesungen=false klausur.typ   # Studierenden-Version ohne Lösungen
```

Alternativ `loesungen: false` in `klausur.with(...)` setzen.

## `klausur.with(...)`

| Parameter | Bedeutung |
|---|---|
| `titel`, `fach`, `datum`, `dauer` | Titelkopf |
| `hinweise` | optionaler Hinweiskasten unter dem Kopf |
| `loesungen` | `true`/`false`: Lösungsteil und Lösungs-Links; Standard `true`, abschaltbar mit `--input loesungen=false` |

Die Gesamtpunktzahl wird automatisch aus den Aufgaben berechnet.

## `aufgabe(...)`

| Parameter | Bedeutung |
|---|---|
| `titel` | Titel der Aufgabe |
| `art` | `"mc"`, `"zuordnung"`, `"freitext"` oder `"mathe"` |
| `punkte` | erreichbare Punkte (Standard 1) |
| `frage` | Aufgabentext |
| `antwort` | Musterlösung, erscheint im Lösungsteil |
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
