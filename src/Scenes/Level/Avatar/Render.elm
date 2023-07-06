module Scenes.Level.Avatar.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, Model, avatarRadius, nullModel)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, lowerCell, nullCoorData)


{-| render the Avatar
-}
renderAvatar : EnvC -> Model -> Renderable
renderAvatar env model =
    shapes
        [ fill Color.yellow ]
        [ circle (coorChange env model.pos nullCoorData) (lengthChange env avatarRadius nullCoorData) ]


hintColor : Color
hintColor =
    rgb255 152 251 152


{-| render the hints of movable cells
-}
renderMovingHint : EnvC -> Model -> Renderable
renderMovingHint env model =
    let
        ( locx, locy ) =
            model.cur_loc

        offset =
            6

        real_l =
            lengthChange env (cellLength - 2 * offset) nullCoorData

        left_pos =
            addPoint (grid2real ( locx - 1, locy )) ( offset, offset )

        upper_pos =
            addPoint (grid2real ( locx, locy - 1 )) ( offset, offset )

        right_pos =
            addPoint (grid2real ( locx + 1, locy )) ( offset, offset )

        lower_pos =
            addPoint (grid2real ( locx, locy + 1 )) ( offset, offset )
    in
    case model.status of
        AvatarSelected ->
            Canvas.group
                []
                [ shapes [ fill hintColor ] [ rect (coorChange env left_pos nullCoorData) real_l real_l ]
                , shapes [ fill hintColor ] [ rect (coorChange env upper_pos nullCoorData) real_l real_l ]
                , shapes [ fill hintColor ] [ rect (coorChange env right_pos nullCoorData) real_l real_l ]
                , shapes [ fill hintColor ] [ rect (coorChange env lower_pos nullCoorData) real_l real_l ]
                ]

        _ ->
            Canvas.empty


{-| For testing
-}
renderStr : EnvC -> String -> Point -> Renderable
renderStr env str pos =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos nullCoorData) str
