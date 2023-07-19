module Scenes.Story.MainLayer.Common exposing (Model, nullModel, EnvC, StoryStatus(..), initModel1, StoryItem, nullStoryItem)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Story.LayerBase exposing (CommonData)

type StoryStatus
    = StoryRoom
    | StoryFamilyPainting
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
    }

nullStoryItem : StoryItem
nullStoryItem =
    { c_pos = (0,0)
    , c_size = (0,0)
    , c_sprite_name = ""
    , c_scale = 1
    , v_pos = (0,0)
    , v_size = (0,0)
    , v_sprite_name = ""
    , str = ""
    }

initStoryItem1 : StoryItem
initStoryItem1 =
    { c_pos = (0,0)
    , c_size = (100, 100)
    , c_sprite_name = "pattern_1"
    , c_scale = 1
    , v_pos = (100,100)
    , v_size = (1000, 500)
    , v_sprite_name = "pattern_2"
    , str = "test"
    }

nullModel : Model
nullModel =
    { status = StoryNull
    , family_painting = nullStoryItem
    }

initModel1 : Model
initModel1 =
    { status = StoryRoom
    , family_painting = initStoryItem1
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
