module Scenes.Level.Frame.Functions exposing (..)

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Level.LayerBase exposing (CommonData)
import Tuple exposing (first, second)


type alias EnvC =
    Env.EnvC CommonData

--transform Point to 2-Tuple of Int ( (Float,Float) to (Int,Int) by round)
point2Int : Point -> ( Int, Int )
point2Int x =
    ( round (first x), round (second x) )

--transform 2-Tuple of Int to Point ( (Int,Int) to (Float,Float) )
int2Point : ( Int, Int ) -> Point
int2Point x =
    ( toFloat (first x), toFloat (second x) )

--add 2 Points
addPoint : Point -> Point -> Point
addPoint a b =
    ( first a + first b , second a + second b )

--global coordinates control function
coorChange : EnvC -> Point -> Point
coorChange _ pos =
     pos

--global length control function
lengthChange : EnvC -> Float -> Float
lengthChange _ l =
    l
{-
****Cell:
Get the coordinates of the Cell next to the given position
-}
leftCell : Point -> Point
leftCell x =
    ( first x - cellLength, second x)

upperCell : Point -> Point
upperCell x =
    ( first x, second x - cellLength)

rightCell : Point -> Point
rightCell x =
    ( first x + cellLength, second x)

lowerCell : Point -> Point
lowerCell x =
    ( first x, second x + cellLength)

cellLength : Float
cellLength =
    100