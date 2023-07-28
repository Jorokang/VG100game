module Scenes.Menu.MainLayer.Common exposing (Model, nullModel, EnvC)

{-| Common module


# Basic data

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Menu.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    {
        time: Int
    , e_time : Int
    , active : Bool
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    {
        time = -1
    , e_time = 600
    , active = True
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
