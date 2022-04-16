set "menuMaxOptions=6" & ::Maximum number of options to display
set "menuSelection=1" & ::Default Selected

::Add options to the menu below
:getOptions
set "menuOption1=%translation.menuMain.button.play%"
set "menuOption2=%translation.menuMain.button.language%"
set "menuOption3=%translation.menuMain.button.exit%"

for /l %%A in (1,1,!menuMaxOptions!) do if defined menuOption%%A (
      set "menuOption%%ARaw=!menuOption%%A!"
      set "menuOption%%A=#   !menuOption%%A!   #"
      set "menuOptionsFound=%%A"
      set "menuOption%%ALenght=0"
      set "menuOption%%ABoxLine="
      call :getLength "!menuOption%%A!" menuOption%%ALenght
      for /l %%B in (1,1,!menuOption%%ALenght!) do ( set "menuOption%%ABoxLine=!menuOption%%ABoxLine!#" )
)

if "%~1"=="exitAfter" ( exit /b )

:display
cls
call saveconfig.cmd

for /l %%A in (1,1,8) do ( echo !snakeHeader%%A! )
for /l %%A in (1,1,!menuOptionsFound!) do ( 
            if %%A==!menuSelection! (
            echo !colorGreen!!menuOption%%ABoxLine!!colorReset!
            echo !colorGreen!!menuOption%%A!!colorReset!
            echo !colorGreen!!menuOption%%ABoxLine!!colorReset!
      ) else (
            echo !menuOption%%ABoxLine!
            echo !menuOption%%A!
            echo !menuOption%%ABoxLine!
      )
      echo.
)

for /l %%A in (1,1,2) do ( echo. )
::Customize the control-key-message below
echo %translation.menuMain.controls1%
echo %translation.menuMain.controls2%

::Get input
choice /c wsad /n >nul

::Check input
if !errorlevel!==1 set /a "menuSelection-=1"
if !errorlevel!==2 set /a "menuSelection+=1"

::Check if selection is valid
if !menuSelection! leq 0 set menuSelection=!menuOptionsFound!
if !menuSelection! gtr !menuOptionsFound! set menuSelection=1

::Proceed
if !errorlevel!==3 call :action%menuSelection%
if !errorlevel!==4 call :action%menuSelection%

goto display


:getLength
set "s=#%~1"
set "len=0"
for %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
	if "!s:~%%N,1!" neq "" (
		set /a "len+=%%N"
		set "s=!s:~%%N!"
	)
)
if "%~2" neq "" ( set %~2=%len% ) else ( echo %len% )
exit /b

:action1
cls
call board.cmd
exit /b 0

:action2
cls

::Add tabcomplete
:getLanguages
pushd lang
del /f /q tabcomplete\*
if not exist tabcomplete\ ( md tabcomplete )
echo Tabcomplete asset>tabcomplete\CANCEL
echo Tabcomplete asset>tabcomplete\REAPPLY
echo Tabcomplete asset>tabcomplete\RELOAD

::Search for language files and save them in their variable
for /f "tokens=1*delims=:" %%A in ('2^>nul dir ??.cmd /b^| findstr /berinc:"..\.cmd"') do (
      set language[#]=%%A
      set language[%%A]=%%~nB
      echo Tabcomplete asset>tabcomplete\%%~nB
)

::Output the languages
:echoLanguages
if !language[#]! EQU 1 echo %translation.menuLanguage.singleAvailable%
if not !language[#]! EQU 1 echo %translation.menuLanguage.multipleAvailable%
for /l %%A in (1,1,!language[#]!) do if !language[%%A]!==!userLanguage! (
      echo - %colorYellow%!language[%%A]!%colorReset% %colorGreen%[%translation.menuLanguage.current%]%colorReset%
) else (
      echo - %colorYellow%!language[%%A]!%colorReset%
)
echo.

::Prompt the user for a language
pushd tabcomplete
echo %translation.menuLanguage.promptLanguage%
echo.
set /p "languageInput=> "
popd
set "languageAvailable=0"

::Check if the user input is a valid language
if !languageAvailable!==0 for /l %%A in (1,1,!language[#]!) do if !languageInput!==!language[%%A]! (
      set languageAvailable=1
      set userLanguage=%languageInput%
)

::Switch to the user language
if !languageAvailable!==1 (
      echo %translation.menuLanguage.switching%
      ..\sleep 2 s
      call !userLanguage!.cmd
      call :getOptions exitAfter
)

::Check for reload
if !languageAvailable!==0 if !languageInput!==RELOAD (
      echo %translation.menuLanguage.reloading%
      ..\sleep 2 s
      set "languageAvailable=1"
      popd
      cls
      goto getLanguages
)

::Check for cancel
if !languageAvailable!==0 if !languageInput!==CANCEL (
      echo %translation.menuLanguage.cancelling%
      ..\sleep 2 s
      set "languageAvailable=1"
)

::Check for reapply
if !languageAvailable!==0 if !languageInput!==REAPPLY (
      echo %translation.menuLanguage.reapplying%
      ..\sleep 2 s
      set "languageAvailable=1"
      call !userLanguage!.cmd
)
popd

if !languageAvailable!==0 (
      echo %translation.menuLanguage.notFound%
      ..\sleep 2 s
      cls
      goto getLanguages
)

exit /b 0

:action3
exit