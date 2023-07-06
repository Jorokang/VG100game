module Scenes.Level.Card.Render exposing (..)

import Canvas exposing (Renderable, rect, shapes)
import Canvas.Settings exposing (fill)
import Color
import Scenes.Level.Card.CardSystem exposing (takeCard)
import Scenes.Level.Card.Common exposing (Card, EnvC, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, nullCoorData, scalePoint)
import Scenes.Level.Grids.Common exposing (Cell, Plot, PlotEffect(..))
import Tuple exposing (first)


renderHandCards : EnvC -> Model -> Renderable
renderHandCards env model =
    let
        length =
            List.length model.hand

        index =
            1
    in
    renderHelper env model index length


renderHelper : EnvC -> Model -> Int -> Int -> Renderable
renderHelper env model index length =
    let
        element =
            renderCard env (first (takeCard model.hand index)) index
    in
    if index < length then
        Canvas.group
            []
            [ element, renderHelper env model (index + 1) length ]

    else
        Canvas.group
            []
            [ element ]


renderCard : EnvC -> Card -> Int -> Renderable
renderCard env card num =
    let
        color =
            case card.id of
                1 ->
                    Color.black

                2 ->
                    Color.yellow

                _ ->
                    Color.red

        interval =
            100
    in
    shapes
        [ fill color ]
        [ rect (coorChange env (addPoint ( 0, 600 ) (scalePoint ( interval, 0 ) (toFloat num - 1))) nullCoorData) (lengthChange env 80 nullCoorData) (lengthChange env 120 nullCoorData) ]
