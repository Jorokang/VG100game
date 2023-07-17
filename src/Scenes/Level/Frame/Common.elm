module Scenes.Level.Frame.Common exposing
    ( Model, nullModel, EnvC
    , FrameStatus(..), initFrame1, NextRoundButton, NextRoundButtonStatus(..)
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
    | NRBReturning
    | NRBRotating

{-| Model
Add your own data here.
-}
type alias PlayerData =
    { cur_stamina : Int
    , max_stamina : Int
    }

type alias NextRoundButton =
    { status : NextRoundButtonStatus
    , size : Point
    , b_rotation_1 : Float
    , b_angular_v_1 : Float
    , b_rotation_2 : Float
    , b_angular_v_2 : Float 
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
    , size = (100, 100)
    , b_rotation_1 = 0
    , b_angular_v_1 = 0
    , b_rotation_2 = 0
    , b_angular_v_2 = 0
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
