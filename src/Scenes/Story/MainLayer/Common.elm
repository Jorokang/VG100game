module Scenes.Story.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , StoryItem, StoryStatus(..), initModel1, nullStoryItem
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Html exposing (button)
import Lib.Env.Env as Env
import Scenes.Story.LayerBase exposing (CommonData)


type StoryStatus
    = StoryRoom
    | StoryFamilyPainting
    | StoryHall
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
    , str = "Mum and Dad and Me"
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
    }


initModel1 : Model
initModel1 =
    { status = StoryRoom
    , family_painting = familyPaintingItem
    , button_hall = button2Hall
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
