@echo off
setlocal enableextensions
setlocal enableDelayedExpansion
set "gameVersion=1"
set "gameDirectory=%~dp0"
set "setCodes=true"
call inject.dll getinput.dat

::Set game codes
if "!setCodes!" equ "true" (
      ::Colors
      if "!setCodes!" equ "true" (
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
      if "!setCodes!" equ "true" (
            set "gameBlock=.."

            set "gameGrassLight=!fullColorStrongGreen!!gameBlock!!colorReset!"
            set "gameGrassDark=!fullColorGreen!!gameBlock!!colorReset!"
            set "gameSnakeHead=!fullColorAqua!!gameBlock!!colorReset!"
            set "gameSnakeBody=!fullColorYellow!!gameBlock!!colorReset!"
            set "gameApple=!fullColorStrongRed!!gameBlock!!colorReset!"
      )


      ::Heading/banner for Snake
      if "!setCodes!" equ "true" (
            set "snakeHeaderShort1= _____                _         "
            set "snakeHeaderShort2=/  ___|              | |        "
            set "snakeHeaderShort3=\ `--.  _ __    __ _ | | __ ___ "
            set "snakeHeaderShort4= `--. \| '_ \  / _` || |/ // _ \"
            set "snakeHeaderShort5=/\__/ /| | | || (_| ||   <|  __/"
            set "snakeHeaderShort6=\____/ |_| |_| \__,_||_|\_\\___|"

            set "snakeHeader1= _____                _             _               ______  _   _   ___  "
            set "snakeHeader2=/  ___|              | |           | |              |  _  \| \ | | / _ \ "
            set "snakeHeader3=\ `--.  _ __    __ _ | | __ ___    | |__   _   _    | | | ||  \| |/ /_\ \"
            set "snakeHeader4= `--. \| '_ \  / _` || |/ // _ \   | '_ \ | | | |   | | | || . ` ||  _  |"
            set "snakeHeader5=/\__/ /| | | || (_| ||   <|  __/   | |_) || |_| |   | |/ / | |\  || | | |"
            set "snakeHeader6=\____/ |_| |_| \__,_||_|\_\\___|   |_.__/  \__, |   |___/  \_| \_/\_| |_/"
            set "snakeHeader7=                                            __/ |                        "
            set "snakeHeader8=                                           |___/                         "
      )

)

::Get config
if exist config.cmd call config.cmd

::Define undefined variables
if not defined userLanguage set "userLanguage=en"
if not defined highscore set "highscore=0"
if not defined joins set "joins=1"
::if not defined playerName set "playerName=Player"

::Read language
if exist lang\!userLanguage!.cmd ( call lang\!userLanguage!.cmd ) else ( echo !userLanguage! is not available )

::Count join
set /a "joins+=1"

::Title
title %translation.main.title%

::Fullscreen recommendation
for /l %%A in (1,1,3) do ( echo !translation.main.fullscreen%%A! )
timeout /nobreak /t 2 >nul
for /l %%A in (1,1,3) do ( echo. )


:promptUserName
if not defined playerName (
      echo %translation.game.greeting%
      set /p "playerName=> "
      cls
      if defined playerName (
            echo %translation.game.greeting2%
            timeout /nobreak /t 2 >nul
      )
)
if not defined playerName goto promptUserName

:menu
call menu\main.cmd

pause >nul