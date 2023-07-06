module Scenes.Level.Card.CardUnique exposing (..)

import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Card.CardSystem exposing (dropCard, takeCard)
import Scenes.Level.Card.Common exposing (Card, Model)
import Tuple exposing (first)


playCard : Model -> Int -> ( Model, List ( LayerTarget, LayerMsg ) )
playCard model pos =
    let
        card =
            first (takeCard model.hand pos)

        ncards =
            dropCard model pos
    in
    cardToEffect ncards card


cardToEffect : Model -> Card -> ( Model, List ( LayerTarget, LayerMsg ) )
cardToEffect model card =
    case card.id of
        1 ->
            card1 model

        2 ->
            card2 model

        _ ->
            ( model, [] )



{-
   W.I.P.
-}


card1 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card1 model =
    ( model, [ ( LayerName "Grids", LayerIntMsg 1 ) ] )


card2 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card2 model =
    ( model, [] )
