module Scenes.Hall.MainLayer.Render exposing (..)

import Canvas exposing (Renderable, empty, Point, group, shapes, circle, rect, text, empty)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (transform, rotate, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Scenes.Hall.MainLayer.Common exposing (EnvC, Button, ButtonStatus(..), Model)
import Scenes.Level.Frame.Functions exposing (coorChange, lengthChange, addPoint)
import List
import Tuple
import Scenes.Level.Grids.Common exposing (GridsStatus(..))

renderStr : EnvC -> Point -> String -> Renderable
renderStr env pos str =
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env pos) str

renderButtons : EnvC -> Model -> Renderable
renderButtons env model =
    let
        rend =  [   renderButtonPureColor env model.btn_1 Color.gray
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
            addPoint ( sx/2, sy/2 ) btn.pos
        text_ = case btn.status of
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
            [
                shapes [ fill color ] [ rect (coorChange env btn.pos) (lengthChange env sx) (lengthChange env sy) ]
            ,   text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env text_pos) text_
            ]

renderTime : EnvC -> Model -> Renderable
renderTime env model =
    renderStr env (200,500) ( "Hall Time: " ++ String.fromInt model.time )