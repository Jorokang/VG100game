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
                    "Player's turn"

                FrameEnemyTurn ->
                    "Enemy's turn"

                FrameStopped ->
                    "Stopped"

                FrameInactive ->
                    "Inactive"
    in
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 500, 500 ) nullCoorData) str
