module Scenes.Level.Enemy.Render exposing (..)

import Canvas exposing (Renderable, empty, Point, group, shapes, circle, rect, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), EnemyBlock, Cell)
import Scenes.Level.SceneInit exposing (LevelInit)
import Scenes.Level.Frame.Functions exposing (coorChange, lengthChange, point2Int, upperCell, leftCell, rightCell, lowerCell, cellLength)
import Scenes.Level.Enemy.Random exposing (curUniqueSin)
import List
import Tuple
import Color exposing (Color)

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
    renderEnemyBlockCentral env model x 

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
    [   shapes [ fill color ] [ circle (coorChange env (offsetPoint 0 (cellLength/2, cellLength/2) pos)) (lengthChange env (cellLength/2.5)) ]
    ,   renderSingleTentacle env model x 1
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
            (0, (4*cellLength, 1.5*cellLength))
        rend =
            List.map (renderTentaclePixels env model color (rotate, offset) ) sinPair
    in
    Canvas.group
    []
    rend

renderTentaclePixels : EnvC -> Model -> Color -> (Int, Point) -> Point -> Renderable
renderTentaclePixels env model color (rotate, offset) pos =
    let
        x =
            Tuple.first pos
        y =
            Tuple.second pos
        flag0 =
            modBy (model.randNum + round y) 16
        delta = 3.0
        flag1 = modBy flag0 2
        flag2 = modBy (flag0//2) 2
        flag3 = modBy (flag0//4) 2
        flag4 = modBy (flag0//8) 2
        l1 = (modBy (model.randNum + ((round y)//2) ) 2) + 1
        l2 = (modBy (model.randNum + ((round y)//3) ) 2) + 1
        l3 = (modBy (model.randNum + ((round y)//4) ) 2) + 1
        l4 = (modBy (model.randNum + ((round y)//5) ) 2) + 1
    in
    Canvas.group []
    [   renderTentaclePixel env color (x, y+delta) l1 (rotate, offset) flag1
    ,   renderTentaclePixel env color (x, y+2*delta) l2 (rotate, offset) flag2
    ,   renderTentaclePixel env color (x, y-delta) l3 (rotate, offset) flag3
    ,   renderTentaclePixel env color (x, y-2*delta) l4 (rotate, offset) flag4
    ]
    
renderTentaclePixel : EnvC -> Color -> Point -> Int -> (Int, Point) -> Int -> Renderable
renderTentaclePixel env color pos l (rotate, offset) flag =
    if (flag==1) then
        shapes [ fill color ] [ rect (coorChange env (offsetPoint rotate offset pos)) (lengthChange env (toFloat l)) (lengthChange env (toFloat l)) ]
    else
        Canvas.group [] []

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
