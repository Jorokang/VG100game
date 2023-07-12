module Scenes.Hall.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , Button, ButtonStatus(..), HallStatus(..), Level(..)
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Hall.LayerBase exposing (CommonData)

type Level
    = One
    | Two
    | Three

type HallStatus
    = Active
    | Stopped
    | Inactive


type ButtonStatus
    = ButtonActive
    | ButtonPressed
    | ButtonInactive



type alias Button =
    { status : ButtonStatus
    , pos : Point
    , size : Point
    , text : String
    }


{-| Model
Add your own data here.
-}
type alias Model =
    { status : HallStatus
    , levels : List Button
    , time : Int
    , click_pos : Point
    }


initButtonLevel : Button
initButtonLevel =
    { status = ButtonActive
    , pos = ( 900, 200 )
    , size = ( 100, 50 )
    , text = "Level"
    }

levelbuttons : List Button
levelbuttons = [initButtonLevel, {initButtonLevel | pos = (1100, 200)}, {initButtonLevel | pos = (1300, 200)} ]

nullModel : Model
nullModel =
    { status = Active
    , levels = levelbuttons
    , time = 0
    , click_pos = ( -1, -1 )
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
