module Scenes.Hall.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , Button, ButtonStatus(..), HallStatus(..)
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Hall.LayerBase exposing (CommonData)
import Html exposing (i)
import Html exposing (button)


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

type alias Levelbtn =
    { level1 : Button
    , level2 : Button
    , level3 : Button
    }

{-| Model
Add your own data here.
-}
type alias Model =
    { status : HallStatus
    , levels : Levelbtn
    , time : Int
    , click_pos : Point
    }


initButton : Button
initButton =
    { status = ButtonActive
    , pos = ( 900, 200 )
    , size = ( 100, 50 )
    , text = "Level"
    }

--initialize the level buttons position
levelbuttons : Levelbtn
levelbuttons = 
    { level1 = initButton
    , level2 = {initButton | pos = (1100,200)}
    , level3 = {initButton | pos = (1300,200)}
    }

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
