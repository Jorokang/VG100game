module Scenes.Level.Card.CardSystem exposing (..)

import Random exposing (Generator, Seed)


type alias Card =
    { name : String
    , id : Int
    , cost : Int
    }


type alias Model =
    { hand : List Card
    , discard : List Card
    , deck : List Card
    , seed : Seed
    }


giveErrorCard : Card
giveErrorCard =
    { name = "error", id = -1, cost = -1 }


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


takeCard : List Card -> Int -> ( Card, List Card )
takeCard pile pos =
    let
        len =
            List.length pile

        tail =
            List.reverse <|
                List.take (len - pos) <|
                    List.reverse pile

        temp =
            List.take pos pile

        head =
            List.take (pos - 1) pile

        element =
            Maybe.withDefault giveErrorCard <|
                List.head <|
                    List.reverse temp

        npile =
            head ++ tail
    in
    ( element, npile )
