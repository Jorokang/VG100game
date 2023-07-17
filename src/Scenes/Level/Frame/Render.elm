module Scenes.Level.Frame.Render exposing (..)

import Canvas exposing (Point, Renderable, group, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Canvas.Settings.Advanced exposing (transform, rotate, translate)
import Color exposing (Color)
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model, NextRoundButton)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData, sizeChange, scalePoint, nextRoundBCoorData)
import Lib.Render.Sprite exposing (renderSprite)


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
        (k1, k2) = coorChange env (sizeChange env (scalePoint model.next_round_b.size 0.5) nextRoundBCoorData) nextRoundBCoorData
        rotation_setting_1 =  transform   [ translate k1 k2
                                        , rotate model.next_round_b.b_rotation_1
                                        , translate -k1 -k2]
        rotation_setting_2 =  transform   [ translate k1 k2
                                        , rotate model.next_round_b.b_rotation_2
                                        , translate -k1 -k2]
            
        rend =  [ renderSprite env.globalData [rotation_setting_1] (coorChange env (0,0) nextRoundBCoorData) (sizeChange env model.next_round_b.size nextRoundBCoorData) "next_round_button_1"
                , renderSprite env.globalData [rotation_setting_2] (coorChange env (0,0) nextRoundBCoorData) (sizeChange env model.next_round_b.size nextRoundBCoorData) "next_round_button_2"
                ]
    in
    Canvas.group
    []
    rend