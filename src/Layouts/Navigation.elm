module Layouts.Navigation exposing (layout)

import Color
import Colors exposing (lightgray, withAlpha)
import Component exposing (button)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Region as Region
import Html.Attributes as Attr
import Material.Icons.Action as ActionIcons
import View exposing (InfoBox, Slide(..), View)


layout : { page : View msg } -> View msg
layout { page } =
    { title = page.title
    , body =
        case page.body of
            Header header ->
                Header <|
                    el
                        [ htmlAttribute <| Attr.class "page"
                        , width fill
                        , height fill
                        , inFront <| overlay page.info page.previous page.next
                        ]
                        header

            Slide { header, body } ->
                Slide
                    { header = header
                    , body =
                        el
                            [ htmlAttribute <| Attr.class "page"
                            , width fill
                            , height fill
                            , inFront <| overlay page.info page.previous page.next
                            , scrollbarY
                            , padding 5
                            ]
                            body
                    }
    , info = page.info
    , previous = page.previous
    , next = page.next
    }


overlay :
    Maybe (InfoBox msg)
    -> Maybe msg
    -> Maybe msg
    -> Element msg
overlay info previous next =
    row
        [ alignBottom
        , width fill
        ]
        [ el
            [ alignBottom
            , alignLeft
            , width (fill |> maximum 800)
            ]
          <|
            case info of
                Just i ->
                    el
                        [ Events.onMouseEnter i.onMouseEnter
                        , Events.onMouseLeave i.onMouseLeave
                        , Region.description "Info"
                        , width fill
                        ]
                    <|
                        if i.showInfoBox then
                            el
                                [ padding 20
                                , Border.color lightgray
                                , Border.width 2
                                , Border.rounded 8
                                , Background.color (lightgray |> withAlpha 0.12)
                                , Font.size 20
                                , width fill
                                ]
                                i.infoBox

                        else
                            ActionIcons.info_outline (lightgray |> toRgb |> Color.fromRgba) 30
                                |> html
                                |> el [ Font.size 20 ]

                Nothing ->
                    none
        , el [ alignBottom, alignRight ] <|
            row
                [ alignLeft
                , alignTop
                , spacing 20
                ]
                [ button previous "<"
                , button next ">"
                ]
        ]
