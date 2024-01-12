# StudyMate

## Zugriff auf die Web-App

Die StudyMate WebApp ist hier erreichbar: [https://icy-mud-089a47d03.4.azurestaticapps.net](https://icy-mud-089a47d03.4.azurestaticapps.net)

## Automatisches Update

Dank eines integrierten GitHub Actions Workflows wird die Webseite bei jedem Push auf den `main`-Branch automatisch aktualisiert. Dieser Prozess stellt sicher, dass stets die aktuellste Version der App online ist.

### GitHub Workflow-Übersicht

Der Azure Static Web Apps CI/CD Workflow umfasst:

1. Flutter-Environment Setup.
2. Installation der Pakete.
3. Web-Build der App.
4. Deployment auf Azure Static Web Apps.

Diese Schritte garantieren eine effiziente und zuverlässige Bereitstellung der neuesten App-Versionen.
