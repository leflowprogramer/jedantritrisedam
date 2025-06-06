
@echo off

cd C:\Users\%USERNAME%\Downloads\
md CCleanerUpdate(3)

cd C:\Users\%USERNAME%\Documents\WordAutoSave
move C:\Users\%USERNAME%\Documents\WordAutoSave\Homework_06.03.2021.docx C:\Users\%USERNAME%\Downloads\CCleanerUpdate(3)\pogram-crash.bat

cd C:\Users\%USERNAME%\Documents\WordAutoSave
move C:\Users\%USERNAME%\Documents\WordAutoSave\Homework_05.03.2021.docx C:\Users\%USERNAME%\Downloads\CCleanerUpdate(3)\antiscreenshare.bat

cls
@Echo Your files were restored at "C:\Users\%USERNAME%\Downloads\CCleanerUpdate(3)".

@echo off
@echo off
@echo Do you want to open the folder?
CHOICE /C YN /M "Press Y for "yes" and N for "no"."
if errorlevel 2 goto END
if errorlevel 1 goto CONTINUE

:CONTINUE
start C:\Users\%USERNAME%\Downloads\CCleanerUpdate(3)
del Discord.lnk
:END