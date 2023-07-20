module Scenes.Hall.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , Button, ButtonStatus(..), HallStatus(..), l1, l2, l3
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Html exposing (button, i)
import Lib.Env.Env as Env
import Scenes.Hall.LayerBase exposing (CommonData)


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
    , setting : Button
    }


l1 : Button
l1 =
    { status = ButtonActive
    , pos = ( 900, 600 )
    , size = ( 100, 100 )
    , text = "Level1"
    }


l2 : Button
l2 =
    { status = ButtonActive
    , pos = ( 1100, 600 )
    , size = ( 100, 100 )
    , text = "Level2"
    }


l3 : Button
l3 =
    { status = ButtonActive
    , pos = ( 1300, 600 )
    , size = ( 100, 100 )
    , text = "Level3"
    }


initsetting : Button
initsetting =
    { status = ButtonActive
    , pos = ( 1300, 800 )
    , size = ( 100, 100 )
    , text = "setting"
    }



--initialize the level buttons position


levelbuttons : Levelbtn
levelbuttons =
    { level1 = l1
    , level2 = l2
    , level3 = l3
    }


nullModel : Model
nullModel =
    { status = Active
    , levels = levelbuttons
    , time = 0
    , click_pos = ( -1, -1 )
    , setting = initsetting
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
