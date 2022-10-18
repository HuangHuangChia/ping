@Echo off
C:
cd C:\Task\ping
Rem 參數設定
Set PING_OPTIONS=-n 1

Rem Date
for /f "tokens=1-4 delims=-/ " %%i IN ("%date%") DO (
SET _MyDate=%%i%%j%%k
)

Rem Time
FOR /F "tokens=1-4 delims=:. " %%a IN ("%time%") DO (
SET _MyTime=%%a%%b%%c
)

Rem 記錄檔名
Set PING_OK=PingOK%_MyDate%%_MyTime%.txt
Set PING_Err=PingErr%_MyDate%%_MyTime%.txt
Set PING_IPAddress=Ping_IPAddress.txt
Set PING_Alert=Ping_Alert.txt

chcp 65001
REM 後續命令使用的是：UTF-8編碼

:Start
If not exist %PING_IPAddress% Goto NewFile

Rem 等5秒 從休眠中喚醒
timeout /t 5 >nul

Rem ping
For /f  %%i in (%PING_IPAddress%) do (
Ping %%i %PING_OPTIONS%  >nul
if errorlevel 1 (
echo %Date% %Time%-Fail:%%i>>"%Ping_Err%"
echo 網路ping失敗:%%i>>"%Ping_Alert%"

REM Call line Notify
C:\Task\LineNotify\LineNotify_general.exe "0xQH1k7AuD1CERF9Hy12XNv8MnTOE8V6MwitbfdJHe9" %PING_Alert%
del  %PING_Alert%
)
rem else  (echo %Date% %Time%-Pass:%%i>> "%PING_OK%")
)

Goto End

:NewFile
Echo 請依序將所要測試的主機位置填輸此檔案中... > %PING_IPAddress%
Rem  ##例：>> IPAddress.txt
Echo 192.168.1.1 >> %PING_IPAddress%
Echo 192.168.1.2 >> %PING_IPAddress%
Notepad %PING_IPAddress%
Goto Start

:End
rem IF EXIST "%PING_Err%" (
rem call Notepad "%PING_Err%"
rem )

rem call Notepad %PING_OK%

