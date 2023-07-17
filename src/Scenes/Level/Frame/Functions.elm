module Scenes.Level.Frame.Functions exposing (..)

import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
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
    ( first a + first b, second a + second b )


{-| add to GridLoc together
-}
addLoc : ( Int, Int ) -> ( Int, Int ) -> ( Int, Int )
addLoc a b =
    ( first a + first b, second a + second b )



--mutiply the Point by a float k


scalePoint : Point -> Float -> Point
scalePoint ( x, y ) k =
    ( x * k, y * k )



--the opposite of given Point


negPoint : Point -> Point
negPoint ( x, y ) =
    ( -x, -y )



--set the length of the point to k in the same direction


scalePointLength : Point -> Float -> Point
scalePointLength pos k =
    let
        norm =
            pointDistance ( 0, 0 ) pos
    in
    if norm == 0 then
        pos

    else
        scalePoint pos (k / norm)



--global coordinates control function


type CoorType
    = CoorUI
    | CoorCard
    | CoorMap
    | CoorNull


type alias CoorData = {
        coortype : CoorType
    ,   offset : Point
    ,   scale : Float
    --  Other Data
    }


nullCoorData : CoorData
nullCoorData = {
        coortype = CoorNull
    ,   offset = (0,0)
    ,   scale = 1
    }

mapCoorData : CoorData
mapCoorData = {
        coortype = CoorMap
    ,   offset = (0,0)
    ,   scale = 1
    }

nextRoundBCoorData : CoorData
nextRoundBCoorData = {
        coortype = CoorUI
    ,   offset = (0, 0)
    ,   scale = 1
    }

offsetCoorMap : Point
offsetCoorMap =
    ( 400, 100 )

scaleCoorMap : Float
scaleCoorMap = 
    0.5


coorChange : EnvC -> Point -> CoorData -> Point
coorChange env pos cdata =
    let
        npos1 = addPoint (scalePoint pos cdata.scale) cdata.offset
        npos2 = case cdata.coortype of
                    CoorMap ->
                        addPoint (scalePoint npos1 scaleCoorMap) offsetCoorMap

                    _ ->
                        npos1
    in
    npos2
        |> posToReal env.globalData



{-| global length control function
-}
lengthChange : EnvC -> Float -> CoorData -> Float
lengthChange env l cdata =
    let
        nl1 = l*cdata.scale
        nl2 =    case cdata.coortype of
                    CoorMap ->
                        nl1*scaleCoorMap
                    _ ->
                        nl1
    in
    nl2
        |> lengthToReal env.globalData

sizeChange : EnvC -> Point -> CoorData -> Point
sizeChange env (l1, l2) cdata =
    ( lengthChange env l1 cdata, lengthChange env l2 cdata )

{-|
   ****Cell:
   Get the coordinates of the Cell next to the given position
-}


leftCell : Point -> Point
leftCell x =
    ( first x - cellLength, second x )


upperCell : Point -> Point
upperCell x =
    ( first x, second x - cellLength )


rightCell : Point -> Point
rightCell x =
    ( first x + cellLength, second x )


lowerCell : Point -> Point
lowerCell x =
    ( first x, second x + cellLength )



--define the global length of a cell in the map


cellLength : Float
cellLength =
    100


{-| point distance
-}
pointDistance : Point -> Point -> Float
pointDistance x y =
    sqrt ((Tuple.first x - Tuple.first y) ^ 2 + (Tuple.second x - Tuple.second y) ^ 2)


{-| GridLoc distance (Int version of point distance)
-}
gridlocDistance : ( Int, Int ) -> ( Int, Int ) -> Float
gridlocDistance ( x1, y1 ) ( x2, y2 ) =
    sqrt (toFloat (x1 - x2) ^ 2 + toFloat (y1 - y2) ^ 2)


{-| generate the List Point of all grids
-}
allGrids : ( Int, Int ) -> List ( Int, Int )
allGrids map_size =
    let
        ( sx, sy ) =
            map_size

        lx =
            List.range 0 ((sx + 1) * (sy + 1) - 1)
    in
    List.map (map2d (sx + 1)) lx


{-| transfer 2 Int into Point
-}
map2d : Int -> Int -> ( Int, Int )
map2d max_line cur =
    ( modBy max_line cur, cur // max_line )


{-| transfer GridLoc into real position
-}
grid2real : ( Int, Int ) -> Point
grid2real ( x, y ) =
    ( toFloat x * cellLength, toFloat y * cellLength )


{-| transfer real position into GridLoc
-}
real2grid : Point -> ( Int, Int )
real2grid ( x, y ) =
    ( round x // round cellLength, round y // round cellLength )
