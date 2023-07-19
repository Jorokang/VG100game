module Scenes.Level.Card.CardCreate exposing (..)

--card name and the cost

import Canvas exposing (Point)
import Color exposing (Color, black, blue, brown, green, grey, lightGreen, lightGrey, lightRed, orange, purple, red, white, yellow)


type alias Card =
    { name : String
    , id : Int
    , cost : Int
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
    { name = "back", id = 0, cost = 0, img = white }


giveErrorCard : Card
giveErrorCard =
    { name = "error", id = -1, cost = -1, img = red }


giveErrorCard_2 : Card
giveErrorCard_2 =
    { name = "error_take", id = -2, cost = -1, img = red }


giveCardList : List Card
giveCardList =
    [ { name = "purification", id = 1, cost = 2, img = grey }
    , { name = "guard", id = 2, cost = 2, img = brown }
    , { name = "take a break", id = 3, cost = 0, img = green }
    , { name = "the light of bravery", id = 4, cost = 1, img = yellow }
    , { name = "light up the hope", id = 5, cost = 3, img = blue }
    , { name = "call up the past", id = 6, cost = 2, img = purple }
    , { name = "endless hope", id = 7, cost = 5, img = black }
    , { name = "power of courage", id = 8, cost = 4, img = orange }
    , { name = "take a table light", id = 9, cost = 6, img = lightGreen }
    , { name = "fire up the spirit", id = 10, cost = 2, img = lightRed }
    , { name = "forgetting", id = 11, cost = 10, img = lightGrey }
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
    , startPoint = ( 25, 725 )
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
