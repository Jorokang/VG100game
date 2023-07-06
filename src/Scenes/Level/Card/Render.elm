module Scenes.Level.Card.Render exposing (..)

import Canvas exposing (Renderable, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color
import Scenes.Level.Card.CardSystem exposing (takeCard)
import Scenes.Level.Card.Common exposing (Card, EnvC, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, cellLength, coorChange, grid2real, lengthChange, nullCoorData, scalePoint)
import Tuple exposing (first)


renderHandCards : EnvC -> Model -> Renderable
renderHandCards env model =
    let
        length =
            List.length model.hand

        index =
            1
    in
    Canvas.group
        []
        [ renderHelper env model index length
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 0, 780 ) nullCoorData) "Hand Cards"
        ]


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
