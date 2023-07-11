module Scenes.Level.Card.Common exposing
    ( Model, nullModel, EnvC
    , Card, CardStatus(..), giveErrorCard, giveErrorCard_2
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Random exposing (Seed, initialSeed)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type CardStatus
    = Active
    | Stopped
    | Inactive



--card name and the cost


type alias Card =
    { name : String
    , id : Int
    , cost : Int
    }



--take card from deck to hand, remove it to discard


type alias Model =
    { hand : List Card
    , discard : List Card
    , deck : List Card
    , seed : Seed
    , status : CardStatus
    , point : Point
    , click_status : Bool
    }


nullModel : Model
nullModel =
    { hand = [ giveCard1, giveCard2, giveErrorCard, giveCard1 ]
    , discard = []
    , deck = [ giveCard1, giveCard2, giveCard2, giveCard1, giveCard1, giveCard2, giveCard1, giveCard2 ]
    , seed = initialSeed 42
    , status = Active
    , point = ( 0, 0 )
    , click_status = False
    }


giveCard1 : Card
giveCard1 =
    { name = "card1", id = 1, cost = 0 }


giveCard2 : Card
giveCard2 =
    { name = "card2", id = 2, cost = 0 }


giveErrorCard : Card
giveErrorCard =
    { name = "error", id = -1, cost = -1 }


giveErrorCard_2 : Card
giveErrorCard_2 =
    { name = "error_take", id = -2, cost = -1 }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
