module Scenes.Level.Enemy.Update exposing (..)

import Canvas exposing (Point)
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), Cell, EnemyBlock, EnemyCore)
import Base exposing (GlobalData, Msg(..))
import Scenes.Level.Enemy.Common exposing (EnemyBlock)
import Scenes.Level.Frame.Functions exposing (coorChange, lengthChange, point2Int, upperCell, leftCell, rightCell, lowerCell, cellLength, addPoint, pointDistance)
import List
import Tuple
import Scenes.Level.Frame.Functions exposing (int2Point)
import Color exposing (Color)
import Html exposing (a)

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
    if (new_cell.pos == pos) then
        True
    else
        False

{-| randomly erode a cell that is not contained -}
erodeRandomCell : Model -> Model
erodeRandomCell model =
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
        erodeRandomCell model
    else
        erodeCell model npos

{-| erode the nearest cell to the core that is not contained -}
erodeNearestCell : Model -> Model
erodeNearestCell model =
    let
        l =
            List.sortWith (comparisonPointDistance model.core.pos) (complementGrids model)  --can be optimized
        maybe_head =
            List.head l
        pos =  case maybe_head of
                    Just x ->
                        x
                    Nothing ->
                        (0,0)
    in
    erodeCell model pos

{-| generate the List Point of all grids -}
allGrids : Point -> List Point
allGrids map_size =
    let
        cl =
            round cellLength
        (sx,sy) =
            point2Int map_size
        nx =
            sx // cl
        ny =
            sy // cl
        lx = 
            List.map (\x -> x*cl) (List.range 1 nx)
        ly = 
            List.map (\x -> x*cl) (List.range 1 ny)

    in
    List.map2 ints2Point lx ly

{-| transfer 2 Int into Point -}
ints2Point : Int -> Int -> Point
ints2Point x y =
    ( toFloat x , toFloat y )

{-| generate the complementary set of enemy body in grids -}
complementGrids : Model -> List Point
complementGrids model =
    List.filter (\x -> (List.any (checkCellPos x) model.body)) (allGrids model.map_size)

{-| comparison function based on the distance with core -}
comparisonPointDistance : Point -> Point -> Point -> Order
comparisonPointDistance origin x y =
    let
        dis_x =
            pointDistance origin x
        dis_y = 
            pointDistance origin y
    in
    compare dis_x dis_y
