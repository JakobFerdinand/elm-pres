module Component exposing (button, code, heading, subHeading)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font



-- Code


code : List (Attribute msg) -> String -> Element msg
code attributes source =
    el
        (attributes
            ++ [ Background.color gray
               , Border.rounded 5
               , Font.color orange
               , Font.family
                    [ Font.external
                        { name = "Source Code Pro"
                        , url = "https://fonts.googleapis.com/css2?family=Source+Code+Pro&display=swap"
                        }
                    ]
               , padding 8
               ]
        )
    <|
        text source



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
