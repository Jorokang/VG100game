module Scenes.Level.Card.CardCreate exposing (..)

--card name and the cost

import Color exposing (Color, black, blue, brown, green, grey, lightGreen, lightGrey, lightRed, orange, purple, red, yellow)


type alias Card =
    { name : String
    , id : Int
    , cost : Int
    , img : Color
    }


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
