module Scenes.Level.Frame.CardUnique exposing (..)

import Scenes.Level.Frame.CardSystem exposing (Card, dropCard, takeCard)
import Scenes.Level.Frame.Common exposing (Model)
import Tuple exposing (first)



{-
   W.I.P.
-}


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

        _ ->
            model


card1 : Model -> Model
card1 model =
    model
