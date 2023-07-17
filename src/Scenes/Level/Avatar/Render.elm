module Scenes.Level.Avatar.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, rect, shapes, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Html exposing (label)
import List exposing (length)
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), CardSelectionStatus(..), EnvC, GridLoc, Model, avatarRadius, cardClickPos0, cardClickPos1, maxSpirit)
import Scenes.Level.Avatar.Update exposing (judgeLocAvail)
import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, allGrids, cellLength, coorChange, grid2real, lengthChange, mapCoorData)


type FilterMode
    = FilterModeNone
    | FilterModeAvailCell
    | FilterModeMapCell


{-| render the Avatar
-}
renderAvatar : EnvC -> Model -> Renderable
renderAvatar env model =
    shapes
        [ fill Color.yellow ]
        [ circle (coorChange env model.pos mapCoorData) (lengthChange env avatarRadius mapCoorData) ]


{-| settings for rendering hints
-}
hintSetting : List Setting
hintSetting =
    let
        hint_color =
            rgb255 152 251 152
    in
    [ filter "opacity(50%)"
    , fill hint_color
    ]


{-| render the hint of a single cell
-}
renderSingleHint : EnvC -> Model -> FilterMode -> GridLoc -> Renderable
renderSingleHint env model mode loc =
    let
        offset =
            6

        real_l =
            lengthChange env (cellLength - 2 * offset) mapCoorData

        pos =
            addPoint (grid2real loc) ( offset, offset )

        judge =
            case mode of
                FilterModeNone ->
                    True

                FilterModeAvailCell ->
                    judgeLocAvail model loc

                FilterModeMapCell ->
                    List.any (\x -> x == loc) (allGrids model.map_size)
    in
    if judge then
        shapes hintSetting [ rect (coorChange env pos mapCoorData) real_l real_l ]

    else
        empty


{-| render multiple hints
-}
renderMultiHint : EnvC -> Model -> List GridLoc -> FilterMode -> Renderable
renderMultiHint env model delta_locs mode =
    let
        locs =
            List.map (addLoc model.cur_loc) delta_locs

        rend =
            List.map (renderSingleHint env model mode) locs
    in
    Canvas.group
        []
        rend


{-| render moving hints
-}
renderMovingHint : EnvC -> Model -> Renderable
renderMovingHint env model =
    case model.status of
        AvatarSelected ->
            renderMultiHint env model cardClickPos0 FilterModeAvailCell

        _ ->
            Canvas.empty


{-| render card hint
-}
renderCardHint : EnvC -> Model -> Renderable
renderCardHint env model =
    case model.card_status of
        CardType_1 ->
            renderMultiHint env model cardClickPos1 FilterModeMapCell

        CardType_2 ->
            renderMultiHint env model cardClickPos0 FilterModeAvailCell

        CardType_None ->
            Canvas.empty


{-| tool function
-}
choose1 : Float -> Float -> Float
choose1 a b =
    if a < b then
        a

    else
        b


maxShadowX : Float
maxShadowX =
    cellLength * 4


maxShadowY : Float
maxShadowY =
    cellLength * 5


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
            lengthChange env maxShadowX mapCoorData

        r_maxY =
            lengthChange env maxShadowY mapCoorData

        rend1 =
            Canvas.group
                []
                [ shapes [ fill Color.black ] [ rect (coorChange env ( 0, 0 ) mapCoorData) (lengthChange env (px - r1) mapCoorData) r_maxY ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( 0, 0 ) mapCoorData) r_maxX (lengthChange env (py - r1) mapCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( px + r1, 0 ) mapCoorData) (lengthChange env (max (maxShadowX - px - r1) 0) mapCoorData) r_maxY ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( 0, py + r1 ) mapCoorData) r_maxX (lengthChange env (max (maxShadowY - py - r1) 0) mapCoorData) ]
                ]

        rend2 =
            Canvas.group
                [ filter "opacity(30%)" ]
                [ shapes [ fill Color.black ] [ rect (coorChange env ( max (px - r1) 0, max (py - r1) 0 ) mapCoorData) (lengthChange env (choose1 (px - r2) (r1 - r2)) mapCoorData) (lengthChange env (choose1 (py + r1) 2 * r1) mapCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( max (px - r2) 0, max (py - r1) 0 ) mapCoorData) (lengthChange env (choose1 (px + r2) (2 * r2)) mapCoorData) (lengthChange env (choose1 (py - r2) (r1 - r2)) mapCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( px + r2, py - r1 ) mapCoorData) (lengthChange env (r1 - r2) mapCoorData) (lengthChange env (choose1 (py + r1) 2 * r1) mapCoorData) ]
                , shapes [ fill Color.black ] [ rect (coorChange env ( max (px - r2) 0, py + r2 ) mapCoorData) (lengthChange env (choose1 (px + r2) (2 * r2)) mapCoorData) (lengthChange env (r1 - r2) mapCoorData) ]
                ]

        --[ renderSprite env.globalData [] (0,0) (100,100) "light_shade"]
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]


{-| render the spirit value in a long box
-}
renderSpirit : EnvC -> Model -> Renderable
renderSpirit env model =
    let
        max_box_color =
            Color.rgb255 25 25 112

        --dark blue
        label_pos =
            ( 550, 40 )

        ( box_x, box_y ) =
            ( 450, 50 )

        ( box_l, box_w ) =
            ( 200, 15 )

        ( spirit_x, spirit_y ) =
            ( 460, 53 )

        ( spirit_max_l, spirit_w ) =
            ( 180, 9 )

        spirit_l =
            toFloat spirit_max_l / toFloat maxSpirit * toFloat model.spirit

        spirit_color =
            Color.rgb255 255 240 245

        --LavenderBlush
        render_label =
            Canvas.group
                [ fill Color.white ]
                [ text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env label_pos mapCoorData) "spirit" ]

        render_max_box =
            shapes
                [ fill max_box_color ]
                [ rect (coorChange env ( box_x, box_y ) mapCoorData) (lengthChange env box_l mapCoorData) (lengthChange env box_w mapCoorData) ]

        render_spirit =
            shapes
                [ fill spirit_color ]
                [ rect (coorChange env ( spirit_x, spirit_y ) mapCoorData) (lengthChange env spirit_l mapCoorData) (lengthChange env spirit_w mapCoorData) ]
    in
    Canvas.group
        []
        [ render_max_box
        , render_spirit
        , render_label
        ]


{-| For testing
-}
renderStr : EnvC -> String -> Point -> Renderable
renderStr env str pos =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos mapCoorData) str


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
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos mapCoorData) str


renderSingleTuple2 : EnvC -> ( Float, Float ) -> Renderable
renderSingleTuple2 env ( x, y ) =
    let
        str =
            "(" ++ String.fromFloat x ++ ", " ++ String.fromFloat y ++ ")"

        pos =
            ( 1000, 20 )
    in
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos mapCoorData) str
