module Scenes.Hall.MainLayer.CardSelect exposing
    ( Card, PileSize
    , clickCard, createPosList, giveHandSize, giveSelectedSize, modifyBool, selectedPile
    )

{-| CardSelect module


# Data types

@docs Card, PileSize


# Functions

@docs clickCard, createPosList, giveHandSize, giveSelectedSize, modifyBool, selectedPile

-}

import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Scenes.Hall.MainLayer.Common exposing (Model, giveErrorCard)
import Scenes.Level.Frame.Functions exposing (addPoint, scalePoint)


type alias Card =
    { name : String
    , id : Int
    , cost : Int
    , img : String
    }


type alias PileSize =
    { name : String
    , startPoint : Point
    , length : Float
    , width : Float
    , interval : Float
    , offset : Float
    }


giveHandSize : PileSize
giveHandSize =
    { name = "hand"
    , startPoint = ( 350, 750 )
    , length = 120
    , width = 80
    , interval = 110
    , offset = 15
    }


giveSelectedSize : PileSize
giveSelectedSize =
    { name = "hand"
    , startPoint = ( 600, 250 )
    , length = 180
    , width = 120
    , interval = 120
    , offset = 15
    }


selectedPile : Model -> List Card
selectedPile model =
    List.map (\x -> Tuple.first (takeCard model.hand x)) model.selected_cards


clicked : Model -> List Point -> ( Bool, Int )
clicked model lp =
    if List.length lp == 0 then
        ( False, 0 )

    else
        let
            point =
                Maybe.withDefault ( -1, -1 ) (List.head lp)
        in
        if judgeMouseRect model.click_pos point ( giveHandSize.width, giveHandSize.length ) then
            ( True, 1 )

        else
            let
                ( bool, nindex ) =
                    clicked model (List.drop 1 lp)
            in
            ( bool, nindex + 1 )


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
            Maybe.withDefault giveErrorCard <|
                List.head <|
                    List.reverse temp

        npile =
            head ++ tail
    in
    ( element, npile )


createPosList : List Card -> PileSize -> List Point
createPosList cards size =
    List.map (createPosListHelper size) <|
        List.range 1 (List.length cards)


createPosListHelper : PileSize -> Int -> Point
createPosListHelper size num =
    addPoint size.startPoint (scalePoint ( size.interval, 0 ) (toFloat num - 1))


searchInt : List Int -> Int -> ( Bool, Int )
searchInt list n =
    if List.length list == 0 then
        ( False, 0 )

    else
        let
            ln =
                Maybe.withDefault -1 (List.head list)
        in
        if ln == n then
            ( True, 1 )

        else
            let
                ( bool, nindex ) =
                    searchInt (List.drop 1 list) n
            in
            ( bool, nindex + 1 )


takeInt : List Int -> Int -> ( Int, List Int )
takeInt pile pos =
    let
        tail =
            List.drop pos pile

        temp =
            List.take pos pile

        head =
            List.take (pos - 1) pile

        element =
            Maybe.withDefault -1 <|
                List.head <|
                    List.reverse temp

        npile =
            head ++ tail
    in
    ( element, npile )


modifyPos : List a -> Int -> a -> List a
modifyPos list pos value =
    if pos <= List.length list && pos > 0 then
        let
            before =
                List.take (pos - 1) list

            after =
                List.drop pos list
        in
        before ++ [ value ] ++ after

    else
        list


modifyBool : List Int -> List Bool -> List Bool
modifyBool indexs bools =
    if List.length indexs == 0 then
        bools

    else
        let
            ( value, nindexs ) =
                takeInt indexs 1
        in
        modifyBool nindexs (modifyPos bools value True)


clickCard : Model -> Model
clickCard model =
    if model.click_status == False then
        model

    else
        let
            ( bool, index ) =
                clicked model (createPosList model.hand giveHandSize)

            card =
                Tuple.first (takeCard model.hand index)

            nmodel =
                { model | click_status = False }

            ( already_selected, nindex ) =
                searchInt model.selected_cards index

            nnmodel =
                if bool then
                    if card.id == -1 then
                        nmodel

                    else if already_selected then
                        { nmodel | selected_cards = Tuple.second (takeInt model.selected_cards nindex) }

                    else if List.length model.selected_cards == 5 then
                        nmodel

                    else
                        { nmodel | selected_cards = model.selected_cards ++ [ index ] }

                else
                    nmodel
        in
        if List.length nnmodel.selected_cards < 5 then
            { nnmodel | hint = True }

        else
            { nnmodel | hint = False }
