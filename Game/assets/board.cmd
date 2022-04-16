::Set default values
:buildGame
::Set base stats
set /a "fieldSize=10" & ::Don't put even numbers here else go fuck yourself
set /a "appleAmount=2" & ::The amount of apples on the field
set /a "score=0" & ::Default score
set /a "speed=100" & ::Default speed
set /a "dead=0" & ::Putting this to 1 will be funny
for /l %%A in (1,1,!fieldSizeFull!) do set "snakeHeadPositionOld[%%A]="
for /l %%A in (1,1,!appleAmount!) do set "apple[%%A]Position=-1"

::Check if the fieldSize is even, if so add 1
set /a "fieldSizeEven=!fieldSize! %% 2"
if !fieldSizeEven! equ 0 ( set /a "fieldSize+=1" )

::Get fieldSize values
set /a "fieldSizeFull=!fieldSize!*!fieldSize!"
set /a "fieldSizeLast=!fieldSize!-1"
set /a "fieldCenter=!fieldSizeFull! / 2"
set "direction=up"
if exist board.txt del board.txt
if exist pattern.txt del pattern.txt
if exist history.txt del history.txt

set /a "snakeHeadPosition=!fieldCenter!"

::Pattern builder
set "pattern="
for /l %%. in (1,1,!fieldSize!) do set "pattern=!pattern!AB"



:: A - Grass light
:: B - Grass dark
:: C - Snake head
:: D - Snake body light
:: E - Snake body dark
:: F - Apple

goto setDirection


::Display game HUD and header
:getInput
choice /c wsad /n >nul
if !errorlevel! equ 1 set "direction=up"
if !errorlevel! equ 2 set "direction=down"
if !errorlevel! equ 3 set "direction=left"
if !errorlevel! equ 4 set "direction=right"

:setDirection
if !direction! equ up for /l %%A in (1,1,6) do ( set "snakeHudDirection%%A=%colorStrongGreen%!arrowUp%%A!%colorReset%" )
if !direction! equ down for /l %%A in (1,1,6) do ( set "snakeHudDirection%%A=%colorStrongRed%!arrowDown%%A!%colorReset%" )
if !direction! equ left for /l %%A in (1,1,6) do ( set "snakeHudDirection%%A=%colorStrongBlue%!arrowLeft%%A!%colorReset%" )
if !direction! equ right for /l %%A in (1,1,6) do ( set "snakeHudDirection%%A=%colorStrongYellow%!arrowRight%%A!%colorReset%" )

:move
::Rebuild the board
set "board="
for /l %%A in (0,1,!fieldSize!) do ( set "board=!board!!pattern:~%%A,%fieldSize%!" )

::Save old snake position
set /a "savePositionHistory=!score!"
set /a "snakeHeadPositionOld[0]=!snakeHeadPosition!"

::Snake position history
for /l %%A in (!savePositionHistory!,-1,1) do (
      set /a "savePositionHistoryLast=%%A-1"
      for %%B in (!savePositionHistoryLast!) do (
            set /a "snakeHeadPositionOld[%%A]=!snakeHeadPositionOld[%%B]"
      )
)


set /a "snakeHeadPositionLineOld=!snakeHeadPositionLine!"

::Move the snake
if !direction! equ up set /a "snakeHeadPosition=!snakeHeadPosition!-!fieldSize!"
if !direction! equ down set /a "snakeHeadPosition=!snakeHeadPosition!+!fieldSize!"
if !direction! equ left set /a "snakeHeadPosition=!snakeHeadPosition!-1"
if !direction! equ right set /a "snakeHeadPosition=!snakeHeadPosition!+1"
set /a "snakeHeadPositionLine=(!snakeHeadPosition! - 1) %% !fieldSize!"

::Check if the snake is over the board
if !snakeHeadPosition! lss 1 set /a "dead=1" & ::If snake head is over the board
if !snakeHeadPosition! gtr !fieldSizeFull! set /a "dead=1" & ::If snake head is under the board
if !snakeHeadPositionLineOld! equ !fieldSizeLast! if !snakeHeadPositionLine! equ 0 set /a "dead=1" & ::If snake head head has gone over the board (right)
if !snakeHeadPositionLineOld! equ 0 if !snakeHeadPositionLine! equ !fieldSizeLast! set /a "dead=1" & ::If snake head head has gone over the board (left)

::Check if snake head is in snake body
for /l %%A in (1,1,!savePositionHistory!) do (
      if !snakeHeadPosition! equ !snakeHeadPositionOld[%%A]! (
            set /a "dead=1"
      ) & ::If snake head colided with it's own body
)

::Check if snake head is on apple
for /l %%A in (1,1,!appleAmount!) do (
      if !snakeHeadPosition! equ !apple[%%A]Position! (
            set /a "apple[%%A]Position=-1"
            set /a "score+=1"
      ) & ::If snake head colided with apple
)

::Add apples to the board
if exist history.txt del history.txt
for /l %%A in (1,1,!appleAmount!) do (
      if !apple[%%A]Position! equ -1 (
            set /a "apple[%%A]Position=!random! %% !fieldSizeFull! + 1"

            for /l %%B in (1,1,!savePositionHistory!) do (
                  if !apple[%%A]Position! equ !snakeHeadPositionOld[%%B]! (
                        set /a "apple[%%A]Position=-1"
                  )
            )
      )

      call :setBoardPos !apple[%%A]Position! F
      echo [%time:~0,-3%] Apple %%A placed at !apple[%%A]Position! >> history.txt
)

::Add snake head to the board
call :setBoardPos !snakeHeadPosition! C

::Add snake body to the board
for /l %%A in (1,1,!score!) do (
      set /a "snakeBodySwitch=%%A %% 2"
      if !snakeBodySwitch! equ 0 ( call :setBoardPos !snakeHeadPositionOld[%%A]! D ) else ( call :setBoardPos !snakeHeadPositionOld[%%A]! E )
)

::Check if snake died
if !dead! equ 1 goto gameOver

:display
cls
echo !snakeHeaderShort1!    !snakeHudDirection1!    Score: %colorYellow%!score!%colorReset% Highscore: %colorYellow%!highscore!%colorReset%
echo !snakeHeaderShort2!    !snakeHudDirection2!    Speed: %colorYellow%!speed!%colorReset%
echo !snakeHeaderShort3!    !snakeHudDirection3!    Field size: %colorYellow%!fieldSize!%colorReset%
echo !snakeHeaderShort4!    !snakeHudDirection4!    Field size full: %colorYellow%!fieldSizeFull!%colorReset%
echo !snakeHeaderShort5!    !snakeHudDirection5!    Position: %colorYellow%!snakeHeadPosition!%colorReset%
echo !snakeHeaderShort6!    !snakeHudDirection6!    Position in Line: %colorYellow%!snakeHeadPositionLine!%colorReset%

for /l %%A in (1,1,2) do ( echo. )

echo [%time:~0,-3%] !board!>>board.txt
for /l %%A in (1,!fieldSize!,!fieldSizeFull!) do (
      set "displayLine=!board:~%%A,%fieldSize%!"
      
      if !direction! equ up ( set "displayLine=!displayLine:C=%gameSnakeHeadUp%!" )
      if !direction! equ down ( set "displayLine=!displayLine:C=%gameSnakeHeadDown%!" )
      if !direction! equ left ( set "displayLine=!displayLine:C=%gameSnakeHeadLeft%!" )
      if !direction! equ right ( set "displayLine=!displayLine:C=%gameSnakeHeadRight%!" )


      set "displayLine=!displayLine:A=%gameGrassLight%!"
      set "displayLine=!displayLine:B=%gameGrassDark%!"
      set "displayLine=!displayLine:D=%gameSnakeBodyLight%!"
      set "displayLine=!displayLine:E=%gameSnakeBodyDark%!"
      set "displayLine=!displayLine:F=%gameApple%!"
      set "displayLine=!displayLine:Z=%gameNull%!"

      echo ^| !displayLine! ^|
)

goto getInput
exit /b

:setBoardPos
for %%A in (%~1) do set /a "changeEnd=%~1+1" && for %%B in (!changeEnd!) do for %%C in (%~2) do ( set "board=!board:~0,%%A!%%C!board:~%%B!" )
exit /b

:gameOver
cls
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!translation.game.youDiedHeader1!%colorReset%
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!gameOverHeader6!
echo.
echo %colorRed%!translation.game.youDiedHeader1!%colorReset%
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!gameOverHeader5!%colorReset%
echo %colorRed%!gameOverHeader6!%colorReset%
echo.
echo %colorRed%!translation.game.youDiedHeader1!%colorReset%
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!gameOverHeader4!%colorReset%
echo %colorRed%!gameOverHeader5!%colorReset%
echo %colorRed%!gameOverHeader6!%colorReset%
echo.
echo %colorRed%!translation.game.youDiedHeader1!%colorReset%
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!gameOverHeader3!%colorReset%
echo %colorRed%!gameOverHeader4!%colorReset%
echo %colorRed%!gameOverHeader5!%colorReset%
echo %colorRed%!gameOverHeader6!%colorReset%
echo.
echo %colorRed%!translation.game.youDiedHeader1!%colorReset%
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!gameOverHeader2!%colorReset%
echo %colorRed%!gameOverHeader3!%colorReset%
echo %colorRed%!gameOverHeader4!%colorReset%
echo %colorRed%!gameOverHeader5!%colorReset%
echo %colorRed%!gameOverHeader6!%colorReset%
echo.
echo %colorRed%!translation.game.youDiedHeader1!%colorReset%
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
sleep 50 ms
cls
echo %colorRed%!gameOverHeader1!%colorReset%
echo %colorRed%!gameOverHeader2!%colorReset%
echo %colorRed%!gameOverHeader3!%colorReset%
echo %colorRed%!gameOverHeader4!%colorReset%
echo %colorRed%!gameOverHeader5!%colorReset%
echo %colorRed%!gameOverHeader6!%colorReset%
echo.
echo %colorRed%!translation.game.youDiedHeader1!%colorReset%
echo %colorRed%!translation.game.youDiedHeader2!%colorReset%
echo %colorRed%!translation.game.youDiedHeader3!%colorReset%
echo %colorRed%!translation.game.youDiedHeader4!%colorReset%
echo %colorRed%!translation.game.youDiedHeader5!%colorReset%
echo %colorRed%!translation.game.youDiedHeader6!%colorReset%
for %%. in (1,1,2) do ( echo. )
echo %translation.game.dead.player%
echo %translation.game.dead.score%
if !score! gtr !highscore! (
      echo %translation.game.dead.highscoreNew%
      set "highscore=!score!"
) else (
      echo %translation.game.dead.highscore%
)
echo.
echo %translation.game.dead.retry%
choice /c er /n >nul
if !errorlevel! equ 1 exit /b
if !errorlevel! equ 2 goto buildGame