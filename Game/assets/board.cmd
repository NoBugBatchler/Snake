::Set default values
set /a "score=0"
set /a "speed=100"
set /a "fieldSize=20"

set /a "fieldSizeFull=!fieldSize!*!fieldSize!"


::Display game HUD
echo !snakeHeaderShort1!
echo !snakeHeaderShort2!    Score: %colorYellow%!score!%colorReset%
echo !snakeHeaderShort3!    Speed: %colorYellow%!speed!%colorReset%
echo !snakeHeaderShort4!    Field size: %colorYellow%!fieldSize!%colorReset%
echo !snakeHeaderShort5!    Field size full: %colorYellow%!fieldSizeFull!%colorReset%
echo !snakeHeaderShort6!

for /l %%A in (1,1,2) do ( echo. )

echo Score: %colorYellow%!score!%colorReset%
echo Speed: %colorYellow%!speed!%colorReset%
echo Field size: %colorYellow%!fieldSize!%colorReset%
echo Field size full: %colorYellow%!fieldSizeFull!%colorReset%


pause >nul