module Scenes.Level.Avatar.Common exposing
    ( Model, nullModel, EnvC
    , AvatarStatus(..), CardSelectionStatus(..), GridLoc, avatarRadius, cardClickPos0, cardClickPos1, cardClickPos2, initAvatar1, initAvatarLevel1, initAvatarLevel2
    )

{-| Common module

@docs Model, nullModel, EnvC

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


type CardSelectionStatus
    = CardType_1
    | CardType_2
    | CardType_8
    | CardType_9
    | CardType_11
    | CardType_None


type alias GridLoc =
    ( Int, Int )


type alias Model =
    { status : AvatarStatus
    , card_status : CardSelectionStatus
    , target_loc : GridLoc
    , cur_loc : GridLoc
    , pos : Point
    , avail_grids : List GridLoc
    , core_loc : GridLoc
    , map_size : GridLoc
    , spirit : Int
    , max_spirit : Int
    , lightRange : Float
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
    , spirit = 0
    , max_spirit = 0
    , lightRange = 0
    }


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
    , spirit = 30
    , max_spirit = 30
    , lightRange = 2
    }


initAvatarLevel1 : Model
initAvatarLevel1 =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 0, 0 )
    , cur_loc = ( 0, 0 )
    , pos = ( 0, 0 )
    , avail_grids = allGrids ( 5, 4 )
    , core_loc = ( 0, 0 )
    , map_size = ( 5, 4 )
    , spirit = 30
    , max_spirit = 30
    , lightRange = 2
    }


initAvatarLevel2 : Model
initAvatarLevel2 =
    { status = AvatarActive
    , card_status = CardType_None
    , target_loc = ( 1, 0 )
    , cur_loc = ( 1, 0 )
    , pos = ( 0, 0 )
    , avail_grids = allGrids ( 4, 6 )
    , core_loc = ( 1, 0 )
    , map_size = ( 4, 6 )
    , spirit = 40
    , max_spirit = 40
    , lightRange = 2
    }


avatarRadius : Float
avatarRadius =
    cellLength * 0.35


{-| About card type setup
-}
cardClickPos0 : List GridLoc
cardClickPos0 =
    [ ( -1, 0 ), ( 0, -1 ), ( 1, 0 ), ( 0, 1 ) ]


cardClickPos1 : List GridLoc
cardClickPos1 =
    [ ( 1, 0 ), ( 2, 0 ), ( -1, 0 ), ( -2, 0 ), ( 0, 1 ), ( 0, 2 ), ( 0, -1 ), ( 0, -2 ) ]


cardClickPos2 : List GridLoc
cardClickPos2 =
    [ ( 1, 1 ), ( 1, 0 ), ( 1, -1 ), ( 0, -1 ), ( -1, -1 ), ( -1, 0 ), ( -1, 1 ), ( 0, 1 ) ]


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
