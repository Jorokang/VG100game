module Scenes.Teaching.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, rect, shapes, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (filter, shadow)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Sprite exposing (renderSprite)
import List exposing (length)
import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, allGrids, cellLength, coorChange, coorChangeS, grid2real, int2Point, lengthChange, lengthChangeS, mapCoorData, nullCoorData, shadowCoorData)
import Scenes.Teaching.MainLayer.Common exposing (EnvC, Model, nullModel, revealCandleTimeSlot)


renderBackgroud : EnvC -> Model -> Renderable
renderBackgroud env model =
    shapes
        [ fill (Color.rgb255 20 30 40) ]
        [ rect (posToReal env.globalData ( 0, 0 )) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]


renderAvatar : EnvC -> Model -> Renderable
renderAvatar env model =
    let
        pos1 =
            addPoint model.pos ( -100, -100 )

        pos2 =
            addPoint pos1 model.anima.a_pos

        pos3 =
            addPoint pos1 model.anima.p_pos

        cl =
            200

        rend1 =
            renderSprite env.globalData [] pos2 ( cl, cl ) "avatar"

        rend2 =
            renderSprite env.globalData [] pos3 ( cl, cl ) "pillow"
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]


renderShadow : EnvC -> Model -> Renderable
renderShadow env model =
    let
        ( bx, by ) =
            ( 100, 50 )

        ( dx, dy ) =
            ( 50, 50 )

        ( sx, sy ) =
            ( 720, 600 )

        lx =
            sx

        ly =
            sy

        ( px, py ) =
            model.pos

        colorb =
            Color.rgb255 20 30 40

        range =
            model.lightRange

        r1 =
            170

        r2 =
            180

        spos =
            ( px - range / 2 * r2, py - range / 2 * r2 )

        rend1 =
            Canvas.group
                []
                --[ shapes [ fill colorb ] [ rect (coorChange env ( bx, by ) shadowCoorData) (lengthChange env (max (px - r1 - bx) 0) shadowCoorData) ly ]
                [ shapes [ fill colorb ] [ rect (posToReal env.globalData ( 0, 0 )) (lengthToReal env.globalData (max (px - range / 2 * r1) 0)) ly ]
                , shapes [ fill colorb ] [ rect (posToReal env.globalData ( 0, 0 )) lx (lengthToReal env.globalData (max (py - range / 2 * r1) 0)) ]
                , shapes [ fill colorb ] [ rect (posToReal env.globalData ( px + range / 2 * r1, 0 )) (lengthToReal env.globalData (max (sx - px - range / 2 * r1) 0)) ly ]
                , shapes [ fill colorb ] [ rect (posToReal env.globalData ( 0, py + range / 2 * r1 )) lx (lengthToReal env.globalData (max (sy - py - range / 2 * r1) 0)) ]
                ]

        rend3 =
            shapes
                [ fill Color.white ]
                [ rect (posToReal env.globalData (addPoint spos ( 10, 10 ))) (lengthToReal env.globalData (range - 0.1) * r2) (lengthToReal env.globalData (range - 0.1) * r2) ]

        rend2 =
            renderSprite env.globalData [] spos ( range * r2, range * r2 ) "light_shade"

        --[ renderSprite env.globalData [] (0,0) (100,100) "light_shade"]
    in
    Canvas.group
        []
        [ rend3
        , rend2
        ]


renderSpirit : EnvC -> Model -> Renderable
renderSpirit env model =
    let
        max_box_color =
            Color.rgb255 25 25 112

        --dark blue
        label_pos =
            ( 500, 18 )

        ( box_x, box_y ) =
            ( 200, 25 )

        ( box_l, box_w ) =
            ( 600, 40 )

        ( spirit_x, spirit_y ) =
            addPoint ( box_x, box_y ) ( 15, 7 )

        ( spirit_max_l, spirit_w ) =
            addPoint ( box_l, box_w ) ( -30, -14 )

        spirit_l =
            spirit_max_l / model.spirit.max_spirit * model.spirit.cur_spirit

        spirit_color =
            Color.rgb255 255 240 245

        --LavenderBlush
        render_label =
            Canvas.group
                [ fill Color.white ]
                [ text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env label_pos nullCoorData) "spirit" ]

        render_max_box =
            shapes
                [ fill max_box_color ]
                [ rect (coorChange env ( box_x, box_y ) nullCoorData) (lengthChange env box_l nullCoorData) (lengthChange env box_w nullCoorData) ]

        render_spirit =
            shapes
                [ fill spirit_color ]
                [ rect (coorChange env ( spirit_x, spirit_y ) nullCoorData) (lengthChange env spirit_l nullCoorData) (lengthChange env spirit_w nullCoorData) ]
    in
    Canvas.group
        []
        [ render_max_box
        , render_spirit
        , render_label
        ]


renderClick : EnvC -> Model -> Renderable
renderClick env model =
    let
        tf =
            modBy 2 (model.time // 200)

        offset =
            if tf == 1 then
                0

            else
                10

        shadow1 =
            { blur = 0.5
            , color = Color.rgb255 100 100 100
            , offset = ( 4, 4 )
            }

        rend1 =
            renderSprite env.globalData [ shadow shadow1 ] (addPoint model.click_pos ( -offset, -offset )) (addPoint ( 20, 20 ) ( offset, offset )) "mouse_0"

        rend2 =
            Canvas.group [ fill (Color.rgb255 200 100 100) ] [ text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData model.click_pos) "CLICK" ]
    in
    Canvas.group
        []
        [ rend1

        --, rend2
        ]


renderTextBoxTool : EnvC -> String -> Int -> Renderable
renderTextBoxTool env str d =
    text [ font { size = 32, family = "Comic Sans MS", style = "" }, align Left ] (posToReal env.globalData ( 900, toFloat ((d - 1) * 32 + 200) )) str


renderTextBox : EnvC -> List String -> Renderable
renderTextBox env str =
    let
        rend_box =
            renderSprite env.globalData [] ( 800, 100 ) ( 750, 250 ) "text_box"

        rend_text =
            List.map2 (renderTextBoxTool env) str (List.range 1 (List.length str))
    in
    Canvas.group
        []
        (rend_box :: rend_text)


renderCandle : EnvC -> Model -> Renderable
renderCandle env model =
    let
        light_name =
            "candle_light_" ++ String.fromInt (modBy 6 (model.time // 100) + 1)

        op =
            "opacity(" ++ String.fromInt (round model.scroll_opacity) ++ "%)"

        rpos =
            ( 1400, 700 )

        rsize =
            ( 170, 240 )

        rend_s =
            renderSprite env.globalData [ filter op ] ( 20, 600 ) ( 1600, 400 ) "scroll"

        rend1 =
            renderSprite env.globalData [ filter op ] rpos rsize "candle_0"

        rend2 =
            renderSprite env.globalData [ filter op ] rpos rsize light_name

        rend3 =
            renderSprite env.globalData [ filter op ] ( 20, 600 ) ( 1600, 400 ) "candle_light_masking"
    in
    Canvas.group
        []
        [ rend_s
        , rend3
        , rend1
        , rend2
        ]



---------------------------------------------------------------------------------------render-status--------------------------------------------------------------------------------------------------------


renderInit : EnvC -> Model -> Renderable
renderInit env model =
    let
        rend_t =
            renderTextBox env [ "This is dream land" ]

        rend =
            [ rend_t
            ]
    in
    Canvas.group
        []
        rend


renderMuttering1 : EnvC -> Model -> Renderable
renderMuttering1 env model =
    let
        rend_t =
            renderTextBox env [ "It is so dark!" ]

        rend =
            [ rend_t
            ]
    in
    Canvas.group
        []
        rend


renderMuttering2 : EnvC -> Model -> Renderable
renderMuttering2 env model =
    let
        rend_t =
            renderTextBox env [ "I must find my parents" ]

        rend =
            [ rend_t
            ]
    in
    Canvas.group
        []
        rend


renderEnemy1 : EnvC -> Model -> Renderable
renderEnemy1 env model =
    let
        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        rend_t =
            renderTextBox env [ "What's that?" ]

        rend =
            [ rend_e
            , rend_t
            ]
    in
    Canvas.group
        []
        rend


renderEnemy2 : EnvC -> Model -> Renderable
renderEnemy2 env model =
    let
        rend_t =
            renderTextBox env [ "!!!" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        pos1 =
            addPoint model.pos ( -50, -50 )

        tf =
            modBy 1000 model.time // 100

        tf1 =
            if tf <= 3 then
                0

            else
                tf - 3

        ox =
            if modBy 2 tf1 == 1 then
                1

            else
                -1

        oy =
            if modBy 3 tf1 == 1 then
                1

            else
                -1

        offset =
            int2Point ( 2 * tf1 * ox, 1 * tf1 * oy )

        pos2 =
            addPoint pos1 offset

        rend_trap =
            renderSprite env.globalData [] pos2 ( 80, 80 ) "trapped_effect"

        rend =
            [ rend_t
            , rend_e
            , rend_trap
            ]
    in
    Canvas.group
        []
        rend


renderHurt : EnvC -> Model -> Renderable
renderHurt env model =
    let
        rend_t =
            renderTextBox env [ "[Click the boy]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        pos1 =
            addPoint model.pos ( -50, -50 )

        tf =
            modBy 1000 model.time // 100

        tf1 =
            if tf <= 3 then
                0

            else
                tf - 3

        ox =
            if modBy 2 tf1 == 1 then
                1

            else
                -1

        oy =
            if modBy 3 tf1 == 1 then
                1

            else
                -1

        offset =
            int2Point ( 2 * tf1 * ox, 1 * tf1 * oy )

        pos2 =
            addPoint pos1 offset

        rend_trap =
            renderSprite env.globalData [] pos2 ( 80, 80 ) "trapped_effect"

        rend_hurt =
            renderSprite env.globalData [] pos2 ( 80, 80 ) "kill"

        tf2 =
            modBy 270 model.time

        tf3 =
            if tf2 <= 90 then
                "70"

            else
                "20"

        rend_blood =
            shapes
                [ fill (Color.rgb255 240 10 10)
                , filter ("opacity(" ++ tf3 ++ "%)")
                ]
                [ rect (posToReal env.globalData ( 0, 0 )) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]

        rend =
            [ rend_t
            , rend_e
            , rend_blood
            , rend_hurt
            , rend_trap
            ]
    in
    Canvas.group
        []
        rend


renderSelectAvatar : EnvC -> Model -> Renderable
renderSelectAvatar env model =
    let
        rend_t =
            renderTextBox env [ "[Move!]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        pos1 =
            addPoint model.pos ( -50, -50 )

        tf =
            modBy 1000 model.time // 100

        tf1 =
            if tf <= 3 then
                0

            else
                tf - 3

        ox =
            if modBy 2 tf1 == 1 then
                1

            else
                -1

        oy =
            if modBy 3 tf1 == 1 then
                1

            else
                -1

        offset =
            int2Point ( 2 * tf1 * ox, 1 * tf1 * oy )

        pos2 =
            addPoint pos1 offset

        rend_trap =
            renderSprite env.globalData [] pos2 ( 80, 80 ) "trapped_effect"

        rend_hurt =
            renderSprite env.globalData [] pos2 ( 80, 80 ) "kill"

        tf2 =
            modBy 270 model.time

        tf3 =
            if tf2 <= 90 then
                "70"

            else
                "20"

        rend_blood =
            shapes
                [ fill (Color.rgb255 240 10 10)
                , filter ("opacity(" ++ tf3 ++ "%)")
                ]
                [ rect (posToReal env.globalData ( 0, 0 )) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]

        rend_hint =
            shapes
                [ fill (Color.rgb255 152 251 152)
                , filter "opacity(70%)"
                ]
                [ rect (posToReal env.globalData (addPoint pos1 ( 100, 0 ))) (lengthToReal env.globalData 100) (lengthToReal env.globalData 100) ]

        rend =
            [ rend_t
            , rend_e
            , rend_blood
            , rend_hurt
            , rend_trap
            , rend_hint
            ]
    in
    Canvas.group
        []
        rend


renderMoveAvatar : EnvC -> Model -> Renderable
renderMoveAvatar env model =
    let
        rend_t =
            renderTextBox env [ "[Move!]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        rend =
            [ rend_t
            , rend_e
            ]
    in
    Canvas.group
        []
        rend


renderMuttering3 : EnvC -> Model -> Renderable
renderMuttering3 env model =
    let
        rend_t =
            renderTextBox env [ "[You escape from it]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        rend =
            [ rend_t
            , rend_e
            ]
    in
    Canvas.group
        []
        rend


renderRevealScroll : EnvC -> Model -> Renderable
renderRevealScroll env model =
    let
        rend_t =
            renderTextBox env [ "[Use your cards]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        rend_s =
            renderCandle env model

        op =
            "opacity(" ++ String.fromInt (round model.scroll_opacity) ++ "%)"

        rend_c =
            renderSprite env.globalData [ filter op ] ( 140, 680 ) ( 160, 200 ) "card9"

        rend =
            [ rend_t
            , rend_e
            , rend_s
            , rend_c
            ]
    in
    Canvas.group
        []
        rend


renderCard1 : EnvC -> Model -> Renderable
renderCard1 env model =
    let
        rend_t =
            renderTextBox env [ "[Click the card!]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        rend_s =
            renderCandle env model

        rend_c =
            renderSprite env.globalData [] ( 140, 680 ) ( 160, 200 ) "card9"

        rend =
            [ rend_t
            , rend_e
            , rend_s
            , rend_c
            ]
    in
    Canvas.group
        []
        rend


renderCard2 : EnvC -> Model -> Renderable
renderCard2 env model =
    let
        rend_t =
            renderTextBox env [ "[Click!!]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        rend_s =
            renderCandle env model

        rend_c =
            renderSprite env.globalData [] ( 140, 680 ) ( 160, 200 ) "card9"

        pos1 =
            addPoint model.pos ( -50, -50 )

        rend_hint =
            shapes
                [ fill (Color.rgb255 152 251 152)
                , filter "opacity(70%)"
                ]
                [ rect (posToReal env.globalData (addPoint pos1 ( -100, 0 ))) (lengthToReal env.globalData 100) (lengthToReal env.globalData 100) ]

        rend =
            [ rend_t
            , rend_e
            , rend_s
            , rend_c
            , rend_hint
            ]
    in
    Canvas.group
        []
        rend


renderEnd : EnvC -> Model -> Renderable
renderEnd env model =
    let
        rend_t =
            renderTextBox env [ "[Now start your story]" ]

        rend_e =
            renderSprite env.globalData [] ( 0, 300 ) ( 490, 400 ) "e_3"

        ( px, py ) =
            model.pos

        pos1 =
            ( 0, py - 50 )

        tf =
            modBy 1000 model.time // 100

        tf1 =
            if tf <= 3 then
                0

            else
                tf - 3

        oy =
            if modBy 2 tf1 == 1 then
                1

            else
                -1

        offset =
            int2Point ( 0, 2 * tf1 * oy )

        pos2 =
            addPoint pos1 offset

        rend_laser =
            renderSprite env.globalData [ filter "blur(4px)", filter "opacity(60%)" ] pos2 ( px - 50, 80 ) "laser"

        rend =
            [ rend_t
            , rend_e
            , rend_laser
            ]
    in
    Canvas.group
        []
        rend
