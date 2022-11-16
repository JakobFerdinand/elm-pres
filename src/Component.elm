module Component exposing
    ( button
    , code
    , codeBlock
    , heading
    , imageLink
    , subHeading
    )

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html
import Route.Path exposing (Path(..))
import SyntaxHighlight exposing (elm, oneDark, toBlockHtml, toInlineHtml, useTheme)



-- Code


code : List (Attribute msg) -> String -> Element msg
code attributes source =
    Html.div []
        [ useTheme oneDark
        , elm source
            |> Result.map toInlineHtml
            |> Result.withDefault
                (Html.text source)
        ]
        |> html
        |> el attributes


codeBlock : List (Attribute msg) -> String -> Element msg
codeBlock attributes source =
    Html.div []
        [ useTheme oneDark
        , elm source
            |> Result.map (toBlockHtml (Just 1))
            |> Result.withDefault
                (Html.text source)
        ]
        |> html
        |> el attributes



-- |> el
--     (attributes
--         ++ [ Background.color gray
--            , Border.rounded 5
--            , Font.color orange
--            , Font.family
--                 [ Font.external
--                     { name = "Source Code Pro"
--                     , url = "https://fonts.googleapis.com/css2?family=Source+Code+Pro&display=swap"
--                     }
--                 ]
--            , padding 8
--            ]
--     )
-- <|
--     text source
-- Button


button : Maybe msg -> String -> Element msg
button nav t =
    case nav of
        Just n ->
            buttonContent
                [ mouseOver
                    [ Background.color gray
                    ]
                , Border.rounded 5
                , padding 8
                , pointer
                , Events.onClick n
                ]
                t

        Nothing ->
            buttonContent [ Font.color gray ] t


buttonContent : List (Attribute msg) -> String -> Element msg
buttonContent attr t =
    el attr <| text t



-- Heddings


heading : Element msg -> Element msg
heading =
    el [ Font.bold, Font.size 36 ]


subHeading : Element msg -> Element msg
subHeading =
    el [ Font.bold, Font.size 24 ]



-- Links


imageLink :
    { url : String
    , images :
        List
            { imageUrl : String
            , imageDescription : String
            }
    , description : String
    }
    -> Element msg
imageLink { url, images, description } =
    newTabLink []
        { url = url
        , label =
            column [ width fill, spacing 5 ]
                [ row [ width (fill |> maximum 250), spacing 5 ]
                    (images |> List.map viewImage)
                , el [ centerX ] <| text description
                ]
        }


viewImage : { imageUrl : String, imageDescription : String } -> Element msg
viewImage { imageUrl, imageDescription } =
    image [ width (fill |> maximum 250) ]
        { src = imageUrl
        , description = imageDescription
        }
