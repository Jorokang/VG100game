module Scenes.Level.Frame.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Level.Frame.CardSystem exposing (CardData, nullCardData)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { cardData : CardData
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { cardData = nullCardData
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
