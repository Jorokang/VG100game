module Scenes.Level.Avatar.Update exposing (..)

import Area exposing (inAcres)
import Canvas exposing (Point)
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, GridLoc, Model, nullModel)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, lowerCell, nullCoorData, pointDistance, negPoint, scalePointLength)


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
    case model.status of
        AvatarAcitve ->
            if dis == 0 then
                model

            else if dis <= maxAvatarV then
                { model
                    | pos = target_pos
                    , cur_loc = model.target_loc
                }

            else
                { model | pos = addPoint model.pos v }

        _ ->
            model
