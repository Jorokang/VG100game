module Lib.Resources.Sprites exposing (getResourcePath, allTexture)

{-|


# Textures

@docs getResourcePath, allTexture

-}


{-| Get the path of the resource.
-}
getResourcePath : String -> String
getResourcePath x =
    "assets/" ++ x


{-| allTexture

A list of all the textures.

Add your textures here. Don't worry if your list is too long. You can split those resources according to their usage.

Examples:

[
( "ball", getResourcePath "img/ball.png" ),
( "car", getResourcePath "img/car.jpg" )
]

-}
allTexture : List ( String, String )
allTexture =
    [ ( "avatar", getResourcePath "img/avatar.svg" )
    , ( "enemy1", getResourcePath "img/enemy1.svg" )
    , ( "enemy2", getResourcePath "img/enemy2.svg" )
    , ( "enemy3", getResourcePath "img/enemy3.svg" )
    , ( "card", getResourcePath "img/card.svg" )
    ]
