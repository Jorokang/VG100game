module Scenes.Level.Card.Common exposing (nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Random exposing (Seed, initialSeed)
import Scenes.Level.Card.CardCreate exposing (Card, CardStatus(..), Model, giveErrorCard, initializeDeck)
import Scenes.Level.Card.CardSystem exposing (drawCard, shuffle)
import Scenes.Level.LayerBase exposing (CommonData)


nullModel : Model
nullModel =
    let
        model =
            { hand = []
            , discard = []
            , deck = []
            , seed = initialSeed 42
            , status = Active
            , point = ( 0, 0 )
            , turn_status = 5
            , spirit = 30
            , click_status = False
            , selected_pos = -1
            , selected_card = giveErrorCard
            , available = [ 1, 2, 3, 4, 5 ]
            }
    in
    drawCard (shuffle { model | deck = initializeDeck model.available }) 5


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
