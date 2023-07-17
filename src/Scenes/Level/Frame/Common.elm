module Scenes.Level.Frame.Common exposing
    ( Model, nullModel, EnvC
    , FrameStatus(..), initFrame1, NextRoundButton
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Level.LayerBase exposing (CommonData)


type FrameStatus
    = FramePlayerTurn
    | FrameEnemyTurn
    | FrameStopped
    | FrameInactive


{-| Model
Add your own data here.
-}
type alias PlayerData =
    { cur_stamina : Int
    , max_stamina : Int
    }

type alias NextRoundButton =
    { button_rotation : Float
    , button_angular_v : Float        
    }
--degrees


type alias Model =
    { status : FrameStatus
    , time : Int
    , player_data : PlayerData
    , next_round_button : NextRoundButton
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
    , next_round_button = nullNextRoundButton
    }


initFrame1 : Model
initFrame1 =
    { status = FramePlayerTurn
    , time = 0
    , player_data =
        { cur_stamina = 3
        , max_stamina = 3
        }
    , next_round_button = nullNextRoundButton
    }

nullNextRoundButton : NextRoundButton
nullNextRoundButton =
    { button_rotation= 0
    , button_angular_v = 0
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
