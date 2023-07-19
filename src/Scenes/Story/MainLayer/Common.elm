module Scenes.Story.MainLayer.Common exposing (Model, nullModel, EnvC, StoryStatus(..), initModel1, StoryItem)

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
    { pos : Point
    , size : Point
    , sprite_name : String
    , str : String
    }

type alias Model =
    { status : StoryStatus
    , family_painting : StoryItem
    }

nullStoryItem : StoryItem
nullStoryItem =
    { pos = (0,0)
    , size = (0,0)
    , sprite_name = ""
    , str = ""
    }

nullModel : Model
nullModel =
    { status = StoryNull
    , family_painting = nullStoryItem
    }

initModel1 : Model
initModel1 =
    { status = StoryRoom
    , family_painting = nullStoryItem
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
