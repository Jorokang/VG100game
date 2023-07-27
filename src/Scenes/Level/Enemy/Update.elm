module Scenes.Level.Enemy.Update exposing (..)

import Base exposing (GlobalData, Msg(..))
import Canvas exposing (Point)
import Color exposing (Color)
import Html exposing (a)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import List
import Scenes.Level.Enemy.Common exposing (Cell, EnemyBlock, EnemyCore, EnemyState(..), EnvC, ErodePriority(..), GridLoc, Model, initEnemy1, maxEyeV, nullModel)
import Scenes.Level.Frame.Functions exposing (addPoint, allGrids, grid2real, gridlocDistance, int2Point, leftCell, lengthChange, lowerCell, negPoint, point2Int, pointDistance, real2grid, rightCell, scalePoint, scalePointLength, upperCell)
import Tuple


curPriority : Model -> ErodePriority
curPriority model =
    Maybe.withDefault ErodeRandom (List.head model.target_priority)


popPriority : Model -> Model
popPriority model =
    { model | target_priority = List.drop 1 model.target_priority }


{-| basic settings when enemy's round begin
-}
updateEnemyRound : Model -> Model
updateEnemyRound model =
    { model
        | recursion_times = 0
        , target_priority = model.static_priority
        , eroding = True
    }


updatePlayerRound : Model -> Model
updatePlayerRound model =
    { model
        | recursion_times = 0
        , target_priority = model.static_priority
        , eroding = False
    }


updateEndRound : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateEndRound env model =
    ( { model | eroding = False }
    , [ ( LayerName "Frame", LayerMsgPlayerTurn ) ]
    , env
    )


resetRecursionTimes : Model -> Model
resetRecursionTimes model =
    { model | recursion_times = 0 }


{-| should be used when recursing
-}
increaseRecursionNum : Model -> Model
increaseRecursionNum model =
    { model | recursion_times = model.recursion_times + 1 }


{-| update the enemy at setting target status

1.  choose the target by priority
2.  send LayerMsg to frame to ask for permission

flag : immediately erode

-}
updateEnemySettingTarget : EnvC -> Model -> ErodePriority -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateEnemySettingTarget env model prior =
    let
        n_model =
            case prior of
                ErodeNearest ->
                    targetNearestCell model

                ErodeRandom ->
                    targetRandomCell model
    in
    ( { n_model
        | status = EnemySettingTarget
        , recursion_times = n_model.recursion_times + 1
      }
    , [ ( LayerName "Frame", LayerMsgErodePermission n_model.target 0 ) ]
    , env
    )


{-| handle permission LayerMsg
-}
handlePermissionMsg : EnvC -> Model -> Int -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
handlePermissionMsg env model permission =
    let
        avail_num =
            List.length (complementGrids model)

        permitted_lmsg =
            if model.eroding then
                [ ( LayerName "Enemy", LayerMsgEnemyErodeTarget ) ]

            else
                []
    in
    if model.recursion_times <= avail_num then
        case permission of
            1 ->
                ( { model | status = EnemyMoving }
                , permitted_lmsg
                , env
                )

            _ ->
                updateEnemySettingTarget env (increaseRecursionNum model) ErodeRandom

    else
        updateEndRound env model


{-| handle protect cell msg
-}
handleProtectMsg : EnvC -> Model -> GridLoc -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
handleProtectMsg env model loc =
    if loc == model.target then
        updateEnemySettingTarget env model ErodeNearest

    else
        ( model, [], env )


{-| The enemy erodes one cell if this cell is not contained by it
-}
erodeCell : Model -> GridLoc -> Model
erodeCell model new_loc =
    let
        ( nx, ny ) =
            new_loc

        ( sx, sy ) =
            model.map_size
    in
    if List.any (checkCellLoc new_loc) model.body || (nx < 0) || (ny < 0) || (nx > sx) || (ny > sy) then
        model

    else
        { model
            | body = List.append model.body [ generateBody new_loc ]
            , eye =
                { pos = model.eye.pos
                , v = model.eye.v
                , target = model.eye.target
                , target_eroded = new_loc == model.eye.target_loc
                , target_loc = model.eye.target_loc
                }
        }


{-| Erode the target cell
-}
erodeTarget : Model -> Model
erodeTarget model =
    erodeCell model model.target


{-| Set Enemy Target
-}
setTarget : Model -> GridLoc -> Model
setTarget model loc =
    let
        eye_target =
            addPoint (grid2real loc) ( 50, 50 )

        eye_vec =
            addPoint eye_target (negPoint model.eye.pos)

        v =
            scalePointLength eye_vec maxEyeV

        target_eroded =
            List.any (checkCellLoc loc) model.body

        new_eye =
            { pos = model.eye.pos
            , v = v
            , target = eye_target
            , target_eroded = target_eroded
            , target_loc = loc
            }
    in
    { model
        | target = loc
        , eye = new_eye
    }


generateBody : GridLoc -> Cell EnemyBlock
generateBody loc =
    { val =
        { color = Color.black
        , hp = 1
        }
    , loc = loc
    }


{-| check whether a cell is contained by the enemy
-}
checkCellLoc : GridLoc -> Cell EnemyBlock -> Bool
checkCellLoc loc new_cell =
    if new_cell.loc == loc then
        True

    else
        False


{-| randomly erode a cell that is not contained
-}
erodeRandomCell : Model -> Model
erodeRandomCell model =
    let
        sx =
            Tuple.first model.map_size

        sy =
            Tuple.second model.map_size

        locx =
            round (toFloat model.randNum / 1000.0 * toFloat sx)

        locy =
            round (toFloat (model.randNum // 10) / 100.0 * toFloat sy)

        loc =
            ( locx, locy )
    in
    erodeCell model loc


{-| set the core as target ( which means the enemy skip this round )
-}
targetCore : Model -> Model
targetCore model =
    setTarget model model.core.loc


{-| randomly set a cell as the target to erode
-}
targetRandomCell : Model -> Model
targetRandomCell model =
    let
        cl =
            complementGrids model

        mod_num =
            List.length cl

        cl2 =
            List.drop (modBy mod_num model.randNum) cl

        head0 =
            List.head cl2

        head1 =
            case head0 of
                Just x ->
                    x

                Nothing ->
                    ( 0, 0 )
    in
    setTarget model head1


{-| erode the nearest cell to the core that is not contained
-}
erodeNearestCell : Model -> Model
erodeNearestCell model =
    let
        l =
            List.sortWith (comparisonPointDistance model.core.loc) (complementGrids model)

        --can be optimized
        maybe_head =
            List.head l

        loc =
            case maybe_head of
                Just x ->
                    x

                Nothing ->
                    ( 0, 0 )
    in
    erodeCell model loc


{-| set the nearest cell to the core as the target to erode
-}
targetNearestCell : Model -> Model
targetNearestCell model =
    let
        l =
            List.sortWith (comparisonPointDistance model.core.loc) (complementGrids model)

        --can be optimized
        maybe_head =
            List.head l

        loc =
            case maybe_head of
                Just x ->
                    x

                Nothing ->
                    ( -1, -1 )
    in
    setTarget model loc


{-| set the particular cell uneroded
-}
freeCell : Model -> GridLoc -> Model
freeCell model loc =
    let
        ( nx, ny ) =
            loc

        ( sx, sy ) =
            model.map_size

        new_model1 =
            { model | body = List.filter (\x -> x.loc /= loc) model.body }

        new_model2 =
            if loc == real2grid model.eye.pos then
                setTarget new_model1 model.core.loc

            else
                new_model1
    in
    if (nx < 0) || (ny < 0) || (nx > sx) || (ny > sy) then
        model

    else
        new_model2


{-| click to free cell
-}
clickFreeCell : Model -> Point -> Model
clickFreeCell model click_pos =
    let
        loc =
            real2grid click_pos
    in
    freeCell model loc


{-| generate the complementary set of enemy body in grids
-}
complementGrids : Model -> List GridLoc
complementGrids model =
    Tuple.second (List.partition (\x -> List.any (checkCellLoc x) model.body) (allGrids model.map_size))


{-| comparison function based on the distance with core
-}
comparisonPointDistance : GridLoc -> GridLoc -> GridLoc -> Order
comparisonPointDistance origin x y =
    let
        dis_x =
            gridlocDistance origin x

        dis_y =
            gridlocDistance origin y
    in
    compare dis_x dis_y


{-| move the enemy's eye (according to its own data)
-}
moveEnemyEye : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
moveEnemyEye env model =
    let
        eye =
            model.eye

        dis =
            pointDistance eye.pos eye.target
    in
    if eye.v == ( 0, 0 ) || eye.target_eroded == False then
        ( { model | status = EnemyAlive }
            |> popPriority
        , [ ( LayerName "Enemy", LayerMsgEnemySetTarget ) ]
        , env
        )

    else if dis < maxEyeV then
        ( { model
            | eye =
                { pos = eye.target
                , v = ( 0, 0 )
                , target = eye.target
                , target_eroded = True
                , target_loc = eye.target_loc
                }
            , status = EnemyAlive
          }
            |> popPriority
        , [ ( LayerName "Enemy", LayerMsgEnemySetTarget ) ]
        , env
        )

    else
        ( { model
            | eye =
                { pos = addPoint eye.pos eye.v
                , v = eye.v
                , target = eye.target
                , target_eroded = True
                , target_loc = eye.target_loc
                }
          }
        , []
        , env
        )
