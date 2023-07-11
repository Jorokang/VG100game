module Scenes.Level.Avatar.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, GridLoc, Model, avatarRadius)
import Scenes.Level.Avatar.Update exposing (judgeLocAvail)
import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, cellLength, coorChange, grid2real, lengthChange, lowerCell, nullCoorData)


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


{-| render the hint of a single cell
-}
renderSingleHint : EnvC -> Model -> GridLoc -> Renderable
renderSingleHint env model loc =
    let
        offset =
            6

        real_l =
            lengthChange env (cellLength - 2 * offset) nullCoorData

        pos =
            addPoint (grid2real loc) ( offset, offset )
    in
    if judgeLocAvail model loc then
        shapes [ fill hintColor ] [ rect (coorChange env pos nullCoorData) real_l real_l ]

    else
        empty


{-| render the hints of movable cells
-}
renderMovingHint : EnvC -> Model -> List GridLoc -> Renderable
renderMovingHint env model delta_locs =
    let
        locs =
            List.map (addLoc model.cur_loc) delta_locs

        rend =
            List.map (renderSingleHint env model) locs
    in
    case model.status of
        AvatarSelected ->
            Canvas.group
                []
                rend

        _ ->
            Canvas.empty


{-| For testing
-}
renderStr : EnvC -> String -> Point -> Renderable
renderStr env str pos =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos nullCoorData) str


{-| For testing
-}
renderAvailLocs : EnvC -> Model -> Renderable
renderAvailLocs env model =
    let
        rend =
            List.map2 (renderSingleTuple env) model.avail_grids (List.range 1 100)
    in
    Canvas.group
        []
        rend


renderSingleTuple : EnvC -> ( Int, Int ) -> Int -> Renderable
renderSingleTuple env ( x, y ) d =
    let
        str =
            "(" ++ String.fromInt x ++ ", " ++ String.fromInt y ++ ")"

        pos =
            ( 800, toFloat (d * 40) )
    in
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos nullCoorData) str
