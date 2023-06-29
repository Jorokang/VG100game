module Scenes.Level.Enemy.Render exposing (..)

import Canvas exposing (Renderable, empty, Point, group, shapes, circle, rect, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Base exposing (GlobalData, Msg(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), EnemyBlock, Cell)
import Scenes.Level.SceneInit exposing (LevelInit)
import Scenes.Level.Frame.Functions exposing (coorChange, point2Int, upperCell, leftCell, rightCell, lowerCell, cellLength)
import Scenes.Level.Frame.Functions exposing (lengthChange)
import List

renderEnemyBody : EnvC -> Model -> Renderable
renderEnemyBody env model =
    let
        rend =
            List.map (renderEnemyBlock env model) model.body
    in
    Canvas.group
    []
    rend

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
    
renderEnemyBlockCentral : EnvC -> Cell EnemyBlock -> Renderable
renderEnemyBlockCentral env x =
    let
        color =
            x.val.color
        pos = 
            x.pos
    in
    shapes [ fill color ] [ circle (coorChange env pos) (lengthChange env (cellLength/2.5)) ]

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