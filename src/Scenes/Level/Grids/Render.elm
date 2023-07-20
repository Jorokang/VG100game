module Scenes.Level.Grids.Render exposing (..)

import Canvas exposing (Point, Renderable, empty, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, mapCoorData, nullCoorData, shadowCoorData)
import Scenes.Level.Grids.Common exposing (Cell, EnvC, Model, Plot, PlotEffect(..), TableLight)


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


{-| render table lights effect
-}
renderTableLights : EnvC -> Model -> Renderable
renderTableLights env model =
    let
        rend =
            List.map (renderTableLight env) model.table_lights
    in
    Canvas.group
        []
        rend


{-| render table light effect for a single tl
-}
renderTableLight : EnvC -> TableLight -> Renderable
renderTableLight env tl =
    shapes
        [ fill Color.red ]
        [ rect (coorChange env (grid2real tl.loc) mapCoorData) (lengthChange env cellLength mapCoorData) (lengthChange env cellLength mapCoorData) ]


{-| render single patterns by the given position and id
-}
renderPattern : EnvC -> ( Int, Point ) -> Renderable
renderPattern env ( id, pos ) =
    let
        rl =
            50

        name =
            "pattern_" ++ String.fromInt id
    in
    Canvas.group
        [ fill Color.black ]
        [ renderSprite env.globalData [] pos ( rl, rl ) name ]


patternSet : List ( Int, Point )
patternSet =
    [ {- ( 1, ( 120, 60 ) )
         , ( 2, ( 120, 130 ) )
         , ( 3, ( 120, 200 ) )
         , ( 4, ( 120, 270 ) )
         , ( 5, ( 120, 340 ) )
         , ( 1, ( 120, 440 ) )
         , ( 4, ( 200, 60 ) )
         , ( 5, ( 200, 130 ) )
         , ( 3, ( 200, 200 ) )
         , ( 4, ( 200, 270 ) )
         , ( 5, ( 200, 340 ) )
         , ( 1, ( 200, 440 ) )
         , ( 1, ( 280, 60 ) )
         , ( 2, ( 280, 130 ) )
         , ( 3, ( 280, 200 ) )
         , ( 4, ( 280, 270 ) )
         , ( 5, ( 280, 340 ) )
         , ( 1, ( 280, 440 ) )
         {-, ( 1, ( 360, 60 ) )
         , ( 2, ( 360, 130 ) )
         , ( 3, ( 360, 200 ) )
         , ( 4, ( 360, 270 ) )
         , ( 5, ( 360, 340 ) )
         , ( 1, ( 360, 440 ) )
         , ( 1, ( 440, 60 ) )-}
         ,
      -}
      ( 2, ( 440, 130 ) )
    , ( 3, ( 440, 200 ) )
    , ( 4, ( 440, 270 ) )
    , ( 5, ( 440, 340 ) )
    , ( 1, ( 440, 440 ) )

    {- , ( 1, ( 520, 60 ) )
       , ( 2, ( 520, 130 ) )
       , ( 3, ( 520, 200 ) )
       , ( 4, ( 520, 270 ) )
       , ( 5, ( 520, 340 ) )
       , ( 1, ( 520, 440 ) )
    -}
    ]


{-| render patterns by sprites on the background
-}
renderMultiPattern : EnvC -> Renderable
renderMultiPattern env =
    let
        rend =
            List.map (renderPattern env) patternSet
    in
    Canvas.group
        []
        rend


{-| render the background of level
-}
renderLevelBackground : EnvC -> Renderable
renderLevelBackground env =
    let
        background_1 =
            shapes
                [ fill (Color.rgb255 255 240 200) ]
                [ rect (coorChange env ( 0, 0 ) nullCoorData) (lengthChange env 2536 shadowCoorData) (lengthChange env 1600 shadowCoorData)
                ]

        background_2 =
            shapes
                [ fill (Color.rgb255 20 30 40) ]
                [ rect (coorChange env ( 0, 0 ) nullCoorData) (lengthChange env 1080 shadowCoorData) (lengthChange env 880 shadowCoorData)
                ]
    in
    Canvas.group
        []
        [ background_1
        , background_2
        , renderMultiPattern env
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
