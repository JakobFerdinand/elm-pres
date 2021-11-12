module Main exposing (main)

import Animation
import Browser
import Browser.Events exposing (onKeyPress)
import Element exposing (..)
import Html exposing (Html)
import Html.Attributes as HtmlAtt
import Json.Decode as Json
import List.Extra exposing (getAt)
import Svg
import Svg.Attributes as SvgAtt


type alias Frame =
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    }


type alias Model =
    { style : Animation.State
    , currentFrameIndex : Int
    }


type Msg
    = GoToNext
    | Animate Animation.Msg


defaultFrame : Frame
defaultFrame =
    { x = 0, y = 0, width = 323, height = 323 }


frames : List Frame
frames =
    [ { x = 0, y = 0, width = 323, height = 323 }
    , { x = 0, y = 0, width = 150, height = 150 }
    , { x = 150, y = 0, width = 150, height = 150 }
    , { x = 150, y = 150, width = 150, height = 150 }
    , { x = 0, y = 150, width = 150, height = 150 }
    ]


toViewBox : Frame -> Animation.Property
toViewBox frame =
    Animation.viewBox frame.x frame.y frame.width frame.height


init : () -> ( Model, Cmd Msg )
init _ =
    ( { style = Animation.style [ toViewBox defaultFrame ]
      , currentFrameIndex = 0
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToNext ->
            let
                nextFrameIndex =
                    modBy (List.length frames) (model.currentFrameIndex + 1)
            in
            ( { model
                | style =
                    Animation.interrupt
                        [ Animation.to
                            [ frames
                                |> getAt nextFrameIndex
                                |> Maybe.withDefault defaultFrame
                                |> toViewBox
                            ]
                        ]
                        model.style
                , currentFrameIndex = nextFrameIndex
              }
            , Cmd.none
            )

        Animate animationMsg ->
            ( { model
                | style = Animation.update animationMsg model.style
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate [ model.style ]
        , onKeyPress (Json.succeed GoToNext)
        ]


elmLogo : List (Html.Attribute msg) -> Element msg
elmLogo viewBoxAttr =
    html <|
        Svg.svg (viewBoxAttr ++ [ HtmlAtt.width 323, HtmlAtt.height 323 ])
            [ Svg.path [ SvgAtt.fill "#F0AD00", SvgAtt.d "m162 153 70-70H92z" ] []
            , Svg.path [ SvgAtt.fill "#7FD13B", SvgAtt.d "m9 0 70 70h153L162 0zM247 85l77 76-77 77-76-77z" ] []
            , Svg.path [ SvgAtt.fill "#60B5CC", SvgAtt.d "M323 144V0H180z" ] []
            , Svg.path [ SvgAtt.fill "#5A6378", SvgAtt.d "M153 162 0 9v305z" ] []
            , Svg.path [ SvgAtt.fill "#F0AD00", SvgAtt.d "m256 247 67 67V179z" ] []
            , Svg.path [ SvgAtt.fill "#60B5CC", SvgAtt.d "M162 171 9 323h305z" ] []
            ]


view : Model -> Html Msg
view model =
    layout
        [ width fill
        , height fill
        ]
    <|
        column [ centerX, centerY ]
            [ elmLogo (Animation.render model.style) ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
