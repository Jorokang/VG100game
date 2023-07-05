module Scenes.Hall.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import List
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), EnvC, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, lengthChange)
import Scenes.Level.Grids.Common exposing (GridsStatus(..))
import Tuple


renderStr : EnvC -> String -> Renderable
renderStr env str =
    text [ font { size = 48, family = "Arial", style = "" }, align Center ] (coorChange env ( 200, 50 )) str


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
    in
    case btn.status of
        ButtonInactive ->
            Canvas.empty

        _ ->
            Canvas.group
                []
                [ shapes [ fill color ] [ rect (coorChange env btn.pos) (lengthChange env sx) (lengthChange env sy) ]
                , text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env text_pos) btn.text
                ]
