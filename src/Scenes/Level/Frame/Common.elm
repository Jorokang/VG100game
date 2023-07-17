module Scenes.Level.Frame.Common exposing
    ( Model, nullModel, EnvC
    , FrameStatus(..), NextRoundButton, NextRoundButtonStatus(..), initFrame1
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Level.LayerBase exposing (CommonData)


type FrameStatus
    = FramePlayerTurn
    | FrameEnemyTurn
    | FrameStopped
    | FrameInactive


type NextRoundButtonStatus
    = NRBStable
    | NRBClicked
    | NRBBig


{-| Model
Add your own data here.
-}
type alias PlayerData =
    { cur_stamina : Int
    , max_stamina : Int
    }


type alias NextRoundButton =
    { status : NextRoundButtonStatus
    , radius : Float
    , pos : Point
    , scale : Float
    , scale_v : Float
    , max_scale : Float
    }



--degrees


type alias Model =
    { status : FrameStatus
    , time : Int
    , player_data : PlayerData
    , next_round_b : NextRoundButton
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { status = FrameInactive
    , time = 0
    , player_data =
        { cur_stamina = 0
        , max_stamina = 0
        }
    , next_round_b = nullNextRoundB
    }


initFrame1 : Model
initFrame1 =
    { status = FramePlayerTurn
    , time = 0
    , player_data =
        { cur_stamina = 3
        , max_stamina = 3
        }
    , next_round_b = nullNextRoundB
    }


nullNextRoundB : NextRoundButton
nullNextRoundB =
    { status = NRBStable
    , radius = 50
    , pos = ( 1200, 600 )
    , scale = 1
    , scale_v = 0.03
    , max_scale = 1.24
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
