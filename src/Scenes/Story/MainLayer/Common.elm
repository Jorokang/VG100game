module Scenes.Story.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , StoryItem, StoryStatus(..)
    , initModel0, initModel1, initModel2, initModel3, nullStoryItem
    )

{-| Common module


# Basic data

@docs Model, nullModel, EnvC


# Data types

@docs StoryItem, StoryStatus


# Functions

@docs initModel0, initModel1, initModel2, initModel3, nullStoryItem

-}

import Canvas exposing (Point)
import Html exposing (button)
import Lib.Env.Env as Env
import Scenes.Story.LayerBase exposing (CommonData)


type StoryStatus
    = StoryRoom
    | StoryFamilyPainting
    | StoryHall
    | StorySun
    | StoryDiary
    | StoryT
    | StoryNull


type alias StoryItem =
    { c_pos : Point
    , c_size : Point
    , c_sprite_name : String
    , c_scale : Float
    , v_pos : Point
    , v_size : Point
    , v_sprite_name : String
    , str : String
    }


type alias Model =
    { status : StoryStatus
    , family_painting : StoryItem
    , button_hall : StoryItem
    , sun : StoryItem
    , diary : StoryItem
    , id : Int
    , t : StoryItem
    }


nullStoryItem : StoryItem
nullStoryItem =
    { c_pos = ( 0, 0 )
    , c_size = ( 0, 0 )
    , c_sprite_name = ""
    , c_scale = 1
    , v_pos = ( 0, 0 )
    , v_size = ( 0, 0 )
    , v_sprite_name = ""
    , str = ""
    }


familyPaintingItem : StoryItem
familyPaintingItem =
    { c_pos = ( 30, 800 )
    , c_size = ( 100, 130 )
    , c_sprite_name = "family_painting_1"
    , c_scale = 1
    , v_pos = ( 500, 350 )
    , v_size = ( 800, 469 )
    , v_sprite_name = "family_painting_2"
    , str = "Mum and Dad and Me."
    }


diaryItem : StoryItem
diaryItem =
    { c_pos = ( 1660, 450 )
    , c_size = ( 200, 130 )
    , c_sprite_name = "diary_1"
    , c_scale = 1
    , v_pos = ( 500, 50 )
    , v_size = ( 960, 720 )
    , v_sprite_name = "diary_2"
    , str = "Saturday--- Sunny--- There is an entry to a fantasy dream world in my pillow! I must share it with mum and dad!"
    }


tItem : StoryItem
tItem =
    { c_pos = ( 850, 180 )
    , c_size = ( 200, 48 )
    , c_sprite_name = "teaching"
    , c_scale = 1
    , v_pos = ( 500, 350 )
    , v_size = ( 960, 720 )
    , v_sprite_name = ""
    , str = "teaching mode"
    }


sunItem : StoryItem
sunItem =
    { c_pos = ( 130, 60 )
    , c_size = ( 200, 200 )
    , c_sprite_name = "sun"
    , c_scale = 1
    , v_pos = ( 600, 350 )
    , v_size = ( 500, 500 )
    , v_sprite_name = "sun"
    , str = "I get the sun back, but it's a fake sun pasted on the window."
    }


button2Hall : StoryItem
button2Hall =
    { c_pos = ( 680, 890 )
    , c_size = ( 600, 100 )
    , c_sprite_name = "button_hall"
    , c_scale = 1
    , v_pos = ( 0, 0 )
    , v_size = ( 0, 0 )
    , v_sprite_name = ""
    , str = ""
    }


nullModel : Model
nullModel =
    { status = StoryNull
    , family_painting = nullStoryItem
    , button_hall = nullStoryItem
    , sun = nullStoryItem
    , diary = nullStoryItem
    , t = tItem
    , id = 4
    }


initModel0 : Model
initModel0 =
    { status = StoryRoom
    , family_painting = nullStoryItem
    , button_hall = button2Hall
    , sun = nullStoryItem
    , diary = nullStoryItem
    , t = tItem
    , id = 0
    }


initModel1 : Model
initModel1 =
    { status = StoryRoom
    , family_painting = nullStoryItem
    , button_hall = button2Hall
    , sun = sunItem
    , diary = nullStoryItem
    , t = tItem
    , id = 1
    }


initModel2 : Model
initModel2 =
    { status = StoryRoom
    , family_painting = familyPaintingItem
    , button_hall = button2Hall
    , sun = sunItem
    , diary = nullStoryItem
    , t = tItem
    , id = 2
    }


initModel3 : Model
initModel3 =
    { status = StoryRoom
    , family_painting = familyPaintingItem
    , button_hall = button2Hall
    , sun = sunItem
    , diary = diaryItem
    , t = tItem
    , id = 3
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
