module Scenes.Hall.MainLayer.Common exposing (..)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Hall.LayerBase exposing (CommonData)
import Scenes.Level.Card.CardCreate exposing (Card)


type HallStatus
    = Active
    | Stopped
    | Inactive


type ButtonStatus
    = ButtonActive
    | ButtonInactive



--the states of Hall, decide what to render


type Choice
    = Setting
    | Help
    | Level
    | Card
    | Hall


type alias Button =
    { status : ButtonStatus
    , pos : Point
    , size : Point
    }



--all interface of set


type alias Settingbtn =
    { open : Button
    , close : Button
    }


initsetting : Settingbtn
initsetting =
    { open =
        { status = ButtonActive
        , pos = ( 200, 500 )
        , size = ( 200, 200 )
        }
    , close =
        { status = ButtonInactive
        , pos = ( 1600, 100 )
        , size = ( 200, 140 )
        }
    }



--all interface of help


type alias Helpbtn =
    { open : Button
    , close : Button
    }


inithelp : Helpbtn
inithelp =
    { open =
        { status = ButtonActive
        , pos = ( 600, 500 )
        , size = ( 200, 200 )
        }
    , close =
        { status = ButtonInactive
        , pos = ( 1600, 100 )
        , size = ( 200, 140 )
        }
    }



--open the level page, close it, up btn add the level number, down decrease it, confirm it


type alias Levelbtn =
    { open : Button
    , close : Button
    , levelInt : Int
    , up : Button
    , down : Button
    , ok : Button
    }


initlevel : Levelbtn
initlevel =
    { open =
        { status = ButtonActive
        , pos = ( 1400, 500 )
        , size = ( 200, 140 )
        }
    , close =
        { status = ButtonInactive
        , pos = ( 1600, 100 )
        , size = ( 200, 140 )
        }
    , levelInt = 1
    , up =
        { status = ButtonInactive
        , pos = ( 1000, 300 )
        , size = ( 200, 140 )
        }
    , down =
        { status = ButtonInactive
        , pos = ( 300, 300 )
        , size = ( 200, 140 )
        }
    , ok =
        { status = ButtonInactive
        , pos = ( 800, 700 )
        , size = ( 200, 140 )
        }
    }


type alias Cardbtn =
    { open : Button
    , close : Button
    , cardlist : List Card
    }


initcard : Cardbtn
initcard =
    { open =
        { status = ButtonActive
        , pos = ( 1000, 500 )
        , size = ( 140, 200 )
        }
    , close =
        { status = ButtonInactive
        , pos = ( 1600, 100 )
        , size = ( 200, 140 )
        }
    , cardlist = []
    }


{-| Model
Add your own data here.
-}
type alias Model =
    { status : HallStatus
    , time : Int
    , click_pos : Point
    , hall_name : String
    , setting : Settingbtn
    , level : Levelbtn
    , help : Helpbtn
    , card : Cardbtn
    , choice : Choice
    }


nullModel : Model
nullModel =
    { status = Active
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = "Hall"
    , setting = initsetting
    , level = initlevel
    , help = inithelp
    , card = initcard
    , choice = Hall
    }


initModelWin : Model
initModelWin =
    { status = Active
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = "You defeat the enemy in Level 1 !"
    , setting = initsetting
    , level = initlevel
    , help = inithelp
    , card = initcard
    , choice = Hall
    }


initModelLose : Model
initModelLose =
    { status = Active
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = "You lost all light."
    , setting = initsetting
    , level = initlevel
    , help = inithelp
    , card = initcard
    , choice = Hall
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
