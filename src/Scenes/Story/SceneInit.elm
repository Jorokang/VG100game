module Scenes.Story.SceneInit exposing
    ( nullStoryInit
    , StoryInit
    , initCommonData
    )

{-| SceneInit

@docs nullStoryInit
@docs StoryInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Story.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias StoryInit =
    {
        id:Int
    }


{-| Null StoryInit data
-}
nullStoryInit : StoryInit
nullStoryInit =
    {
        id = 0
    }


{-| Initialize common data
-}
initCommonData : Env -> StoryInit -> CommonData
initCommonData _ _ =
    nullCommonData
