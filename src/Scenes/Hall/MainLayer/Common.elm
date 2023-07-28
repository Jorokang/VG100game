module Scenes.Hall.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , Button, Cardbtn, Helpbtn, Levelbtn, Settingbtn
    , giveErrorCard, initModelLose, initModelWin
    , ButtonStatus(..), Choice(..), HallStatus(..), Hallname(..)
    )

{-| Common module


# Basic data

@docs Model, nullModel, EnvC


# Data types

@docs Button, ButtonStatus, Cardbtn, Choice, HallStatus, Hallname, Helpbtn, Levelbtn, Settingbtn


# Functions

@docs giveErrorCard, initModelLose, initModelWin

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


{-| choice of hall
the states of Hall, decide what to render
-}
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


{-| choice of hall
all interface of set
-}
type alias Settingbtn =
    { open : Button
    , close : Button
    , up : Button
    , down : Button
    , volume : Int
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
    , up =
        { status = ButtonInactive
        , pos = ( 1400, 500 )
        , size = ( 200, 140 )
        }
    , down =
        { status = ButtonInactive
        , pos = ( 200, 500 )
        , size = ( 200, 140 )
        }
    , volume = 50
    }


{-| choice of hall

all interface of help

-}
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


{-| interface of level
open the level page,
close it,
ok confirm it
-}
type alias Levelbtn =
    { open : Button
    , close : Button
    , level1 : Button
    , level2 : Button
    , level3 : Button
    , level4 : Button
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
    , level1 =
        { status = ButtonInactive
        , pos = ( 400, 600 )
        , size = ( 200, 140 )
        }
    , level2 =
        { status = ButtonInactive
        , pos = ( 720, 600 )
        , size = ( 200, 140 )
        }
    , level3 =
        { status = ButtonInactive
        , pos = ( 1040, 600 )
        , size = ( 200, 140 )
        }
    , level4 =
        { status = ButtonInactive
        , pos = ( 1360, 600 )
        , size = ( 200, 140 )
        }
    }


{-| choice of card
open and close and interface

add things about card below

-}
type alias Cardbtn =
    { open : Button
    , close : Button
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
    }


type Hallname
    = Win
    | Lose
    | Normal


{-| Model
Add your own data here.
-}
type alias Model =
    { status : HallStatus
    , time : Int
    , click_pos : Point
    , hall_name : Hallname
    , setting : Settingbtn
    , completed_level : Int
    , level : Levelbtn
    , help : Helpbtn
    , card : Cardbtn
    , choice : Choice
    , selected_cards : List Int
    , hand : List Card
    , click_status : Bool
    , hint : Bool
    }


nullModel : Model
nullModel =
    { status = Active
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = Normal
    , setting = initsetting
    , completed_level = 0
    , level = initlevel
    , help = inithelp
    , card = initcard
    , choice = Hall
    , selected_cards = [ 1, 2, 3, 4, 5 ]
    , hand = giveAvailableList 0
    , click_status = False
    , hint = False
    }

initModelBegin : Int -> Model
initModelBegin id =
    { status = Active
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = Normal
    , setting = initsetting
    , completed_level = id
    , level = initlevel
    , help = inithelp
    , card = initcard
    , choice = Hall
    , selected_cards = [ 1, 2, 3, 4, 5 ]
    , hand = giveAvailableList id
    , click_status = False
    , hint = False
    }


initModelWin : Int -> Model
initModelWin id =
    { status = Active
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = Win
    , setting = initsetting
    , completed_level = id
    , level = initlevel
    , help = inithelp
    , card = initcard
    , choice = Hall
    , selected_cards = [ 1, 2, 3, 4, 5 ]
    , hand = giveAvailableList id
    , click_status = False
    , hint = False
    }


initModelLose : Int -> Model
initModelLose id =
    { status = Active
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = Lose
    , setting = initsetting
    , completed_level = id - 1
    , level = initlevel
    , help = inithelp
    , card = initcard
    , choice = Hall
    , selected_cards = [ 1, 2, 3, 4, 5 ]
    , hand = giveAvailableList id
    , click_status = False
    , hint = False
    }


giveAvailableList : Int -> List Card
giveAvailableList id =
    case id of
        0 ->
            [ giveCard 1, giveCard 2, giveCard 3, giveCard 4, giveCard 5, giveErrorCard, giveErrorCard, giveErrorCard, giveErrorCard, giveErrorCard ]

        1 ->
            [ giveCard 1, giveCard 2, giveCard 3, giveCard 4, giveCard 5, giveCard 7, giveErrorCard, giveErrorCard, giveErrorCard, giveErrorCard ]

        2 ->
            [ giveCard 1, giveCard 2, giveCard 3, giveCard 4, giveCard 5, giveCard 7, giveCard 8, giveCard 9, giveErrorCard, giveErrorCard ]

        3 ->
            [ giveCard 1, giveCard 2, giveCard 3, giveCard 4, giveCard 5, giveCard 7, giveCard 8, giveCard 9, giveCard 10, giveCard 11 ]

        _ ->
            [ giveCard 1, giveCard 2, giveCard 3, giveCard 4, giveCard 5, giveErrorCard, giveErrorCard, giveErrorCard, giveErrorCard, giveErrorCard ]


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData


giveErrorCard : Card
giveErrorCard =
    { name = "error", id = -1, cost = -1, img = "cardback" }


giveCardList : List Card
giveCardList =
    [ { name = "purify", id = 1, cost = 2, img = "card1" }
    , { name = "guard", id = 2, cost = 2, img = "card2" }
    , { name = "take a break", id = 3, cost = 0, img = "card3" }
    , { name = "light up", id = 4, cost = 1, img = "card4" }
    , { name = "hope", id = 5, cost = 3, img = "card5" }
    , { name = "call up the past", id = 6, cost = 2, img = "cardback" }
    , { name = "courage", id = 8, cost = 4, img = "card8" }
    , { name = "endless hope", id = 7, cost = 5, img = "card7" }
    , { name = "sunrise", id = 9, cost = 6, img = "card9" }
    , { name = "thrive", id = 10, cost = 2, img = "card10" }
    , { name = "forget", id = 11, cost = 10, img = "card11" }
    ]


giveCard : Int -> Card
giveCard id =
    if id > 0 then
        Maybe.withDefault giveErrorCard <|
            List.head <|
                List.drop (id - 1) giveCardList

    else
        giveErrorCard
