module Scenes.Teaching.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , AvatarAnima, AvatarSpirit, TeachingStatus(..)
    , textBoxPos
    )

{-| Common module


# Basic data

@docs Model, nullModel, EnvC


# Data types

@docs AvatarAnima, AvatarSpirit, TeachingStatus


# Functions

@docs textBoxPos

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Teaching.LayerBase exposing (CommonData)


{-| Status of teaching
-}
type TeachingStatus
    = Init
    | Muttering1
    | Muttering2
    | Enemy1
    | Enemy2
    | Hurt
    | SelectAvatar
    | MoveAvatar
    | Muttering3
    | RevealScroll
    | Card1
    | Card2
    | End


{-| Animation for avatar
-}
type alias AvatarAnima =
    { a_pos : Point
    , a_v : Float
    , a_a : Float
    , p_pos : Point
    , p_v : Float
    , p_a : Float
    , lim : Float
    }


{-| Spirit of avatar
-}
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


{-| Model for Teaching
-}
type alias Model =
    { pos : Point
    , status : TeachingStatus
    , time : Int
    , lightRange : Float
    , anima : AvatarAnima
    , spirit : AvatarSpirit
    , click_pos : Point
    , scroll_opacity : Float
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { pos = ( 500, 500 )
    , status = Init
    , time = 0
    , lightRange = 2
    , anima = defaultAnima
    , spirit = nullSpirit
    , click_pos = textBoxPos
    , scroll_opacity = 0
    }


{-| Give the size of text box
-}
textBoxPos : Point
textBoxPos =
    ( 1200, 300 )


revealCandleTimeSlot : Int
revealCandleTimeSlot =
    150


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
