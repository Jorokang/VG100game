module Scenes.Teaching.MainLayer.Common exposing (Model, nullModel, EnvC, AvatarAnima, AvatarSpirit)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Teaching.LayerBase exposing (CommonData)


type TeachingStatus
    = Init

type alias AvatarAnima =
    { a_pos : Point
    , a_v : Float
    , a_a : Float
    , p_pos : Point
    , p_v : Float
    , p_a : Float
    , lim : Float
    }


type alias AvatarSpirit =
    { cur_spirit : Float
    , spirit : Float
    , max_spirit : Float
    , spirit_v : Float
    }


nullSpirit : AvatarSpirit
nullSpirit =
    { cur_spirit = 30
    , spirit = 30
    , max_spirit = 30
    , spirit_v = 0.3
    }


defaultAnima : AvatarAnima
defaultAnima =
    { a_pos = ( 0, 0 )
    , a_v = 0
    , a_a = 0.1
    , p_pos = ( 0, -0.2 )
    , p_v = 0.2
    , p_a = 0.1
    , lim = 1.4
    }

type alias Model =
    { pos : Point
    , status : TeachingStatus
    , time : Int
    , lightRange : Float
    , anima : AvatarAnima
    , spirit : AvatarSpirit
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { pos = (500, 500)
    , status = Init
    , time = 0
    , lightRange = 2
    , anima = defaultAnima
    , spirit = nullSpirit
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
