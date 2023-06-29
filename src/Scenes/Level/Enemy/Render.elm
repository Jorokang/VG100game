module Scenes.Level.Enemy.Render exposing (..)

import Canvas exposing (Renderable, empty, Point, group, shapes, circle, rect, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), EnemyBlock, Cell)
import Scenes.Level.SceneInit exposing (LevelInit)
import Scenes.Level.Frame.Functions exposing (coorChange, point2Int, upperCell, leftCell, rightCell, lowerCell, cellLength)
import Scenes.Level.Frame.Functions exposing (lengthChange)
import List

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
    renderEnemyBlockCentral env x 

{-| Render the central part of an enemy block,
    which is a circle exists as long as there is a block. -}
renderEnemyBlockCentral : EnvC -> Cell EnemyBlock -> Renderable
renderEnemyBlockCentral env x =
    let
        color =
            x.val.color
        pos = 
            x.pos
    in
    shapes [ fill color ] [ circle (coorChange env pos) (lengthChange env (cellLength/2.5)) ]

{-| generic function of rendering number(Int) for testing -}
renderNum : EnvC -> Int -> Renderable
renderNum env num =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] ( 50, 50 ) ("remained bricks:" ++ String.fromInt num)

{-
renderUpperTentacle : EnvC -> Cell EnemyBlock -> Renderable
renderRightTentacle : EnvC -> Cell EnemyBlock -> Renderable
renderLowerTentacle : EnvC -> Cell EnemyBlock -> Renderable
renderLeftTentacle : EnvC -> Cell EnemyBlock -> Renderable

renderUpperConnection : EnvC -> Cell EnemyBlock -> Renderable
renderRightConnection : EnvC -> Cell EnemyBlock -> Renderable
renderLowerConnection : EnvC -> Cell EnemyBlock -> Renderable
renderLeftConnection : EnvC -> Cell EnemyBlock -> Renderable
-}