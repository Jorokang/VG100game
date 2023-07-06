module Scenes.Level.Avatar.Common exposing
    ( Model, nullModel, EnvC
    , AvatarStatus(..), GridLoc, avatarRadius, initAvatar1
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Level.Frame.Functions exposing (cellLength)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type AvatarStatus
    = AvatarAcitve --not selected in player's turn
    | AvatarSelected --selected in player's turn
    | AvatarMoving --moving in player's turn
    | AvatarStopped --stopped
    | AvatarInactive --inactive


type alias GridLoc =
    ( Int, Int )


type alias Model =
    { status : AvatarStatus
    , target_loc : GridLoc
    , cur_loc : GridLoc
    , pos : Point
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { status = AvatarInactive
    , target_loc = ( 0, 0 )
    , cur_loc = ( 0, 0 )
    , pos = ( 0, 0 )
    }


initAvatar1 : Model
initAvatar1 =
    { status = AvatarAcitve
    , target_loc = ( 0, 1 )
    , cur_loc = ( 0, 1 )
    , pos = ( 0, 0 )
    }


avatarRadius : Float
avatarRadius =
    cellLength * 0.35


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
