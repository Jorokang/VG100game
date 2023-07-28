module Scenes.Level.Frame.Common exposing
    ( Model, nullModel, EnvC
    , ClearAnimation, FrameStatus(..), NextRoundButton, NextRoundButtonStatus(..), SpiritAnimation
    , initFrame1
    )

{-| Common module


# Basic data

@docs Model, nullModel, EnvC


# Data types

@docs ClearAnimation, FrameStatus, NextRoundButton, NextRoundButtonStatus, SpiritAnimation


# Functions

@docs initFrame1

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Random
import Scenes.Level.Frame.Random exposing (randomFrame)
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
    , add_stamina : Int
    , turns : Int
    }


type alias NextRoundButton =
    { status : NextRoundButtonStatus
    , radius : Float
    , pos : Point
    , scale : Float
    , scale_v : Float
    , max_scale : Float
    }


type alias ClearAnimation =
    { pos : Point
    , i_time : Int
    , e_time : Int
    }


type alias SpiritAnimation =
    { str : String
    , i_time : Int
    , e_time : Int
    }


type alias Model =
    { status : FrameStatus
    , time : Int
    , player_data : PlayerData
    , next_round_b : NextRoundButton
    , c_anima : List ClearAnimation
    , s_anima : List SpiritAnimation
    , rand_num : Int
    , seed : Random.Seed
    , op_reg : Int
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    let
        ( number, seed ) =
            randomFrame (Random.initialSeed 0)
    in
    { status = FrameInactive
    , time = 0
    , player_data =
        { cur_stamina = 0
        , max_stamina = 0
        , add_stamina = 0
        , turns = 0
        }
    , next_round_b = nullNextRoundB
    , c_anima = []
    , s_anima = []
    , rand_num = number
    , seed = seed
    , op_reg = 0
    }


initFrame1 : Model
initFrame1 =
    let
        ( number, seed ) =
            randomFrame (Random.initialSeed 0)
    in
    { status = FramePlayerTurn
    , time = 0
    , player_data =
        { cur_stamina = 3
        , max_stamina = 3
        , add_stamina = 0
        , turns = 0
        }
    , next_round_b = nullNextRoundB
    , c_anima = []
    , s_anima = []
    , rand_num = number
    , seed = seed
    , op_reg = 0
    }


nullNextRoundB : NextRoundButton
nullNextRoundB =
    { status = NRBStable
    , radius = 50
    , pos = ( 820, 650 )
    , scale = 1
    , scale_v = 0.03
    , max_scale = 1.24
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
