module Scenes.Level.Card.CardSystem exposing (..)

import Canvas exposing (Point)
import Random exposing (Generator, Seed)
import Scenes.Level.Card.Common exposing (Card, Model, giveErrorCard_2)


shufflePile : List Card -> Seed -> ( List Card, Seed )
shufflePile pile seed =
    if List.length pile < 2 then
        ( pile, seed )

    else
        let
            len =
                List.length pile

            ( pos, nseed ) =
                Random.step (Random.int 1 len) seed

            ( element, npile ) =
                takeCard pile pos

            ( nnpile, nnseed ) =
                shufflePile npile nseed
        in
        ( element :: nnpile, nnseed )


shuffle : Model -> Model
shuffle model =
    let
        ( ndeck, nseed ) =
            shufflePile model.discard model.seed
    in
    { model | deck = ndeck, seed = nseed, discard = [] }


drawCard : Model -> Int -> Model
drawCard model amount =
    let
        nmodel =
            if List.length model.deck == 0 then
                shuffle model

            else
                model

        ( ncard, ndeck ) =
            takeCard nmodel.deck 1

        nhand =
            ncard :: nmodel.hand

        nnmodel =
            { nmodel | deck = ndeck, hand = nhand }
    in
    if amount == 1 then
        nnmodel

    else
        drawCard nnmodel (amount - 1)


sortPile : List Card -> List Card
sortPile pile =
    List.sortBy .id pile


dropCard : Model -> Int -> Model
dropCard model pos =
    let
        ( dcard, nhand ) =
            takeCard model.deck pos
    in
    { model | discard = dcard :: model.discard, hand = nhand }


takeCard : List Card -> Int -> ( Card, List Card )
takeCard pile pos =
    let
        tail =
            List.drop pos pile

        temp =
            List.take pos pile

        head =
            List.take (pos - 1) pile

        element =
            Maybe.withDefault giveErrorCard_2 <|
                List.head <|
                    List.reverse temp

        npile =
            head ++ tail
    in
    ( element, npile )


takePoint : List Point -> Int -> ( Point, List Point )
takePoint pile pos =
    let
        tail =
            List.drop pos pile

        temp =
            List.take pos pile

        head =
            List.take (pos - 1) pile

        element =
            Maybe.withDefault ( -1, -1 ) <|
                List.head <|
                    List.reverse temp

        npile =
            head ++ tail
    in
    ( element, npile )
