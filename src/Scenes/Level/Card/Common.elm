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
    | Moving
    | Playing
    | Inactive



--take card from deck to hand, remove it to discard


type alias Model =
    { hand : List Card
    , discard : List Card
    , deck : List Card
    , seed : Seed
    , status : CardStatus
    , point : Point
    , turn_status : Int
    , spirit : Int
    , click_status : Bool
    }


nullModel : Model
nullModel =
    { hand = [ giveCard 1, giveCard 2, giveCard 3, giveCard 4, giveCard 5, giveCard 6, giveCard 7, giveCard 8, giveCard 9, giveCard 10, giveCard 11 ]
    , discard = []
    , deck = [ giveCard 1, giveCard 2, giveCard 3, giveCard 4, giveCard 5, giveCard 6, giveCard 7, giveCard 8, giveCard 9, giveCard 10, giveCard 11 ]
    , seed = initialSeed 42
    , status = Active
    , point = ( 0, 0 )
    , turn_status = 5
    , spirit = 30
    , click_status = False
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
