module Scenes.Level.Avatar.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, GridLoc, Model, avatarRadius)
import Scenes.Level.Avatar.Update exposing (judgeLocAvail)
import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, cellLength, coorChange, grid2real, lengthChange, nullCoorData)


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


choose1 : Float -> Float -> Float
choose1 a b =
    if a < b then
        a

    else
        b


maxShadowX : Float
maxShadowX =
    cellLength * 6


maxShadowY : Float
maxShadowY =
    cellLength * 7


{-| render the shadow
-}
renderShadow : EnvC -> Model -> Renderable
renderShadow env model =
    let
        ( px, py ) =
            model.pos

        r1 =
            cellLength * 2.6

        r2 =
            cellLength * 1.2

        l1 =
            2000

        l2 =
            1000

        r_maxX =
            lengthChange env maxShadowX nullCoorData

        r_maxY =
            lengthChange env maxShadowY nullCoorData

        rend1 =
            Canvas.group
                []
                [ shapes [ fill Color.black ] [ rect (coorChange env ( 0, 0 ) nullCoorData) (lengthChange env (px - r1) nullCoorData) r_maxY ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( 0, 0 ) nullCoorData) r_maxX (lengthChange env (py - r1) nullCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( px + r1, 0 ) nullCoorData) (lengthChange env (max (maxShadowX - px - r1) 0) nullCoorData) r_maxY ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( 0, py + r1 ) nullCoorData) r_maxX (lengthChange env (max (maxShadowY - py - r1) 0) nullCoorData) ]
                ]

        rend2 =
            Canvas.group
                [ filter "opacity(30%)" ]
                [ shapes [ fill Color.black ] [ rect (coorChange env ( max (px - r1) 0, max (py - r1) 0 ) nullCoorData) (lengthChange env (choose1 (px - r2) (r1 - r2)) nullCoorData) (lengthChange env (choose1 (py + r1) 2 * r1) nullCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( max (px - r2) 0, max (py - r1) 0 ) nullCoorData) (lengthChange env (choose1 (px + r2) (2 * r2)) nullCoorData) (lengthChange env (choose1 (py - r2) (r1 - r2)) nullCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( px + r2, py - r1 ) nullCoorData) (lengthChange env (r1 - r2) nullCoorData) (lengthChange env (choose1 (py + r1) 2 * r1) nullCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( max (px - r2) 0, py + r2 ) nullCoorData) (lengthChange env (choose1 (px + r2) (2 * r2)) nullCoorData) (lengthChange env (r1 - r2) nullCoorData) ]
                ]

        --[ renderSprite env.globalData [] (0,0) (100,100) "light_shade"]
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]


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


renderSingleTuple2 : EnvC -> ( Float, Float ) -> Renderable
renderSingleTuple2 env ( x, y ) =
    let
        str =
            "(" ++ String.fromFloat x ++ ", " ++ String.fromFloat y ++ ")"

        pos =
            ( 1000, 20 )
    in
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos nullCoorData) str
