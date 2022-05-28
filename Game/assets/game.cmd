@echo off
setlocal enableextensions
setlocal enableDelayedExpansion
set /a "gameVersion=5"
set /a "setCodes=1"
chcp 65001 >nul
set "gameDirectory=%~dp0"
call inject.dll getinput.dll

if exist ..\DEBUG ( set /a "debug=1" ) else ( set /a "debug=0" )

::Set game codes
(
      ::Colors
      if !setCodes! equ 1 (
            ::Foreground colors
            set "colorBlack=[30m"
            set "colorRed=[31m"
            set "colorGreen=[32m"
            set "colorYellow=[33m"
            set "colorBlue=[34m"
            set "colorMagenta=[35m"
            set "colorCyan=[36m"
            set "colorWhite=[37m"

            ::Background colors
            set "bgColorBlack=[40m"
            set "bgColorRed=[41m"
            set "bgColorGreen=[42m"
            set "bgColorYellow=[43m"
            set "bgColorBlue=[44m"
            set "bgColorMagenta=[45m"
            set "bgColorCyan=[46m"
            set "bgColorWhite=[47m"

            ::Strong Foreground colors
            set "colorStrongBlack=[90m"
            set "colorStrongRed=[91m"
            set "colorStrongGreen=[92m"
            set "colorStrongYellow=[93m"
            set "colorStrongBlue=[94m"
            set "colorStrongMagenta=[95m"
            set "colorStrongCyan=[96m"
            set "colorStrongWhite=[97m"

            ::Strong Background colors
            set "bgColorStrongBlack=[100m"
            set "bgColorStrongRed=[101m"
            set "bgColorStrongGreen=[102m"
            set "bgColorStrongYellow=[103m"
            set "bgColorStrongBlue=[104m"
            set "bgColorStrongMagenta=[105m"
            set "bgColorStrongCyan=[106m"
            set "bgColorStrongWhie=[107m"

            ::Full color
            set "fullColorBlack=!colorBlack!!bgColorBlack!"
            set "fullColorRed=!colorRed!!bgColorRed!"
            set "fullColorGreen=!colorGreen!!bgColorGreen!"
            set "fullColorYellow=!colorYellow!!bgColorYellow!"
            set "fullColorBlue=!colorBlue!!bgColorBlue!"
            set "fullColorMagenta=!colorMagenta!!bgColorMagenta!"
            set "fullColorCyan=!colorCyan!!bgColorCyan!"
            set "fullColorWhite=!colorWhite!!bgColorWhite!"

            ::Strong Full color
            set "fullColorStrongBlack=!colorStrongBlack!!bgColorStrongBlack!"
            set "fullColorStrongRed=!colorStrongRed!!bgColorStrongRed!"
            set "fullColorStrongGreen=!colorStrongGreen!!bgColorStrongGreen!"
            set "fullColorStrongYellow=!colorStrongYellow!!bgColorStrongYellow!"
            set "fullColorStrongBlue=!colorStrongBlue!!bgColorStrongBlue!"
            set "fullColorStrongMagenta=!colorStrongMagenta!!bgColorStrongMagenta!"
            set "fullColorStrongCyan=!colorStrongCyan!!bgColorStrongCyan!"
            set "fullColorStrongWhite=!colorStrongWhite!!bgColorStrongWhite!"

            ::Reset
            set "colorReset=[0m"
      )

      ::Game blocks
      if !setCodes! equ 1 (
            set "gameBlock=.."

            set "gameSnakeHeadUp=!bgColorBlue!!colorStrongBlack!^'^'!colorReset!"
            set "gameSnakeHeadDown=!bgColorBlue!!colorStrongBlack!..!colorReset!"
            set "gameSnakeHeadLeft=!bgColorBlue!!colorStrongBlack!: !colorReset!"
            set "gameSnakeHeadRight=!bgColorBlue!!colorStrongBlack! :!colorReset!"

            set "gameGrassLight=!fullColorStrongGreen!!gameBlock!!colorReset!"
            set "gameGrassDark=!fullColorGreen!!gameBlock!!colorReset!"
            set "gameSnakeBodyLight=!fullColorStrongYellow!!gameBlock!!colorReset!"
            set "gameSnakeBodyDark=!fullColorYellow!!gameBlock!!colorReset!"
            set "gameApple=!fullColorStrongRed!!gameBlock!!colorReset!"
            set "gameNull=!fullColorStrongBlack!!gameBlock!!colorReset!"
      )

      ::Heading/banner for Snake
      if !setCodes! equ 1 (
            set "snakeHeaderShort1=  _____                _         "
            set "snakeHeaderShort2= / ____|              | |        "
            set "snakeHeaderShort3=| (___   _ __    __ _ | | __ ___ "
            set "snakeHeaderShort4= \___ \ | '_ \  / _` || |/ // _ \"
            set "snakeHeaderShort5= ____) || | | || (_| ||   <|  __/"
            set "snakeHeaderShort6=|_____/ |_| |_| \__,_||_|\_\\___|"

            set "snakeHeader1=  _____                _           _              _   _  ____   ____  "
            set "snakeHeader2= / ____|              | |         | |            | \ | ||  _ \ |  _ \ "
            set "snakeHeader3=| (___   _ __    __ _ | | __ ___  | |__   _   _  |  \| || |_) || |_) |"
            set "snakeHeader4= \___ \ | '_ \  / _` || |/ // _ \ | '_ \ | | | | | . ` ||  _ < |  _ < "
            set "snakeHeader5= ____) || | | || (_| ||   <|  __/ | |_) || |_| | | |\  || |_) || |_) |"
            set "snakeHeader6=|_____/ |_| |_| \__,_||_|\_\\___| |_.__/  \__, | |_| \_||____/ |____/ "
            set "snakeHeader7=                                           __/ |                      "
            set "snakeHeader8=                                          |___/                       "
      )

      ::Arrows
      if !setCodes! equ 1 (
            set "arrowUp1=      .      "
            set "arrowUp2=    .:;:.    "
            set "arrowUp3=  .:;;;;;:.  "
            set "arrowUp4=    ;;;;;    "
            set "arrowUp5=    ;;;;;    "
            set "arrowUp6=    ;;;;;    "
            
            set "arrowDown1=    ;;;;;    "
            set "arrowDown2=    ;;;;;    "
            set "arrowDown3=    ;;;;;    "
            set "arrowDown4=  ..;;;;;..  "
            set "arrowDown5=   ':::::'   "
            set "arrowDown6=     ':`     "

            set "arrowLeft1=     .       "
            set "arrowLeft2=   .;;...... "
            set "arrowLeft3= .;;;;:::::: "
            set "arrowLeft4=  ':;;:::::: "
            set "arrowLeft5=    ':       "
            set "arrowLeft6=             "

            set "arrowRight1=       .     "
            set "arrowRight2= ......;;.   "
            set "arrowRight3= ::::::;;;;. "
            set "arrowRight4= ::::::;;:'  "
            set "arrowRight5=       :'    "
            set "arrowRight6=             "
      )

)

::Get config
if exist config.cmd call config.cmd

::Define undefined variables
if not defined userLanguage set "userLanguage=english"
if not defined highscore set "highscore=0"
if not defined joins set "joins=1"
::if not defined playerName set "playerName=Player"

::Read language
:getLang
if exist lang\!userLanguage!.cmd ( call lang\!userLanguage!.cmd ) else (
      echo !userLanguage! is not available
      set "userLanguage=english"
      goto getLang
)

::Count join
set /a "joins+=1"

::Title
title %translation.main.title%

::Fullscreen recommendation
for /l %%A in (1,1,3) do ( echo !translation.main.fullscreen%%A! )
sleep 2 s
for /l %%A in (1,1,3) do ( echo. )

:promptUserName
if not defined playerName (
      echo %translation.game.greeting%
      set /p "playerName=> "
      cls
      if defined playerName (
            echo %translation.game.greeting2%
            sleep 2 s
      ) else (
            goto promptUserName
      )
)

:menu
call menu\main.cmd

pause >nul