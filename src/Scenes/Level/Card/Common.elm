module Scenes.Level.Card.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}



--card name and the cost


type Card
    = CardName1 Int
    | N2 Int
    | N3 Int



--take card from deck to hand, remove it to discard


type alias Model =
    { hand : List Card
    , discard : List Card
    , deck : List Card
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { hand = [ CardName1 1 ]
    , discard = []
    , deck = [ N2 2, N3 4 ]
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
