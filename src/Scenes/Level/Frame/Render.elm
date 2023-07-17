module Scenes.Level.Frame.Render exposing (..)

import Canvas exposing (Point, Renderable, group, text, circle, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Canvas.Settings.Advanced exposing (transform, rotate, translate)
import Color exposing (Color)
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model, NextRoundButton)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData, sizeChange, scalePoint, nextRoundBCoorData)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Frame.Functions exposing (lengthChange)


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
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 300, 570 ) nullCoorData) str


renderStamina : EnvC -> Model -> Renderable
renderStamina env model =
    let
        str =
            "Stamina: " ++ String.fromInt model.player_data.cur_stamina ++ "/" ++ String.fromInt model.player_data.max_stamina
    in
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 10, 570 ) nullCoorData) str

{-| function controlling the next_round button
(the position is defined as (0,0), while the real position is according to the settings in Frame/Functions.elm)
-}

renderNextRoundB : EnvC -> Model -> Renderable
renderNextRoundB env model =
    let
        btn = model.next_round_b
        nradius = btn.radius * btn.scale
        rend =  [ shapes [fill Color.yellow] [circle (coorChange env btn.pos nextRoundBCoorData) (lengthChange env nradius nextRoundBCoorData)] ]
    in
    Canvas.group
    []
    rend