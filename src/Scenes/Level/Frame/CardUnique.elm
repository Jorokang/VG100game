module Scenes.Level.Frame.CardUnique exposing (..)

import Scenes.Level.Frame.CardSystem exposing (Card, dropCard, takeCard)
import Scenes.Level.Frame.Common exposing (Model)
import Tuple exposing (first)


playCard : Model -> Int -> Model
playCard model pos =
    let
        card =
            first (takeCard model.cardData.hand pos)

        ncards =
            dropCard model.cardData pos
    in
    cardToEffect { model | cardData = ncards } card


cardToEffect : Model -> Card -> Model
cardToEffect model card =
    case card.id of
        1 ->
            card1 model

        2 ->
            card2 model

        _ ->
            model



{-
   W.I.P.
-}


card1 : Model -> Model
card1 model =
    model


card2 : Model -> Model
card2 model =
    model
