module Scenes.Level.Frame.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, group, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Frame.Common exposing (ClearAnimation, EnvC, FrameStatus(..), Model, NextRoundButton)
import Scenes.Level.Frame.Functions exposing (cellLength, coorChange, coorChangeS, lengthChange, mapCoorData, nextRoundBCoorData, nullCoorData, scalePoint, sizeChange, sizeChangeS)


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
            , text [ font { size = round (20 * btn.scale), family = "Arial", style = "" }, align Center ] (coorChange env btn.pos nullCoorData) "Next\nTurn"
            ]
    in
    Canvas.group
        []
        rend
