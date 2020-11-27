@echo off
@title FUERTE Systems Support Tool
REM FUERTE Systems Digital Network Center 
:start
cls 
mode con:cols=120 lines=30
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo Hallo FUERTE Techniker!  
echo ------------------------------------------------------------------------------------------------------------------------
echo Hier findest du das Menu bitte gebe ein welche Funktion du verwenden moechtest
echo ------------------------------------------------------------------------------------------------------------------------
echo 1) Show System Info  
echo 2) IP Sniffer (Ausschliesslich: Subnetz: 255.255.255.0)
echo 8) Show Services 
echo 9) Beenden
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
set /p "eingabe=Bitte waehlen Sie eine Funktion aus:"

if %eingabe% == 1 (
    goto :1 
)

if %eingabe% == 2 (
    goto :2
)

if %eingabe% == 8 (
    goto :8
)

if %eingabe% == 9 (
    goto :9 
) else (
echo Da ist etwas schief gelaufen :/ Bitte wiederhole deine Eingabe! 
timeout 5 
goto start
)

REM ################
REM SHOW SYSTEM INFO
REM ################

:1 
cls 
echo -----------------------------------------------------------
echo -----------------------------------------------------------
echo System Informationen
echo -----------------------------------------------------------
echo -----------------------------------------------------------
systeminfo | findstr "Hostname: Betriebssystemname: BIOS-Version: Domäne: Systemtyp:"
echo -----------------------------------------------------------
echo -----------------------------------------------------------
echo IP Adresse/n 
echo -----------------------------------------------------------
echo -----------------------------------------------------------
ipconfig | findstr "IPv4-Adresse" 

:sysinfo_end
echo -----------------------------------------------------------
echo -----------------------------------------------------------
echo 9) Zurueck zum Menu 
SET /p "sysinfo=Bitte waehlen Sie eine der Moeglichkeiten aus:"

if %sysinfo% == 9 (
    goto :start 
) else (
echo Da hat etwas nicht geklappt bitte versuchen Sie es erneut ... 
timeout 5
goto sysinfo_end
)


REM ############
REM IP SNIFFER
REM ############

:2 
cls 
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo -----------                                  Bitte geben Sie das IP Netz ein                                 -----------
echo -----------                                  Beispiel: 192.168.1.0                                           -----------
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo -----------                    Bitte geben Sie nach und nach die Stellen der IP Adresse an.                  ----------- 
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
SET /p "first=Erste Stelle ohne Punkte (z.B: 192)"
SET /p "second=Zweite Stelle ohne Punkte (z.B: 168)"
SET /p "third=Dritte Stelle ohne Punkte (z.B: 1)"
SET /p "fourth=Vierte Stelle ohne Punkte (z.B: 0)"

if "%fourth%" NEQ "0" (
echo Das IP Netz endet immer mit der 0 ! 
echo Bitte versuchen Sie es erneut. 
timeout 5
goto :2
) 

SET IP=%first%.%second%.%third%
echo ------------------------------------------------------------------------------------------------------------------------
echo Moechten Sie mit dem IP Netz fortfahren?
echo ------------------------------------------------------------------------------------------------------------------------
echo %IP%.0
echo ------------------------------------------------------------------------------------------------------------------------
echo 1) Ja 
echo 2) Nein
echo 9) Zurueck zum Menu
SET /p "check=Bitte waehlen Sie eine der beiden Moeglichkeiten aus:"

if %check% == 1 (
goto funktion_ip
) 

if %check% == 2 (
goto :2
)

if %check% == 9 (
goto :start
) else (
echo Bitte die Eingabe überprüfen. 
goto :2 
)
:funktion_ip
mode con:cols=150 lines=3000
echo Bitte warten .. Dieser Vorgang kann einige Minuten dauern 
for /l %%i IN (1,1,254) DO (
    ping %IP%.%%i -n 1 -w 1 | findstr /C:"TTL" >nul 
    if ERRORLEVEL == 1 (
echo %IP%.%%i
echo Timeout 
echo ------------------------------------------------------------------------------------------------------------------------
) else (
echo %IP%.%%i
echo IP Adresse erreichbar!
echo Nslookup:
nslookup %IP%.%%i | findstr "Name:"
echo ------------------------------------------------------------------------------------------------------------------------
)    
)
echo Fertig. :)
:ipfunktion_finish
echo 1) Ein anderes IP Netz testen 
echo 2) Zurueck zum Hauptmenu
SET /p "ipfunktion_end=Bitte waehlen Sie eine der beiden Moeglichkeiten aus:"

if %ipfunktion_end% == 1 (
goto :2 
)

if %ipfunktion_end% == 2 (
goto :start
) 
echo Bitte ueberpruefen Sie Ihre Eingabe
timeout 3 
goto ipfunktion_finish

REM #############
REM SHOW SERVICES
REM #############

:8 
cls
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo 1) Show Running Services 
echo 2) Show Stopped Services
echo 3) Show All Services

:eingabe
SET /p "service_eingabe=Bitte waehlen Sie eine der Moeglichkeiten aus:"

if %service_eingabe% == 1 (
goto running
)

if %service_eingabe% == 2 (
    goto stopped
)

if %service_eingabe% == 3 (
    goto all 
) else (
    echo Da ist etwas schief gelaufen ... Bitte versuchen Sie es erneut.
    timeout 4 
    goto eingabe
    )

:running
cls
mode con:cols=150 lines=200
color 0a
powershell Get-Service | findstr "Running"
:running_end
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo 1) Show Stopped Services 
echo 2) Show All Services
echo 9) Hauptmenu
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
SET /p "service_running=Bitte waehlen Sie eine der Moeglichkeiten aus:"
if %service_running% == 1 (
    color 0f
    goto stopped
)
if %service_running% == 2 (
    color 0f
    goto all 
) 

if %service_running% == 9 (
color 0f
goto start
) else (
echo da ist etwas schief gelaufen, bitte versuchen Sie es erneut.
goto running_end 
) 

:stopped
cls
mode con:cols=150 lines=200
color 04
powershell Get-Service | findstr "Stopped"
:stopped_end
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo 1) Show Running Services 
echo 2) Show All Services 
echo 9) Hauptmenu
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
SET /p "service_stopped=Bitte waehlen Sie eine der Moeglichkeiten aus:"
if %service_stopped% == 1 (
    color 0f
    goto running
)
if %service_stopped% == 2 (
    color 0f
    goto all
) 
if %service_stopped% == 9 (
color 0f
goto start 
) else (
echo da ist etwas schief gelaufen, bitte versuchen Sie es erneut.
goto stopped_end
) 

:all 
cls 
mode con:cols=150 lines=200
color 09 
powershell Get-Service
:all_end
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo 1) Show Running Services 
echo 2) Show Stopped Services 
echo 9) Hauptmenu
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
SET /p "service_all=Bitte waehlen Sie eine der Moeglichkeiten aus:"
if %service_all% == 1 (
    color 0f
    goto running
)
if %service_all% == 2 (
    color 0f
    goto stopped
)
if %service_all% == 9 (
    color 0f
    goto start
) else (
    echo da ist etwas schief gelaufen, bitte versuchen Sie es erneut.
    goto all_end 
)


:9
cls
mode con:cols=170 lines=70
echo ------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------
echo Vielen Dank fuer das Verwenden des Tools :) 
echo Schoenen Tag! 
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWNNNXXXXXXXXXXNNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNNXXKK000OOOOOOOOOOOOOOOOO00KKXXNWMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXXK00OOOOOOOOOOOOOO00000KKKKKKKKKXKKKKKKKXNWMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMWX00000KKKKKKKKKKK000KXNXKOkkxxxxxxxxxxxxxxxxxOKXXXXXXNNNNNNNNNNNNNNNNXXXXNWMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMNd;;,;;;;;;;;;;;;;;,;;llcl:;,,,,,,,,,,,,,,,,,;oKNNNNNNWWWWWWWWWWNNNNNNNWWNNNNWWMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,,,,,,,,,,,,,,,,cc,;c:;,',',,,,,,,,,,,,,oKWWMMMMMMMMMMMMMMMMMMMWWWWWWWWNNWMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,,,,,,,,,,,,,,,,::,,,col;,,,,,',,,,,',,,l0NMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWWWMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,,,,,,,,,,,,,,,,:::ldO00xc,,,,,,,,,,,,,,l0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWNWMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,,,,,,,,,,,,,,,,cdOK00KXNKx:,,,,,,'',,,,l0NMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMWWNNMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMXo,,,',,,,,,,,,,,,,,,,lOKKKXNWMMN0dl:,,,,,,,,,l0NMMMMMMMMMMMMMMMMMMMMMMWWWMMMNNWMMWNNMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMNo,,,,,,,,,,,,,,,,,,,,lOXNWMMMMMMWNX0o;,,,,',,l0NMMMMMMMMMMMMMMMMMMMMMMMNNWMMWNNWMMNXNMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMXo,',,,,,,,,,,,,,,,,,,lOXWMMMMMMMMMMWXkl;,',,,l0NMMMMMMMMMMMMMMMMMMMMMMMWNNWMMWXNMMWXXWMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMWN0l,,,,,,,,,,,,,,,,,,,,lOXWMMMMMMMMMWNOOKkc,,',l0NMMMMMMMMMMMMMMMMMMMMMMMMWXXWMMNKNMMNKNMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMNKOOl,,,,,,,,,,,,,,,,,,,,lOXWMMMMMMWXkdc;dNWKx:,,l0NMMMMMMMMMMMMMMMMMMMMMMMMMNXNMMWKXWMWKXWMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMWX0OOOl,,,'',,,,,,,,,,,,,,,lOXWMMMMWXkc,'',oKWWN0d:l0NMMMMMMMMMMMMMMMMMMMMMMMMMWXXWMWXKWMWKKWMMMMMMM
echo MMMMMMMMMMMMMMMMMMWN0OOOOkl,,',,,,,,,,,,,,,,,,,lOXWMMWKxc,,,,',lxkO0KK0xkO00000000000000000XWMMMMMMMNKNMWX0NMN00NMMMMMMM
echo MMMMMMMMMMMMMMMMMWK0OOOOOkc,,,,,,,,,,,,,,,,,,,,lOXWWKd:,',,,'',::,,:xNWXkc;,,,,,,,,,,,,,,,,oNMMMMMMMN0XWWX0XMN00NMMMMMMM
echo MMMMMMMMMMMMMMMMNKOOOOOOOkc,,,,,,,,,,,,,,,,,,,,lOK0d:,,,,,,,,,,::,,cONWMWKo;,',,,,,,,,,,,,,lXWMMMMMMN0KWWKOXWXO0NMMMMMMM
echo MMMMMMMMMMMMMMWX0OOOOOOOOkc,,,,,,,,,,,,,,,,,,,,lOkc,'',,,,,,,,,::,,:xKWMMWNkc,,,,,,,,,,,,,,c0WMMMMMMXOKNN0OXN0O0NMMMMMMM
echo MMMMMMMMMMMMMWXOOOOOOOOOOkc,,,,,,,,,,,,,,,,,,,,lOK0o;,,,,,,,,,,::,,,c0WMMMMWKd;,,,,,,,,,,,,c0WMMMMMWKOKNKOOKKOOKNMMMMMMM
echo MMMMMMMMMMMMWXOOOOOOOOOOOkc,,,,,,,,,,,,,,,,,,,,lOXKo::;,',,,,',::,,,,cONMMMMWNOc,,,,,,,,,,,l0WMMMMMN0OKK0O00OOOKWMMMMMMM
echo MMMMMMMMMMMWKOOOOOOOOOOO0Ol,,,,,,,,,,,,,,,,,,,,lOKx;,;::;,',,,,::,,,',;oKWMMMMWKd;,',,,,,,,c0WMMMMWKOO00OOOOOO0XWMMMMMMM
echo MMMMMMMMMMWXOOOOOOOOOOO0K0l,,,,,,,,,,,,,,,,,,,,lO0o,,,,;;:;,,,,::'',,,,,:kNMMMMMNOl,,,,,,,,c0WMMMMX0OO0OOOOOOOKNMMMMMMMM
echo MMMMMMMMMMX0OOOOOOOOOO0KNKl,,,,,,,,,,,,,,,,,,,,lO0d,',,',,;::;;::,,,,,'',;oKWMMMMWXd:,',,,,c0WMMMN0OOOOOOOOOO0XWMMMMMMMM
echo MMMMMMMMMN0OOOOOOOOOOOKXNKl,,,,,,,,,,,,,,,,,,,,lOKx;',,,,,,,;;:c;,,,,,,,',,:xNMMMMMNOl;,,,,c0WMMNKOOOOOOOOOO0XWMMMMMMMMM
echo MMMMMMMMWKOOOOOOOOOOOKXNNXo,,,,,,,,,,,,,,,,,,,,lOXKl,,,,,,,,,,,,,,,,,,,,,,,,,l0WMMMMWXx:,',c0WMWKOOOOOOOOOOOKNWMMMMMMMMM
echo MMMMMMMMXOOOOOOOOOOO0XNNWXo,,,,,,,,,,,,,,,,,,,,lOXWO:,,,,,,,,,,,,,,,,,,,,,,,,,:xXWMMMMW0o;,c0WWKOOOOOOOOOOOKNWMMMMMMMMMM
echo MMMMMMMWKOOOOOOO0OO0KXNNWNo,,,,,,,,,,,,,,,,,,,,lOXWWO:,,,,,,,,,,,,,,,,,,,,,,,,,,lOWMMMMWXxcl0NKOOOOOOOOOOOKXWMMMMMMMMMMM
echo MMMMMMMN0OO0OOO00OOKXXNWMXo,,,,,,,,,,,,,,,,,,,,lOXWMW0l,,,,,'',,,,,,,,,,,,,,,,,,,;dXWMMMMW0k00OOOOOOOOOOOKXWMMMMMMMMMMMM
echo MMMMMMWXOO0KOO0XKO0XNNWMMXo,,,,,,,,,,,,,,,,,,,,lOXWMMMXx:,,,,,,,,,,,,,,,,,,,,,,,,,,cONMMMMWKOOOOOOOOOOO0KNWMMMMMMMMMMMMM
echo MMMMMMWKO0KKOOKXKO0XNNWMMXo,,,,,,,,,,,,,,,,,,,,lOXWMMMMW0l,,,,,,,,,,,,,,,,,,,,,,,,,';oKWMWK0OOOOOOOOOO0KNWMMMMMMMMMMMMMM
echo MMMMMMWKO0XKO0XNKOKNNNMMMXo,,,,,,,,,,,,,,,,,,,,lOXWMMMMMMNx:,,,,,,,,,,,,,,,,,,,,,,,,,,cOX0OOOOOOOOOOO0XNWMMMMMMMMMMMMMMM
echo MMMMMMWKOKNKO0XNK0KNNWMMMXo,,,,,,,,,,,,,,,,,,,,lOXNXNMMMMMWKko;,',,,,,,,,,,,,,,,,,',,;lkOOOOOOOOOOO0KXNWMMMMMMMMMMMMMMMM
echo MMMMMMWK0XNX00NNX0KNNWMMMXo,',,,,,,,,,,,,,,,,,,lOXXoo0WMMMMMMNkc,,,,,,,,,,,,,,,,,,,,cdkOOOOOOOOOOO0XNWMMMMMMMMMMMMMMMMMM
echo MMMMMMWK0XNX00NNNXKNNWMMMW0kxdddddddddddoddooddx0XXo,:xNMMMMMMWKo;',,,,,,,,,,,,,,,:okOOOOOOOOOOO0KXNWMMMMMMMMMMMMMMMMMMM
echo MMMMMMMX0XNNXKXNNNXXNWMMMMMMWNXXXXXXXXXXXXXXXXXXXNXo,,,l0WMMMMMMNOc,,,,,,,,,,,,,:okOOOOOOOOOOO0KXNWMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMNKXWNNXXNNWNXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,:xXWMMMMMWXd;,,,,,,,,,:oxOOOOOOOOOOOOOKNWWMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMXKNNWWXNWWMNXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,',,lOXWMMMMMWOl,,,,,,:okOOOOOOOOOOOkdcoKWMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMWXNWWWWXNWWMWNNWMMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,',;cdXMMMMMMXx:,;cdkOOOOOOOOOOOkdc;':OWMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMWXNWWMWNNWMMWWWWMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,,,,',cONMMMMMW0dxOOOOOOOOOOOOxo:,,,':kWMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMWNNWWMWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,',,,,,,,;dKWMWNX0OOOOOOOOOOOkdl;,',,,,cOWMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMWNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,,',,,,',l0XK0OOOOOOOOOOkxl:,,,,,,,';oKWMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMWNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,,,',,,;coxOOOOOOOOOOOkxo:;,''',,,,',lONMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMWNNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo,,,,;:coddxOOOOOOOOOOO0KKx;',,,,,',,',:oOXWMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMWNNXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMNxclodxkOOOOOOOOOOOOkOKXNNNk;',,,,,',,:okKNWMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMWNXXXXNNWWWMMMMMMMMMMMMWWWNNNXXKOOOOOOOOOOOOOOkxdoc::xXWWKl,,,,,,;:ldOKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMWNXK000KKKKKKKXKKKKK0000OOOOOOOOOOOO0000KKK0Okxdddx0NWXOxdddxkO0KXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMWWNXXKK0000OOOOOOOOOOOO00000KKKKXXNNNWWWWWWNNNNNNWMMWWNNNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWNNNXXXXXXXXXXXNNNNNWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
timeout 5
exit
