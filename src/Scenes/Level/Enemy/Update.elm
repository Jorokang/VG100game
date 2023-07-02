module Scenes.Level.Enemy.Update exposing (..)

import Canvas exposing (Point)
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), Cell, EnemyBlock)
import Base exposing (GlobalData, Msg(..))
import Scenes.Level.Enemy.Common exposing (EnemyBlock)
import Scenes.Level.Frame.Functions exposing (coorChange, lengthChange, point2Int, upperCell, leftCell, rightCell, lowerCell, cellLength, addPoint)
import List
import Tuple
import Scenes.Level.Frame.Functions exposing (int2Point)
import Color exposing (Color)

{-| The enemy erodes one cell if this cell is not contained by it -}
erodeCell : Model -> Point -> Model
erodeCell model new_pos =
    if (List.any (checkCellPos new_pos) model.body) then
        model
    else
        { model | body = List.append model.body [generateBody new_pos] }

generateBody : Point -> Cell EnemyBlock
generateBody pos =
    {   val = { color = Color.black
              , hp = 1
              }
    ,   pos = pos
    }

{-| check whether a cell is contained by the enemy -}
checkCellPos : Point -> Cell EnemyBlock -> Bool
checkCellPos pos new_cell =
    False
{-
    if (new_cell.pos == pos) then
        True
    else
        False-}

randomErodeCell : Model -> Model
randomErodeCell model =
    let
        sx = Tuple.first model.map_size
        sy = Tuple.second model.map_size
        fx = (toFloat model.randNum) / 1000.0 * sx
        fy = (toFloat (model.randNum // 10)) / 100.0 * sy
        nx = (round fx) // (round cellLength)
        ny = (round fy) // (round cellLength)
        npos = int2Point (nx*(round cellLength),ny*(round cellLength))
    in
    if (List.any ( checkCellPos npos ) model.body) then
        randomErodeCell model
    else
        erodeCell model npos
