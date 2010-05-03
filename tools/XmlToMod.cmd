@java -cp C:\Users\mappo\Desktop\modpacker\nwn-tools.jar org.progeeks.nwn.XmlToGff %1 %2
@java -cp C:\Users\mappo\Desktop\modpacker\nwn-tools.jar org.progeeks.nwn.ModPacker %1 %3
@del /S tmp/*
@del /S System.out