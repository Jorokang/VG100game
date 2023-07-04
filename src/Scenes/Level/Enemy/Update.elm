module Scenes.Level.Enemy.Update exposing (..)

import Canvas exposing (Point)
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..), Cell, EnemyBlock, EnemyCore, maxEyeV)
import Base exposing (GlobalData, Msg(..))
import Scenes.Level.Enemy.Common exposing (EnemyBlock)
import Scenes.Level.Frame.Functions exposing (negPoint, pointDistance, scalePoint, coorChange, lengthChange, point2Int, upperCell, leftCell, rightCell, lowerCell, cellLength, addPoint, gridlocDistance, allGrids, grid2real)
import List
import Tuple
import Scenes.Level.Frame.Functions exposing (int2Point)
import Color exposing (Color)
import Html exposing (a)
import Scenes.Level.Enemy.Common exposing (GridLoc)
import Scenes.Level.Frame.Functions exposing (scalePointLength)

{-| The enemy erodes one cell if this cell is not contained by it -}
erodeCell : Model -> GridLoc -> Model
erodeCell model new_loc =
    if (List.any (checkCellLoc new_loc) model.body) || (Tuple.first new_loc < 0) || (Tuple.second new_loc < 0) then
        model
    else
        { model |   body = List.append model.body [generateBody new_loc]
                ,   eye =   {   pos = model.eye.pos
                            ,   v = model.eye.v
                            ,   target = model.eye.target
                            ,   target_eroded = ( new_loc == model.eye.target_loc )
                            ,   target_loc = model.eye.target_loc
                            }
                }

{-| Erode the target cell -}
erodeTarget : Model -> Model
erodeTarget model =
    erodeCell model model.target

{-| Set Enemy Target -}
setTarget : Model -> GridLoc -> Model
setTarget model loc =
    let
        eye_target =
            addPoint (grid2real loc) ( 50, 50 )
        eye_vec =
            addPoint eye_target (negPoint model.eye.pos)
        v =
            scalePointLength eye_vec maxEyeV
        targeted_eroded =
            List.any (checkCellLoc loc) model.body
        new_eye =   {   pos = model.eye.pos
                    ,   v = v
                    ,   target = eye_target
                    ,   target_eroded = targeted_eroded
                    ,   target_loc = loc
                    }
    in
    { model |   target = loc
            ,   eye = new_eye
            }

generateBody : GridLoc -> Cell EnemyBlock
generateBody loc =
    {   val = { color = Color.black
              , hp = 1
              }
    ,   loc = loc
    }

{-| check whether a cell is contained by the enemy -}
checkCellLoc : GridLoc -> Cell EnemyBlock -> Bool
checkCellLoc loc new_cell =
    if (new_cell.loc == loc) then
        True
    else
        False

{-| randomly erode a cell that is not contained -}
erodeRandomCell : Model -> Model
erodeRandomCell model =
    let
        sx = Tuple.first model.map_size
        sy = Tuple.second model.map_size
        locx = round ( (toFloat model.randNum) / 1000.0 * (toFloat sx) )
        locy = round ( (toFloat (model.randNum // 10)) / 100.0 * (toFloat sy) )
        loc = (locx, locy)
    in
    --if (List.any ( checkCellLoc loc ) model.body) then
        --erodeRandomCell model
    --else
    erodeCell model loc

{-| randomly set a cell as the target to erode -}
targetRandomCell : Model -> Model
targetRandomCell model =
    let
        sx = Tuple.first model.map_size
        sy = Tuple.second model.map_size
        locx = round ( (toFloat model.randNum) / 1000.0 * (toFloat sx) )
        locy = round ( (toFloat (model.randNum // 10)) / 100.0 * (toFloat sy) )
        loc = ( locx, locy )
    in
    setTarget model loc

{-| erode the nearest cell to the core that is not contained -}
erodeNearestCell : Model -> Model
erodeNearestCell model =
    let
        l =
            List.sortWith (comparisonPointDistance model.core.loc) (complementGrids model)  --can be optimized
        maybe_head =
            List.head l
        loc =  case maybe_head of
                    Just x ->
                        x
                    Nothing ->
                        (0,0)
    in
    erodeCell model loc

{-| set the nearest cell to the core as the target to erode -}
targetNearestCell : Model -> Model
targetNearestCell model =
    let
        l =
            List.sortWith (comparisonPointDistance model.core.loc) (complementGrids model)  --can be optimized
        maybe_head =
            List.head l
        loc =  case maybe_head of
                    Just x ->
                        x
                    Nothing ->
                        (-1, -1)
    in
    setTarget model loc

{-| generate the complementary set of enemy body in grids -}
complementGrids : Model -> List GridLoc
complementGrids model =
    Tuple.second (List.partition (\x -> (List.any (checkCellLoc x) model.body)) (allGrids model.map_size))

{-| comparison function based on the distance with core -}
comparisonPointDistance : GridLoc -> GridLoc -> GridLoc -> Order
comparisonPointDistance origin x y =
    let
        dis_x =
            gridlocDistance origin x
        dis_y = 
            gridlocDistance origin y
    in
    compare dis_x dis_y

{-| move the enemy's eye (according to its own data) -}
moveEnemyEye : Model -> Model
moveEnemyEye model =
    let
        eye =
            model.eye
        dis =
            pointDistance eye.pos eye.target
    in
    if ( eye.v == ( 0, 0 ) || eye.target_eroded == False ) then
        model
    else if ( dis < maxEyeV ) then
        { model | eye = {   pos = eye.target
                        ,   v = ( 0, 0 )
                        ,   target = eye.target
                        ,   target_eroded = True
                        ,   target_loc = eye.target_loc
                        }
        }
    else
        { model | eye = {   pos = addPoint eye.pos eye.v
                        ,   v = eye.v
                        ,   target = eye.target
                        ,   target_eroded = True
                        ,   target_loc = eye.target_loc
                        }
        }