rmdir /q /s temp
rmdir /q /s cryptores
mkdir temp
xcopy config.json temp\
xcopy project.manifest temp\
xcopy version.manifest temp\
xcopy /s /y src_et\*.* temp\src_et\
xcopy /s /y res\*.* temp\res\
crypto.exe -o -d -en -t -rd sfx -md5 temp cryptores ncmj@1235
crypto.exe -o -d -of mp3 -md5 temp cryptores/s
rmdir /q /s temp
cd cryptores/s
ren * *.mp3
pause
