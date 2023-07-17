module Scenes.Level.Frame.Render exposing (..)

import Canvas exposing (Point, Renderable, group, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Canvas.Settings.Advanced exposing (transform, rotate, translate)
import Color exposing (Color)
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model, NextRoundButton)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData, sizeChange, scalePoint)
import Lib.Render.Sprite exposing (renderSprite)
import Json.Decode exposing (null)
import Scenes.Level.Frame.Functions exposing (addPoint)
import Scenes.Level.Frame.Functions exposing (negPoint)


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

sizeNextRoundButton1 : Point 
sizeNextRoundButton1 =
    (85, 50)

sizeNextRoundButton2 : Point 
sizeNextRoundButton2 =
    (180, 50)

renderNextRoundButton : EnvC -> Model -> Renderable
renderNextRoundButton env model =
    let
        pos1 = scalePoint ( addPoint sizeNextRoundButton2 (negPoint sizeNextRoundButton1)) 0.5
        (k1, k2) = coorChange env (sizeChange env (scalePoint sizeNextRoundButton2 0.5) nullCoorData) nullCoorData
        rotation_setting =  transform   [ translate k1 k2
                                        , rotate model.next_round_button.button_rotation
                                        , translate -k1 -k2]
            
        rend =  [ renderSprite env.globalData [] (coorChange env pos1 nullCoorData) (sizeChange env sizeNextRoundButton1 nullCoorData) "next_round_button_1"
                , renderSprite env.globalData [rotation_setting] (coorChange env (0,0) nullCoorData) (sizeChange env sizeNextRoundButton2 nullCoorData) "next_round_button_2"
                ]
    in
    Canvas.group
    []
    rend