module Layouts.Navigation exposing (layout)

import Colors exposing (black, gray, lightgray)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes as Attr
import View exposing (View)


layout : { page : View msg } -> View msg
layout { page } =
    { title = page.title
    , body =
        el
            [ htmlAttribute <| Attr.class "page"
            , width fill
            , height fill
            , inFront <| overlay page.next page.previous
            ]
            page.body
    , next = page.next
    , previous = page.previous
    }


overlay : Maybe String -> Maybe String -> Element msg
overlay next previous =
    let
        button : Maybe String -> String -> Element msg
        button nav t =
            case nav of
                Just n ->
                    link []
                        { url = n
                        , label =
                            buttonContent
                                [ Font.color black
                                , padding 8
                                , Border.rounded 5
                                , mouseOver
                                    [ Background.color lightgray
                                    ]
                                ]
                                t
                        }

                Nothing ->
                    buttonContent [ Font.color gray ] t

        buttonContent : List (Attribute msg) -> String -> Element msg
        buttonContent attr t =
            el attr <| text t
    in
    el
        [ alignRight
        , alignBottom
        , padding 50
        ]
    <|
        row
            [ alignLeft
            , alignTop
            , spacing 20
            ]
            [ button previous "<"
            , button next ">"
            ]
