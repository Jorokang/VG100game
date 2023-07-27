module Scenes.Hall.MainLayer.CardSelect exposing (..)

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
    , startPoint = ( 250, 750 )
    , length = 120
    , width = 80
    , interval = 100
    , offset = 15
    }


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


clickCard : Model -> Model
clickCard model =
    let
        ( bool, index ) =
            clicked model (createPosList model.hand giveHandSize)

        card =
            Tuple.first (takeCard model.hand index)

        already_selected =
            searchInt model.selected_cards index
    in
    if bool then
        --if already selected then
        -- drop
        --else
        if List.length model.selected_cards == 5 then
            model

        else
            { model | selected_cards = index :: model.selected_cards }

    else
        model
