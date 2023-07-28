module Scenes.Level.Frame.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, group, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Frame.Common exposing (ClearAnimation, EnvC, FrameStatus(..), Model, NextRoundButton, SpiritAnimation)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, coorChangeS, lengthChange, mapCoorData, nextRoundBCoorData, nullCoorData, scalePoint, sizeChange, sizeChangeS)


renderClearAnimation : EnvC -> Int -> ClearAnimation -> Renderable
renderClearAnimation env time anima =
    let
        id_state =
            (time - anima.i_time) // 50
    in
    renderSprite env.globalData [] (coorChangeS env anima.pos mapCoorData) (sizeChangeS env ( cellLength, cellLength ) mapCoorData) ("clear_anima_" ++ String.fromInt id_state)


renderClearAnimations : EnvC -> Model -> Renderable
renderClearAnimations env model =
    let
        rend =
            List.map (renderClearAnimation env model.time) model.c_anima
    in
    Canvas.group
        []
        rend


renderSpiritAnimation : EnvC -> Int -> SpiritAnimation -> Renderable
renderSpiritAnimation env time anima =
    let
        offset =
            ( 0, 0 - toFloat ((time - anima.i_time) // 15) )

        pos =
            addPoint ( 800, 50 ) offset

        opacity =
            round ((toFloat (time - anima.i_time) / toFloat (anima.e_time - anima.i_time)) * 100)

        str_o =
            "opacity(" ++ String.fromInt opacity ++ "%)"
    in
    Canvas.group
        [ filter str_o
        , fill Color.white
        ]
        --[ text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env pos nullCoorData) anima.str ]
        [ text [ font { size = round (lengthChange env 48 nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env pos nullCoorData) anima.str ]


renderSpiritAnimations : EnvC -> Model -> Renderable
renderSpiritAnimations env model =
    let
        rend =
            List.map (renderSpiritAnimation env model.time) model.s_anima
    in
    Canvas.group
        []
        rend


renderScroll : EnvC -> Model -> Renderable
renderScroll env _ =
    renderSprite env.globalData [] (coorChangeS env ( 20, 600 ) nullCoorData) (sizeChangeS env ( 1600, 400 ) nullCoorData) "scroll"


renderCandle : EnvC -> Model -> Renderable
renderCandle env model =
    let
        light_name =
            "candle_light_" ++ String.fromInt (modBy 6 (model.time // 100) + 1)

        op =
            "opacity(" ++ String.fromInt model.op_reg ++ "%)"

        rpos =
            coorChangeS env ( 1400, 700 ) nullCoorData

        rsize =
            sizeChangeS env ( 170, 240 ) nullCoorData

        rend1 =
            renderSprite env.globalData [] rpos rsize "candle_0"

        rend2 =
            renderSprite env.globalData [] rpos rsize light_name

        rend3 =
            renderSprite env.globalData [ filter op ] (coorChangeS env ( 60, 650 ) nullCoorData) (sizeChangeS env ( 1800, 400 ) nullCoorData) "candle_light_masking"

        rend4 =
            renderSprite env.globalData [] (coorChangeS env ( 60, 650 ) nullCoorData) (sizeChangeS env ( 1800, 400 ) nullCoorData) "scroll"
    in
    Canvas.group
        []
        [ rend4
        , rend4
        , rend3
        , rend1
        , rend2
        ]


renderFrameStatus : EnvC -> Model -> Renderable
renderFrameStatus env model =
    let
        str =
            case model.status of
                FramePlayerTurn ->
                    "Player's turn (Press Enter to switch turn)"

                FrameEnemyTurn ->
                    "Enemy's turn (Press Enter to switch turn)"

                FrameStopped ->
                    "Stopped"

                FrameInactive ->
                    "Inactive"
    in
    Canvas.group
        [ fill Color.white ]
        [ text [ font { size = 32, family = "Arial", style = "" }, align Left ] (coorChange env ( 150, 550 ) nullCoorData) str ]


renderStamina : EnvC -> Model -> Renderable
renderStamina env model =
    let
        str =
            "Stamina: " ++ String.fromInt model.player_data.cur_stamina ++ "/" ++ String.fromInt (model.player_data.max_stamina + model.player_data.add_stamina)
    in
    Canvas.group
        [ fill Color.white ]
        [ text [ font { size = 32, family = "Arial", style = "" }, align Left ] (coorChange env ( 500, 200 ) nullCoorData) str ]


{-| function controlling the next\_round button
(the position is defined as (0,0), while the real position is according to the settings in Frame/Functions.elm)
-}
renderNextRoundB : EnvC -> Model -> Renderable
renderNextRoundB env model =
    let
        btn =
            model.next_round_b

        nradius =
            btn.radius * btn.scale

        rend =
            [ shapes [ fill Color.yellow ] [ circle (coorChange env btn.pos nextRoundBCoorData) (lengthChange env nradius nextRoundBCoorData) ]

            --, text [ font { size = round (20 * btn.scale), family = "Arial", style = "" }, align Center ] (coorChange env btn.pos nullCoorData) "Next\nTurn"
            , text [ font { size = round (lengthChange env (20 * btn.scale) nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env (addPoint btn.pos ( 0 - 50 * btn.scale, 0 )) nullCoorData) "Next\nTurn"
            ]
    in
    Canvas.group
        []
        rend
