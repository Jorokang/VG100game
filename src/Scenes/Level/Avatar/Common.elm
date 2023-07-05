module Scenes.Level.Avatar.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}



--health and position of the avatar


type alias Model =
    { health : Int
    , pos : Point
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { health = 30
    , pos = ( 0, 0 )
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
