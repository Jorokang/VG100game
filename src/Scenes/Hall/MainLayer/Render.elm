module Scenes.Hall.MainLayer.Render exposing (..)

import Canvas exposing (Renderable, empty, Point, group, shapes, circle, rect, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (transform, rotate, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Scenes.Hall.MainLayer.Common exposing (EnvC)
import Scenes.Level.Frame.Functions exposing (coorChange)

renderStr : EnvC -> String -> Renderable
renderStr env str =
    text [ font { size = 48, family = "Arial", style = "" }, align Center ] (coorChange env ( 200, 50 )) str