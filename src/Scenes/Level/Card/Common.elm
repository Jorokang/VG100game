module Scenes.Level.Card.Common exposing
    ( Model, nullModel, EnvC
    , CardStatus(..)
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Random exposing (Seed, initialSeed)
import Scenes.Level.Card.CardCreate exposing (Card, giveCard, giveErrorCard)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type CardStatus
    = Active
    | Stopped
    | Inactive



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
    { hand = [ giveCard 1, giveCard 2, giveErrorCard, giveCard 1 ]
    , discard = []
    , deck = [ giveCard 1, giveCard 2, giveCard 2, giveCard 1, giveCard 1, giveCard 2, giveCard 1, giveCard 2 ]
    , seed = initialSeed 42
    , status = Active
    , point = ( 0, 0 )
    , click_status = False
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
