module Lib.Layer.Base exposing
    ( LayerMsg(..)
    , LayerTarget(..)
    , Layer
    )

{-| Layer Base

Layer plays a very important role in the game framework.

It is mainly used to seperate different rendering layers.

Using layers can help us deal with different things in different layers.

@docs LayerMsg
@docs LayerTarget
@docs Layer

-}

import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption)
import Lib.Env.Env exposing (EnvC)
import Messenger.GeneralModel exposing (GeneralModel)
import Scenes.Level.Enemy.Common exposing (GridLoc)


{-| Layer

Layer data type.

a is the layer data, b is the common data that shares between layers, c is the init data

-}
type alias Layer a b =
    GeneralModel a (EnvC b) LayerMsg LayerTarget Renderable


{-| LayerMsg

Add your own layer messages here.

LayerSoundMsg name path option

-}
type LayerMsg
    = LayerStringMsg String
    | LayerIntMsg Int
    | LayerFloatMsg Float
    | LayerStringDataMsg String LayerMsg
    | LayerSoundMsg String String AudioOption
    | LayerStopSoundMsg String
    | LayerChangeSceneMsg String
    | LayerMsgPlayerTurn --revealing that it's Player's turn in the level
    | LayerMsgEnemyTurn --revealing that it's Enemy's turn in the level
    | LayerMsgClearCell GridLoc --Clear a cell
    | LayerMsgErodeCell GridLoc --Erode a cell
    | LayerMsgEnemyErodeCell GridLoc --The enemy erodes a cell (sent by the enemy)
    | LayerMsgClickLoc GridLoc --mouse click the grids on a cell
    | LayerMsgCardType Int --the card type
    | LayerMsgErodePermission GridLoc Int --check whether this cell is protected (Int: 0 -> denied/asking; 1 -> approved)
    | NullLayerMsg


{-| LayerTarget

You can send message to a layer by using LayerTarget.

LayerParentScene is used to send message to the parent scene of the layer.

LayerName is used to send message to a specific layer.

-}
type LayerTarget
    = LayerParentScene
    | LayerName String
