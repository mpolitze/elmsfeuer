# ACHTUNG ! #

**Die Beschriebene Methode hat schwere Bugs (Überschreiben eigener änderungen, Löschannomalie...) - ich Rate daher, bis diese Sachen gefixt sind davon ab SVN so einzurichten!!**

```




















```

# Vorbereitung #

  * Tortoise SVN herunterladen und installieren(http://tortoisesvn.tigris.org/)
  * SVN Repository auschecken (Rechtsklick -> SVN-Checkout, Verbindungsdaten gibts hier: http://code.google.com/p/elmsfeuer/source/checkout)
  * Im Ordner in den das Repo augechekt wurde sollten sich jetzt die Unterordner mod, tmp und tools befinden.
  * Die Tools zum (Ent-)Packen benötigen **Java 1.4**!

# Einrichten des Automatischen Entpackens/Packens #

  * Rechtsklick auf den ausgecheckten Ordner: Tortoise SVN -> Settings: Hook Scripts
  * Klick auf "Add..."
  * In das sich öffnende Fenster folgende eingaben machen:
    * Hook Type: Start Commit Hook
    * Working Copy Path: Pfad zum ausgecheckten Ordner
    * Command Line To Execute: im Unterordner tools die Datei "ModToXml.cmd" auswählen. Dann in der Zeile die Quelldatei und den Zielordner ergänzen (z.B. "Elmsfeuer.mod mod")
    * Wait for script to finish auf Ja setzen.
    * Klick auf "OK"
  * Noch einmal auf "Add..."
    * Hook Type: Post Update Hook
    * Working Copy Path: Pfad zum ausgecheckten Ordner
    * Command Line To Execute: im Unterordner tools die Datei "XmlToMod.cmd" auswählen. Dann in der Zeile den Temp-, den XML-Ordner und die Zieldatei ergänzen (z.B. "tmp mod/`*` Elmsfeuer.mod" **Achtung: nicht das /`*` hinter mod vergessen!**)
    * Wait for script to finish auf Ja setzen.
    * Klick auf "OK"

Nach diesen Schritten werden bei jedem Commit/Update erst das Modul und die XML form abgeglichen.