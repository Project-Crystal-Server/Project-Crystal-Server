@echo off
cd .\Build\Release\POLAuth\
start POLAuth.exe
start POLAuth.exe --cfg polauth-mg.cfg
cd ..\..\..\
cd .\Build\Release\POLProfile\
start POLProfile.exe
cd ..\..\..\
cd .\Build\Release\POLPatch\
start POLPatch.exe
cd ..\..\..\