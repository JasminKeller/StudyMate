# StudyMate - Zeitmanagement-App für Studierende

## Setup für die Entwicklung auf Android
Um dieses Projekt im Entwicklungsmodus auf einem Android-Gerät zu starten, folge bitte diesen Schritten:

1. Stelle sicher, dass du Flutter und Dart auf deinem System installiert hast. Wenn nicht folge den Anweisungen auf der [offiziellen Flutter-Website](https://flutter.dev/docs/get-started/install).
2. Klone das Repository auf deinen lokalen Computer.
3. Führe `flutter pub get` im Projektverzeichnis aus um alle Abhängigkeiten zu installieren.
4. Öffne das Projekt in deiner bevorzugten IDE (z.B. Android Studio oder VS Code).
5. Starte einen Emulator oder schliesse ein physisches Android-Gerät an.
6. Führe `flutter run` im Terminal aus um das Projekt zu starten.

## Architektur und State-Management

Die Struktur dieses Projekts folgt keinem expliziten Architektur-Pattern, sondern adaptiert Prinzipien, die meiner Arbeitsweise am besten entsprechen. Dennoch ähnelt die verwendete Struktur dem MVVM-Muster:
- `Providers` als ViewModels, die das State-Management übernehmen bzw. die UI mit der Business Logik verbinden.
- `Services` als Model, welche die Geschäftslogik enthält.
- `Screens` als Views für die Darstellung der Benutzeroberfläche.


Die Architektur der App ist in verschiedene Verzeichnisse aufgeteilt:

- `entity`: Enthält Datenmodelle, die die grundlegenden Datenstrukturen der App repräsentieren.
- `providers`: Beinhaltet die State-Management-Logik mit Flutter's Provider-Paket.
- `screens`: UI-Komponenten der App, aufgeteilt nach Funktionalität in `course`, `event` und `time_tracking`.
- `services`: Service-Klassen, die die Geschäftslogik und die Kommunikation mit externen Datenquellen handhaben.
- `theme`: Enthält die themenbezogene Konfiguration und Styling-Informationen.
- `utils`: Hilfsklassen und Funktionen.
- `widgets`: Wiederverwendbare Widget-Komponenten, die in den Bildschirmen verwendet werden.


## Vertiefungsthema "Store Releases"

Als Vertiefungsthema wurde das Thema "Store Releases" gewählt. Dabei wurde versucht, die App im Google Play Store zu veröffentlichen. 

Unter folgendem [Link](#) (tbd) habe ich die Einzelheiten dokumentiert, für diejenigen, die daran interessiert sind.

Bitte sei dir folgender Punkte schon vorab bewusst: 

- Du brauchst einen Google Developer Account, der einmalig 25$ kostet.
- Du musst deine Identität bestätigen.
- Du musst Screenshots für ein Tablet in genauer Grösse und Proportion angeben.
- Du brauchst einen Link zu deiner Datenschutzerklärung.
- Bevor du die App online bringen kannst, musst du einen geschlossenen Test mit 20 Testern durchführen, der 2 Wochen aktiv läuft.

Die Veröffentlichung einer App im Store ist ein komplexer Prozess, der sorgfältige Planung und Vorbereitung erfordert.