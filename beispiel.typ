#import "klausur.typ": *

#show: klausur.with(
  titel: "Klausur Mathematik I",
  fach: "Mathematik für Informatiker",
  datum: "09.10.2026",
  dauer: "90 Minuten",
  hinweise: [Erlaubte Hilfsmittel: ein handbeschriebenes A4-Blatt. Antworten bitte im Antwortbogen am Ende eintragen.],
)

#aufgabe(
  titel: "Hauptstädte",
  art: "mc",
  punkte: 2,
  frage: [Welche Stadt ist die Hauptstadt von Frankreich? (genau eine Antwort)],
  optionen: ([Berlin], [Paris], [Rom], [Madrid]),
  antwort: (1,),
)

#aufgabe(
  titel: "Begriffe zuordnen",
  art: "zuordnung",
  punkte: 3,
  frage: [Ordnen Sie jedem Begriff die passende Definition zu.],
  links: ([Primzahl], [Gerade Zahl], [Quadratzahl]),
  rechts: ([Zahl, die durch 2 teilbar ist], [Zahl der Form $n^2$], [Zahl mit genau zwei Teilern]),
  antwort: (2, 0, 1),
)

#aufgabe(
  titel: "Stabilität erklären",
  art: "freitext",
  punkte: 5,
  frage: [Erklären Sie in eigenen Worten, was ein Grenzwert einer Folge ist.],
  antwort: [Ein Grenzwert $a$ ist eine Zahl, der sich die Folgenglieder beliebig nahe annähern: ab einem Index $N$ gilt $|a_n - a| < epsilon$.],
)

#aufgabe(
  titel: "Ableitung",
  art: "mathe",
  punkte: 4,
  frage: [Berechnen Sie die Ableitung von $f(x) = x^3 sin(x)$.],
  antwort: [$f'(x) = 3x^2 sin(x) + x^3 cos(x)$],
)
