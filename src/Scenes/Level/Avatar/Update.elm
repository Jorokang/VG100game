module Scenes.Level.Avatar.Update exposing (..)

import Area exposing (inAcres)
import Base exposing (Msg(..))
import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, GridLoc, Model, avatarRadius, nullModel)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, lowerCell, negPoint, nullCoorData, pointDistance, scalePointLength)


{-| judge selection of the Avatar
-}
judgeAvatarSelection : EnvC -> Point -> Model -> Bool
judgeAvatarSelection env click_pos model =
    let
        dis =
            pointDistance click_pos model.pos
    in
    dis <= avatarRadius


{-| judge selection of the four grids surrounding the Avatar
1: left
2: up
3: right
4: lower
-}
judgeMovingSelection : EnvC -> Point -> Model -> Int
judgeMovingSelection env click_pos model =
    let
        ( locx, locy ) =
            model.cur_loc

        size =
            ( cellLength, cellLength )

        left_pos =
            grid2real ( locx - 1, locy )

        upper_pos =
            grid2real ( locx, locy - 1 )

        right_pos =
            grid2real ( locx + 1, locy )

        lower_pos =
            grid2real ( locx, locy + 1 )
    in
    if judgeMouseRect click_pos left_pos size then
        1

    else if judgeMouseRect click_pos upper_pos size then
        2

    else if judgeMouseRect click_pos right_pos size then
        3

    else if judgeMouseRect click_pos lower_pos size then
        4

    else
        0


{-| get the center of the GridLoc
-}
loc2Pos : GridLoc -> Point
loc2Pos ( lx, ly ) =
    ( (toFloat lx + 0.5) * cellLength, (toFloat ly + 0.5) * cellLength )


{-| ensure that the pos is synchronized with loc
-}
setAvatarPos : Model -> Model
setAvatarPos model =
    let
        new_pos =
            if model.cur_loc == model.target_loc then
                loc2Pos model.cur_loc

            else
                model.pos
    in
    { model | pos = new_pos }


{-| set the moving target for the model
-}
setAvatarTarget : Model -> GridLoc -> Model
setAvatarTarget model loc =
    { model
        | target_loc = loc
        , status = AvatarMoving
    }


maxAvatarV : Float
maxAvatarV =
    5


{-| Decide the motion of the Avatar
-}
moveAvatar : Model -> Model
moveAvatar model =
    let
        target_pos =
            loc2Pos model.target_loc

        dis =
            pointDistance model.pos target_pos

        vec =
            addPoint target_pos (negPoint model.pos)

        v =
            scalePointLength vec maxAvatarV
    in
    if dis <= maxAvatarV then
        { model
            | pos = target_pos
            , cur_loc = model.target_loc
            , status = AvatarAcitve
        }

    else
        { model | pos = addPoint model.pos v }


{-| update function when model.status == AvatarActive
-}
updateModelActive : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelActive env model =
    case env.msg of
        MouseDown x ( a, b ) ->
            if judgeAvatarSelection env ( a, b ) model then
                ( { model | status = AvatarSelected }
                , []
                , env
                )

            else
                ( model, [], env )

        _ ->
            ( model, [], env )


{-| update function when model.status == AvatarSelected
-}
updateModelSelected : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelSelected env model =
    case env.msg of
        MouseDown x ( a, b ) ->
            let
                ( locx, locy ) =
                    model.cur_loc
            in
            case judgeMovingSelection env ( a, b ) model of
                1 ->
                    ( setAvatarTarget model ( locx - 1, locy )
                    , []
                    , env
                    )

                2 ->
                    ( setAvatarTarget model ( locx, locy - 1 )
                    , []
                    , env
                    )

                3 ->
                    ( setAvatarTarget model ( locx + 1, locy )
                    , []
                    , env
                    )

                4 ->
                    ( setAvatarTarget model ( locx, locy + 1 )
                    , []
                    , env
                    )

                _ ->
                    ( { model | status = AvatarAcitve }
                    , []
                    , env
                    )

        _ ->
            ( model, [], env )


{-| update function when model.status == AvatarMoving
-}
updateModelMoving : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelMoving env model =
    case env.msg of
        Tick new_time ->
            ( moveAvatar model
            , []
            , env
            )

        _ ->
            ( model, [], env )
