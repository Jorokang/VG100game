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
    [   shapes [ fill color ] [ circle (coorChange env pos) (lengthChange env (cellLength/2.5)) ]
    ,   renderUpperTentacle env model x
    ]

renderUpperTentacle : EnvC -> Model -> Cell EnemyBlock -> Renderable
renderUpperTentacle env model x =
    let
        color =
            x.val.color
        pos = 
            x.pos
        id = 1
        sinPair =
            curUniqueSin model.time pos id
        sinPair2 =
            List.map (offsetPoint (offsetPoint (0.0, 50.0) pos)) sinPair
    in
    Canvas.group [] (List.map (renderCircleMap1 env color 2.6) sinPair2)


{-| rendering circle for map function -}
renderCircleMap1 : EnvC -> Color -> Float -> Point -> Renderable
renderCircleMap1 env color radius pos =
    shapes [ fill color ] [ circle (coorChange env pos) (lengthChange env radius) ]

{-| adding offset to List Point for map function -}
offsetPoint : Point -> Point -> Point
offsetPoint pos offset =
    (Tuple.first pos + Tuple.first offset, Tuple.second pos + Tuple.second offset)

{-
renderRightTentacle : EnvC -> Cell EnemyBlock -> Renderable
renderLowerTentacle : EnvC -> Cell EnemyBlock -> Renderable
renderLeftTentacle : EnvC -> Cell EnemyBlock -> Renderable

renderUpperConnection : EnvC -> Cell EnemyBlock -> Renderable
renderRightConnection : EnvC -> Cell EnemyBlock -> Renderable
renderLowerConnection : EnvC -> Cell EnemyBlock -> Renderable
renderLeftConnection : EnvC -> Cell EnemyBlock -> Renderable
-}

{-| generic function of rendering number(Int) for testing -}
renderNum : EnvC -> Int -> Renderable
renderNum env num =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env ( 50, 50 )) ("remained bricks:" ++ String.fromInt num)

{-| generic function of rendering circle -}
renderCircle : EnvC -> Point -> Int -> Color -> Renderable
renderCircle env pos radius color =
    shapes [ fill color ] [ circle (coorChange env pos) (lengthChange env (toFloat radius)) ]
