module Scenes.Level.Grids.Render exposing (..)

import Canvas exposing (Renderable, empty, Point, group, shapes, circle, rect, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (transform, rotate, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Functions exposing (coorChange, lengthChange)
import Scenes.Level.Grids.Common exposing (EnvC, Model, Cell, Grid, Plot, PlotEffect(..))
import Color
import Scenes.Level.Frame.Functions exposing (addPoint, grid2real, cellLength)

{-| render the whole grid -}
renderGrids : EnvC -> Model -> Renderable
renderGrids env model =
    let
        rend = 
            List.map (renderPlot env) model.grids
    in
    Canvas.group
    []
    rend
    
{-| render a single plot -}
renderPlot : EnvC -> Cell Plot -> Renderable
renderPlot env x =
    let
        pos = grid2real x.loc
        plot = x.val
        color = case plot.effect of
                    Empty   ->  Color.gray
                    Angry   ->  Color.darkRed
                    Lazy    ->  Color.darkGray
        offset = 3
    in
    shapes
    [ fill color ]
    [ rect (coorChange env (addPoint pos ( offset, offset ))) (lengthChange env (cellLength-2*offset)) (lengthChange env (cellLength-2*offset)) ]