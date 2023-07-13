module Scenes.Level.Grids.Render exposing (..)

import Canvas exposing (Point, Renderable, arc, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter, rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, nullCoorData)
import Scenes.Level.Grids.Common exposing (Cell, EnvC, Model, Plot, PlotEffect(..))
import Time exposing (ZoneName(..))


{-| render the whole grid
-}
renderGrids : EnvC -> Model -> Renderable
renderGrids env model =
    let
        rend =
            List.map (renderPlot env) model.grids
    in
    Canvas.group
        []
        rend


{-| render a single plot
-}
renderPlot : EnvC -> Cell Plot -> Renderable
renderPlot env x =
    let
        pos =
            grid2real x.loc

        plot =
            x.val

        color =
            case plot.effect of
                Empty ->
                    Color.gray

                Angry ->
                    Color.darkRed

                Lazy ->
                    Color.darkGray

        offset =
            3

        rl =
            lengthChange env (cellLength - 2 * offset) nullCoorData

        rend_base =
            shapes
                [ fill color ]
                [ rect (coorChange env (addPoint pos ( offset, offset )) nullCoorData) rl rl ]
    in
    Canvas.group
        []
        [ rend_base
        , renderPlotGuard env x
        ]


{-| render the guard effect for a single plot if it has
-}
renderPlotGuard : EnvC -> Cell Plot -> Renderable
renderPlotGuard env x =
    let
        pos =
            grid2real x.loc

        color =
            Color.rgb255 255 227 132

        offset =
            3

        rl =
            lengthChange env (cellLength - 4 * offset) nullCoorData

        r_pos =
            coorChange env (addPoint pos ( 2 * offset, 2 * offset )) nullCoorData
    in
    if x.val.protection > 0 then
        shapes
            [ fill color
            , filter "opacity(35%)"
            ]
            [ rect r_pos rl rl ]

    else
        empty


{-| For testing
-}
renderStr : EnvC -> String -> Point -> Renderable
renderStr env str pos =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos nullCoorData) str


{-| For testing
-}
renderProtection : EnvC -> Model -> Renderable
renderProtection env model =
    let
        rend =
            List.map2 (renderSingleTuple env) model.grids (List.range 1 100)
    in
    Canvas.group
        []
        rend


renderSingleTuple : EnvC -> Cell Plot -> Int -> Renderable
renderSingleTuple env x d =
    let
        ( locx, locy ) =
            x.loc

        str =
            "(" ++ String.fromInt locx ++ ", " ++ String.fromInt locy ++ ") : " ++ String.fromInt x.val.protection

        pos =
            ( 1000, toFloat (d * 40) )
    in
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos nullCoorData) str
