module Scenes.Level.Enemy.Render exposing (..)

import Canvas exposing (Renderable, empty, Point, group, shapes, circle, rect, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), EnemyBlock, Cell)
import Scenes.Level.SceneInit exposing (LevelInit)
import Scenes.Level.Frame.Functions exposing (coorChange, lengthChange, point2Int, upperCell, leftCell, rightCell, lowerCell, cellLength, addPoint)
import Scenes.Level.Enemy.Random exposing (curUniqueSin)
import List
import Tuple
import Color exposing (Color)
import Scenes.Level.Frame.Functions exposing (int2Point)

{-| render the whole enemy body(explicitly the body field in model) -}
renderEnemyBody : EnvC -> Model -> Renderable
renderEnemyBody env model =
    let
        rend =
            List.map (renderEnemyBlock env model) model.body
    in
    Canvas.group
    []
    rend

{-| render a single enemy block -}
renderEnemyBlock : EnvC -> Model -> Cell EnemyBlock -> Renderable
renderEnemyBlock env model x =
    let
        pos =
            x.pos
        tmp_enemyblock =
            x.val
        color =
            tmp_enemyblock.color
    in
    Canvas.group
    []
    [   renderEnemyBlockCentral env model x 
    ,   renderSingleTentacle env model x 1
    ]

{-| Render the central part of an enemy block,
    which is a circle exists as long as there is a block. -}
renderEnemyBlockCentral : EnvC -> Model -> Cell EnemyBlock -> Renderable
renderEnemyBlockCentral env model x =
    let
        color =
            x.val.color
        pos = 
            x.pos
    in
    Canvas.group
    []
    [   shapes [ fill color ] [ rect (coorChange env pos) (lengthChange env (cellLength)) (lengthChange env (cellLength)) ]
    ]

renderSingleTentacle : EnvC -> Model -> Cell EnemyBlock -> Int -> Renderable
renderSingleTentacle env model x id =
    let
        color =
            x.val.color
        pos = 
            x.pos
        sinPair =
            curUniqueSin model.time pos id
        (rotate, offset) =
            (0, (3.6*cellLength, (1.0+toFloat(id)/10)*cellLength))
        rend =
            List.map (renderTentaclePixels env model color (rotate, offset) ) sinPair
    in
    Canvas.group
    []
    rend

isOdd : Int -> Int
isOdd x =
    let
        str =
            String.fromInt x
        strr =
            String.right 1 str
    in
    case strr of
        "1" -> 1
        "3" -> 3
        "5" -> 5
        "7" -> 7
        "9" -> 9
        _ -> 0
    

renderTentaclePixels : EnvC -> Model -> Color -> (Int, Point) -> Point -> Renderable
renderTentaclePixels env model color (rotate, offset) pos =
    let
        x =
            Tuple.first pos
        y =
            Tuple.second pos
        flag0 =
            model.randNum + round y
        delta = 0
        flag1 = isOdd flag0
        flag2 = isOdd (flag0//2)
        flag3 = isOdd (flag0//4)
        flag4 = isOdd (flag0//8)
        l1 = isOdd ((model.randNum + (round y))//2) +1
        l2 = isOdd ((model.randNum + (round y))//3) +1
        l3 = isOdd ((model.randNum + (round y))//4) +1
        l4 = isOdd ((model.randNum + (round y))//5) +1
        l5 = isOdd ((model.randNum + (round y))//6) +1
        l6 = isOdd ((model.randNum + (round y))//7) +1
        l7 = isOdd ((model.randNum + (round y))//8) +1
        l8 = isOdd ((model.randNum + (round y))//9) +1
        offset1 = int2Point (-l5, l8)
        offset2 = int2Point (l6, -l7)
        offset3 = int2Point (-l7, l6)
        offset4 = int2Point (l8, -l5)
    in
    Canvas.group []
    [   renderTentaclePixel env color (x, y+delta) l1 (rotate, addPoint offset offset1) flag1
    ,   renderTentaclePixel env color (x, y+2*delta) l2 (rotate, addPoint offset offset2) flag2
    ,   renderTentaclePixel env color (x, y-delta) l3 (rotate, addPoint offset offset3) flag3
    ,   renderTentaclePixel env color (x, y-2*delta) l4 (rotate, addPoint offset offset4) flag4
    ,   renderNum env flag1
    ]
    
renderTentaclePixel : EnvC -> Color -> Point -> Int -> (Int, Point) -> Int -> Renderable
renderTentaclePixel env color pos l (rotate, offset) flag =
    --if (flag==1) then
        shapes [ fill color ] [ rect (coorChange env (offsetPoint rotate offset pos)) (lengthChange env (toFloat l)) (lengthChange env (toFloat l)) ]
    --else
      --  Canvas.group [] []

{-| applying offset & rotation to List Point for map function
    rotate  direction (clock-wise degrees)
    0       0
    1       90
    2       180
    3       270
-}
offsetPoint : Int -> Point -> Point -> Point
offsetPoint rotate offset pos =
    let
        (x, y) = pos
        (nx, ny) =    case  rotate of
                        0 ->    (x, y)
                        1 ->    (y, -x)
                        2 ->    (-x, -y)
                        3 ->    (-y, x)
                        _ ->    (x, y)
    in
    (nx + Tuple.first offset, ny + Tuple.second offset)


{-| rendering circle for map function -}
renderCircleMap1 : EnvC -> Color -> Float -> Point -> Renderable
renderCircleMap1 env color radius pos =
    shapes [ fill color ] [ circle (coorChange env pos) (lengthChange env radius) ]

{-| generic function of rendering number(Int) for testing -}
renderNum : EnvC -> Int -> Renderable
renderNum env num =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env ( 50, 50 )) ("remained bricks:" ++ String.fromInt num)

{-| generic function of rendering circle -}
renderCircle : EnvC -> Point -> Int -> Color -> Renderable
renderCircle env pos radius color =
    shapes [ fill color ] [ circle (coorChange env pos) (lengthChange env (toFloat radius)) ]
