module Scenes.Level.Card.Common exposing
    ( Model, nullModel, EnvC
    , Card
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Random exposing (Seed, initialSeed)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}



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
    }


nullModel : Model
nullModel =
    { hand = [ giveCard1, giveCard2 ]
    , discard = []
    , deck = [ giveCard1, giveCard2, giveCard1, giveCard2 ]
    , seed = initialSeed 42
    }


giveCard1 : Card
giveCard1 =
    { name = "card1", id = 1, cost = 0 }


giveCard2 : Card
giveCard2 =
    { name = "card2", id = 2, cost = 0 }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
