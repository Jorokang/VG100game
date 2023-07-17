module Scenes.Level.Grids.Render exposing (..)

import Canvas exposing (Point, Renderable, arc, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter, rotate, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, mapCoorData, mapCoorData)
import Scenes.Level.Grids.Common exposing (Cell, EnvC, Model, Plot, PlotEffect(..))
import Time exposing (ZoneName(..))
import Scenes.Level.Frame.Functions exposing (nullCoorData)


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
            lengthChange env (cellLength - 2 * offset) mapCoorData

        rend_base =
            shapes
                [ fill color ]
                [ rect (coorChange env (addPoint pos ( offset, offset )) mapCoorData) rl rl ]
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
            lengthChange env (cellLength - 4 * offset) mapCoorData

        r_pos =
            coorChange env (addPoint pos ( 2 * offset, 2 * offset )) mapCoorData
    in
    if x.val.protection > 0 then
        shapes
            [ fill color
            , filter "opacity(35%)"
            ]
            [ rect r_pos rl rl ]

    else
        empty

{-|
render the background of level
-}
renderLevelBackground : EnvC -> Renderable
renderLevelBackground env =
    let
        background_1 = shapes
                [ fill (Color.rgb255 255 240 200 ) ]
                [ rect (coorChange env (0,0) nullCoorData) (lengthChange env 1920 nullCoorData) (lengthChange env 1080 nullCoorData) 
                ]
        background_2 = shapes
                [ fill (Color.rgb255 20 30 40 ) ]
                [ rect (coorChange env (100,50) nullCoorData) (lengthChange env 720 nullCoorData) (lengthChange env 600 nullCoorData) 
                ]
    in
    Canvas.group
    []
    [ background_1
    , background_2
    ]

{-| For testing
-}
renderStr : EnvC -> String -> Point -> Renderable
renderStr env str pos =
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos mapCoorData) str


renderSingleTuple : EnvC -> Point -> Renderable
renderSingleTuple env x =
    let
        ( locx, locy ) =
            x

        str =
            "last click in Grids : (" ++ String.fromFloat locx ++ ", " ++ String.fromFloat locy ++ ") : "
    in
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env ( 800, 200 ) mapCoorData) str
