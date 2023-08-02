module Scenes.Level.Card.CardSystem exposing (drawCard, dropCardByCard, shuffle, takeCard)

{-| Basic functions of operating cards


# Functions

@docs drawCard, dropCardByCard, shuffle, takeCard

-}

import Random exposing (Generator, Seed)
import Scenes.Level.Card.CardCreate exposing (Card, Model, giveErrorCard_2)


{-| Shuffle the give pile
-}
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


{-| Shuffle the deck automatically
-}
shuffle : Model -> Model
shuffle model =
    let
        ( ndeck, nseed ) =
            shufflePile (model.discard ++ model.deck) model.seed
    in
    { model | deck = ndeck, seed = nseed, discard = [] }


{-| Draw a amount of cards
-}
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
            { nmodel | deck = ndeck, hand = sortPile nhand }
    in
    if amount == 1 then
        nnmodel

    else
        drawCard nnmodel (amount - 1)


{-| Sort the given pile
-}
sortPile : List Card -> List Card
sortPile pile =
    List.sortBy .id pile


{-| Drop the given position card
-}
dropCard : Model -> Int -> Model
dropCard model pos =
    let
        ( dcard, nhand ) =
            takeCard model.hand pos
    in
    { model | discard = dcard :: model.discard, hand = nhand }


{-| Drop the given card
-}
dropCardByCard : Model -> Card -> Model
dropCardByCard model card =
    let
        ( bool, pos ) =
            searchCard model.hand card
    in
    if bool then
        dropCard model pos

    else
        model


{-| Search for a card
-}
searchCard : List Card -> Card -> ( Bool, Int )
searchCard pile card =
    if List.length pile == 0 then
        ( False, -1 )

    else
        let
            ( head, npile ) =
                takeCard pile 1
        in
        if card.id == head.id then
            ( True, 1 )

        else
            let
                ( bool, pos ) =
                    searchCard npile card
            in
            ( bool, pos + 1 )


{-| Take the index card out of the pile
-}
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
