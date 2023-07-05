module Scenes.Level.Frame.CardUnique exposing (..)

import Scenes.Level.Frame.CardSystem exposing (Card, CardData)
import Scenes.Level.Frame.Common exposing (Model)



{-
   W.I.P.
-}


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
