@java -cp tools\nwn-tools.jar org.progeeks.nwn.XmlToGff %1 %2
@java -cp tools\nwn-tools.jar org.progeeks.nwn.ModPacker %1 %3
@del /Q %1
@del /Q System.out