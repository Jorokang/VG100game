module Scenes.Level.Card.Render exposing (..)

import Canvas exposing (Point, Renderable, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Scenes.Level.Card.CardCreate exposing (Card, giveErrorCard)
import Scenes.Level.Card.CardSystem exposing (takeCard)
import Scenes.Level.Card.Common exposing (EnvC, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, lengthChange, nullCoorData, scalePoint)
import Tuple exposing (first)


renderStr : EnvC -> Point -> String -> Renderable
renderStr env pos str =
    text [ font { size = 24, family = "Arial", style = "" }, align Left ] (coorChange env pos nullCoorData) str


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


renderTestMessage : EnvC -> Model -> Renderable
renderTestMessage env model =
    Canvas.group
        []
        [ renderStr env (coorChange env ( 200, 500 ) nullCoorData) ("click" ++ String.fromFloat (Tuple.first model.point) ++ ", " ++ String.fromFloat (Tuple.second model.point))
        , renderStr env (coorChange env ( 200, 750 ) nullCoorData) ("hands:" ++ String.fromInt (List.length model.hand) ++ pileToString model.hand)
        , renderStr env (coorChange env ( 200, 775 ) nullCoorData) ("decks:" ++ String.fromInt (List.length model.deck) ++ pileToString model.deck)
        , renderStr env (coorChange env ( 200, 800 ) nullCoorData) ("piles:" ++ String.fromInt (List.length model.discard) ++ pileToString model.discard)
        , renderStr env (coorChange env ( 200, 825 ) nullCoorData) ("spirits:" ++ String.fromInt model.spirit)
        , renderStr env (coorChange env ( 200, 850 ) nullCoorData) ("turn_status:" ++ String.fromInt model.turn_status)
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


pileToString : List Card -> String
pileToString pile =
    if List.length pile == 0 then
        " "

    else
        let
            card =
                Maybe.withDefault giveErrorCard (List.head pile)
        in
        ", " ++ card.name ++ String.fromInt card.cost ++ pileToString (List.drop 1 pile)


renderCard : EnvC -> Card -> Int -> Renderable
renderCard env card num =
    let
        color =
            card.img

        interval =
            100
    in
    shapes
        [ fill color ]
        [ rect (coorChange env (addPoint ( 0, 600 ) (scalePoint ( interval, 0 ) (toFloat num - 1))) nullCoorData) (lengthChange env 80 nullCoorData) (lengthChange env 120 nullCoorData) ]
