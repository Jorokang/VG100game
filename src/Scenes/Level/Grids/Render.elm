module Scenes.Level.Grids.Render exposing (renderGrids, renderLevelBackground, renderStr, renderTableLights)

{-| Render module


# Functions

@docs renderGrids, renderLevelBackground, renderStr, renderTableLights

-}

import Canvas exposing (Point, Renderable, empty, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color
import Lib.Render.Sprite exposing (renderSprite)
import List
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, coorChangeS, grid2real, lengthChange, mapCoorData, nullCoorData, shadowCoorData, sizeChangeS)
import Scenes.Level.Grids.Common exposing (Cell, EnvC, Model, Plot, PlotEffect(..), SingleAnimation, TableLight)


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

        offset =
            ( 0, 15 )

        offset_anima =
            List.foldl toolFunc1 ( 0, 0 ) plot.anima

        rpos =
            addPoint (addPoint pos offset) offset_anima

        size =
            ( cellLength, cellLength * 1.33 )

        rend_base =
            renderSprite env.globalData [] (coorChangeS env rpos mapCoorData) (sizeChangeS env size mapCoorData) ("grid_block_" ++ String.fromInt plot.sprite_id)
    in
    Canvas.group
        []
        [ rend_base
        , renderPlotGuard env x
        ]


toolFunc1 : SingleAnimation -> Point -> Point
toolFunc1 a b =
    addPoint a.offset b


{-| render the guard effect for a single plot if it has
-}
renderPlotGuard : EnvC -> Cell Plot -> Renderable
renderPlotGuard env x =
    let
        pos =
            grid2real x.loc

        offset =
            6

        rl =
            lengthChange env (cellLength - 4 * offset) mapCoorData

        r_pos =
            coorChange env (addPoint pos ( 2 * offset, 2 * offset )) mapCoorData
    in
    if x.val.protection > 0 then
        renderSprite env.globalData [ filter "opacity(35%)" ] (coorChangeS env r_pos mapCoorData) (sizeChangeS env ( rl, rl ) mapCoorData) "shield"

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
    renderSprite env.globalData [] (coorChangeS env (addPoint (grid2real tl.loc) ( 0 - 1.2 * cellLength, 0 )) mapCoorData) (sizeChangeS env ( cellLength * 4, cellLength * 4 ) mapCoorData) "candle_light_1"


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
                [ rect (coorChange env ( 0, 0 ) nullCoorData) (lengthChange env 2560 shadowCoorData) (lengthChange env 1600 shadowCoorData)
                ]

        background_2 =
            shapes
                [ fill (Color.rgb255 20 30 40) ]
                [ rect (coorChange env ( 0, 0 ) nullCoorData) (lengthChange env 2560 shadowCoorData) (lengthChange env 1600 shadowCoorData)
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
    --text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos mapCoorData) str
    text [ font { size = round (lengthChange env 24 nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env pos nullCoorData) str


renderSingleTuple : EnvC -> Point -> Point -> Renderable
renderSingleTuple env x pos =
    let
        ( locx, locy ) =
            x

        str =
            "(" ++ String.fromFloat locx ++ ", " ++ String.fromFloat locy ++ ")"
    in
    text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env pos mapCoorData) str
