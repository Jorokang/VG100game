module Scenes.Level.Avatar.Common exposing
    ( Model, nullModel, EnvC
    , AvatarAnima, AvatarSpirit, AvatarStatus(..), CardSelectionStatus(..), GridLoc
    , avatarRadius, cardClickPos0, cardClickPos1, cardClickPos2, initAvatar1, initAvatarLevel1, initAvatarLevel2, initAvatarLevel3, initAvatarLevel4
    )

{-| Common module


# Basic data

@docs Model, nullModel, EnvC


# Data types

@docs AvatarAnima, AvatarSpirit, AvatarStatus, CardSelectionStatus, GridLoc


# Functions

@docs avatarRadius, cardClickPos0, cardClickPos1, cardClickPos2, initAvatar1, initAvatarLevel1, initAvatarLevel2, initAvatarLevel3, initAvatarLevel4

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Level.Frame.Functions exposing (allGrids, cellLength)
import Scenes.Level.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type AvatarStatus
    = AvatarActive --not selected in player's turn
    | AvatarSelected --selected in player's turn
    | AvatarMoving --moving in player's turn
    | AvatarCard --using the card
    | AvatarStopped --stopped
    | AvatarDead --dead -> loose (spirit == 0)


{-| The CardSelection status
-}
type CardSelectionStatus
    = CardType_1
    | CardType_2
    | CardType_8
    | CardType_9
    | CardType_11
    | CardType_None


{-| Similar to Point
-}
type alias GridLoc =
    ( Int, Int )


{-| For animation
-}
type alias AvatarAnima =
    { a_pos : Point
    , a_v : Float
    , a_a : Float
    , p_pos : Point
    , p_v : Float
    , p_a : Float
    , lim : Float
    }


{-| The spirit of avatar
-}
type alias AvatarSpirit =
    { cur_spirit : Float
    , spirit : Float
    , max_spirit : Float
    , spirit_v : Float
    }


{-| Model of Avatar
-}
type alias Model =
    { level_id : Int
    , status : AvatarStatus
    , card_status : CardSelectionStatus
    , target_loc : GridLoc
    , cur_loc : GridLoc
    , pos : Point
    , avail_grids : List GridLoc
    , core_loc : GridLoc
    , map_size : GridLoc
    , lightRange : Float
    , anima : AvatarAnima
    , spirit : AvatarSpirit
    , stamina : Int
    }


{-| Null version of AvatarSpirit
-}
nullSpirit : AvatarSpirit
nullSpirit =
    { cur_spirit = 30
    , spirit = 30
    , max_spirit = 30
    , spirit_v = 0.3
    }


{-| Default AvatarSpirit
-}
defaultAnima : AvatarAnima
defaultAnima =
    { a_pos = ( 0, 0 )
    , a_v = 0
    , a_a = 0.1
    , p_pos = ( 0, -0.2 )
    , p_v = 0.2
    , p_a = 0.1
    , lim = 1.4
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 0, 0 )
    , cur_loc = ( 0, 0 )
    , pos = ( 0, 0 )
    , avail_grids = []
    , core_loc = ( 0, 0 )
    , map_size = ( 0, 0 )
    , spirit = nullSpirit
    , lightRange = 0
    , anima = defaultAnima
    , level_id = -1
    , stamina = 0
    }


{-| Initialize avatar 1
-}
initAvatar1 : GridLoc -> Model
initAvatar1 size =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 0, 1 )
    , cur_loc = ( 0, 1 )
    , pos = ( 0, 0 )
    , avail_grids = allGrids size
    , core_loc = ( 0, 0 )
    , map_size = size
    , spirit = nullSpirit
    , lightRange = 2
    , anima = defaultAnima
    , level_id = -1
    , stamina = 0
    }


{-| Initialize avatar for level 1
-}
initAvatarLevel1 : Model
initAvatarLevel1 =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 0, 0 )
    , cur_loc = ( 0, 0 )
    , pos = ( 0, 0 )
    , avail_grids = allGrids ( 2, 2 )
    , core_loc = ( 0, 0 )
    , map_size = ( 2, 2 )
    , spirit = nullSpirit
    , lightRange = 2
    , anima = defaultAnima
    , level_id = 1
    , stamina = 3
    }


{-| Initialize avatar for level 2
-}
initAvatarLevel2 : Model
initAvatarLevel2 =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 1, 0 )
    , cur_loc = ( 1, 0 )
    , pos = ( 0, 0 )
    , avail_grids = allGrids ( 4, 3 )
    , core_loc = ( 1, 0 )
    , map_size = ( 4, 3 )
    , spirit = nullSpirit
    , lightRange = 2
    , anima = defaultAnima
    , level_id = 2
    , stamina = 3
    }


{-| Initialize avatar for level 3
-}
initAvatarLevel3 : Model
initAvatarLevel3 =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 1, 0 )
    , cur_loc = ( 1, 0 )
    , pos = ( 0, 0 )
    , avail_grids = allGrids ( 5, 5 )
    , core_loc = ( 1, 0 )
    , map_size = ( 5, 5 )
    , spirit = nullSpirit
    , lightRange = 2
    , anima = defaultAnima
    , level_id = 3
    , stamina = 3
    }


{-| Initialize avatar for level 4
-}
initAvatarLevel4 : Int -> Model
initAvatarLevel4 rand_num =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 1, 0 )
    , cur_loc = ( 1, 0 )
    , pos = ( 0, 0 )
    , avail_grids = allGrids ( 2 + modBy 5 rand_num, 2 + modBy 4 rand_num )
    , core_loc = ( 1, 0 )
    , map_size = ( 2 + modBy 5 rand_num, 2 + modBy 4 rand_num )
    , spirit = nullSpirit
    , lightRange = 2
    , anima = defaultAnima
    , level_id = 4
    , stamina = 3
    }


{-| Give the radius
-}
avatarRadius : Float
avatarRadius =
    cellLength * 0.35


{-| About card type setup
-}
cardClickPos0 : List GridLoc
cardClickPos0 =
    [ ( -1, 0 ), ( 0, -1 ), ( 1, 0 ), ( 0, 1 ) ]


{-| Give the list of clicking positions 1
-}
cardClickPos1 : List GridLoc
cardClickPos1 =
    [ ( 1, 0 ), ( 2, 0 ), ( -1, 0 ), ( -2, 0 ), ( 0, 1 ), ( 0, 2 ), ( 0, -1 ), ( 0, -2 ) ]


{-| Give the list of clicking positions 2
-}
cardClickPos2 : List GridLoc
cardClickPos2 =
    [ ( 1, 1 ), ( 1, 0 ), ( 1, -1 ), ( 0, -1 ), ( -1, -1 ), ( -1, 0 ), ( -1, 1 ), ( 0, 1 ) ]


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
