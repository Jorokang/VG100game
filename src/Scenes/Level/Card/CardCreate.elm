module Scenes.Level.Card.CardCreate exposing (..)

--card name and the cost

import Canvas exposing (Point)
import Color exposing (Color, black, blue, brown, green, grey, lightGreen, lightGrey, lightRed, orange, purple, red, white, yellow)


type alias Card =
    { name : String
    , id : Int
    , cost : Int
    , img : String
    }


type alias CardObject =
    { card : Card
    , pos : Point
    , size : Point
    , selected : Bool
    , img : Color
    }


type alias PileSize =
    { name : String
    , startPoint : Point
    , length : Float
    , width : Float
    , interval : Float
    , offset : Float
    }


giveBackCard : Card
giveBackCard =
    { name = "back", id = 0, cost = 0, img = "cardback" }


giveErrorCard : Card
giveErrorCard =
    { name = "error", id = -1, cost = -1, img = "cardback" }


giveErrorCard_2 : Card
giveErrorCard_2 =
    { name = "error_take", id = -2, cost = -1, img = "cardback" }


giveCardList : List Card
giveCardList =
    [ { name = "purify", id = 1, cost = 2, img = "card1" }
    , { name = "guard", id = 2, cost = 2, img = "card2" }
    , { name = "take a break", id = 3, cost = 0, img = "card3" }
    , { name = "light up", id = 4, cost = 1, img = "card4" }
    , { name = "hope", id = 5, cost = 3, img = "card5" }
    , { name = "call up the past", id = 6, cost = 2, img = "cardback" }
    , { name = "courage", id = 8, cost = 4, img = "card8" }
    , { name = "endless hope", id = 7, cost = 5, img = "card7" }
    , { name = "sunrise", id = 9, cost = 6, img = "card9" }
    , { name = "thrive", id = 10, cost = 2, img = "card10" }
    , { name = "forget", id = 11, cost = 10, img = "card11" }
    ]


giveCard : Int -> Card
giveCard id =
    if id > 0 then
        Maybe.withDefault giveErrorCard <|
            List.head <|
                List.drop (id - 1) giveCardList

    else
        giveErrorCard


giveHandSize : PileSize
giveHandSize =
    { name = "hand"
    , startPoint = ( 100, 750 )
    , length = 120
    , width = 80
    , interval = 100
    , offset = 15
    }


giveDeckSize : PileSize
giveDeckSize =
    { name = "pile"
    , startPoint = ( 850, 100 )
    , length = 120
    , width = 80
    , interval = 3
    , offset = 15
    }


giveDiscardSize : PileSize
giveDiscardSize =
    { name = "pile"
    , startPoint = ( 850, 300 )
    , length = 120
    , width = 80
    , interval = 3
    , offset = 15
    }


giveBackPile : List Card -> List Card
giveBackPile pile =
    List.map (\x -> giveBackCard) pile


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
