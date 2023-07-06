module Scenes.Level.Frame.Render exposing (..)

import Canvas exposing (Point, Renderable, group, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData)


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
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 300, 600 ) nullCoorData) str


renderStamina : EnvC -> Model -> Renderable
renderStamina env model =
    let
        str =
            String.fromInt model.player_data.cur_stamina ++ "/" ++ String.fromInt model.player_data.max_stamina
    in
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 10, 600 ) nullCoorData) str
