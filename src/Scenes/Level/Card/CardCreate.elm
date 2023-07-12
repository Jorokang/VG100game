module Scenes.Level.Card.CardCreate exposing (..)

--card name and the cost


type alias Card =
    { name : String
    , id : Int
    , cost : Int
    }


giveErrorCard : Card
giveErrorCard =
    { name = "error", id = -1, cost = -1 }


giveErrorCard_2 : Card
giveErrorCard_2 =
    { name = "error_take", id = -2, cost = -1 }


giveCardList : List Card
giveCardList =
    [ { name = "purification", id = 1, cost = 2 }
    , { name = "guard", id = 2, cost = 2 }
    , { name = "take a break", id = 3, cost = 0 }
    , { name = "the light of bravery", id = 4, cost = 1 }
    , { name = "light up the hope", id = 5, cost = 3 }
    , { name = "call up the past", id = 6, cost = 2 }
    , { name = "endless hope", id = 7, cost = 5 }
    , { name = "power of courage", id = 8, cost = 4 }
    , { name = "take a table light", id = 9, cost = 6 }
    , { name = "fire up the spirit", id = 10, cost = 2 }
    , { name = "forgetting", id = 11, cost = 10 }
    ]


giveCard : Int -> Card
giveCard id =
    if id > 0 then
        Maybe.withDefault giveErrorCard <|
            List.head <|
                List.drop (id - 1) giveCardList

    else
        giveErrorCard
