module Scenes.Level.Enemy.Update exposing (..)

import Canvas exposing (Point)
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), Cell, EnemyBlock)
import Base exposing (GlobalData, Msg(..))
import Scenes.Level.Enemy.Common exposing (EnemyBlock)
import List


erodeCell : Model -> Cell EnemyBlock -> Model
erodeCell model new_cell =
    if (List.any (checkCellPos new_cell.pos) model.body) then
        model
    else
        { model | body = List.append model.body [new_cell] }

checkCellPos : Point -> Cell EnemyBlock -> Bool
checkCellPos pos new_cell =
    if (new_cell.pos == pos) then
        True
    else
        False