module Scenes.Hall.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import List
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), EnvC, Model, nullModel)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, lengthChange, nullCoorData)
import Scenes.Level.Grids.Common exposing (GridsStatus(..))
import Tuple


renderStr : EnvC -> Point -> String -> Renderable
renderStr env pos str =
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env pos nullCoorData) str


renderButtons : EnvC -> Model -> Renderable
renderButtons env model =
    let
        rend =
            [ renderButtonPureColor env model.btn_1 Color.gray
            ]
    in
    Canvas.group
        []
        rend


renderButtonPureColor : EnvC -> Button -> Color -> Renderable
renderButtonPureColor env btn color =
    let
        ( sx, sy ) =
            btn.size

        text_pos =
            addPoint ( sx / 2, sy / 2 ) btn.pos

        text_ =
            case btn.status of
                ButtonActive ->
                    btn.text

                _ ->
                    "pressed"
    in
    case btn.status of
        ButtonInactive ->
            Canvas.empty

        _ ->
            Canvas.group
                []
                [ shapes [ fill color ] [ rect (coorChange env btn.pos nullCoorData) (lengthChange env sx nullCoorData) (lengthChange env sy nullCoorData) ]
                , text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env text_pos nullCoorData) text_
                ]


renderTime : EnvC -> Model -> Renderable
renderTime env model =
    renderStr env (coorChange env ( 200, 500 ) nullCoorData) ("Hall Time: " ++ String.fromInt model.time)
