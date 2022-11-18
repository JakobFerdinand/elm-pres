module Pages.Architecture exposing (Model, Msg, layout, page)

import Colors exposing (blue, lightgray)
import Component exposing (codeBlock)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import KeyListener
import Layout exposing (Layout)
import Navigation exposing (navigate)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import View exposing (Slide(..), View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


layout : Layout
layout =
    Layout.Navigation



-- INIT


type Model
    = Init
    | WithCode


init : () -> ( Model, Effect Msg )
init () =
    ( Init
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case ( msg, model ) of
        ( NavigatePrevious, Init ) ->
            ( model, navigate Path.Unions )

        ( NavigatePrevious, WithCode ) ->
            ( Init, Effect.none )

        ( NavigateNext, Init ) ->
            ( WithCode, Effect.none )

        ( NavigateNext, WithCode ) ->
            ( model, navigate Path.Resouces )

        ( DoNothing, _ ) ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    KeyListener.subscription NavigatePrevious NavigateNext DoNothing



-- VIEW


view : Model -> View Msg
view model =
    { title = "ELM"
    , body =
        Slide
            { header = text "Elm Architecture"
            , body =
                case model of
                    Init ->
                        showDiagram [ centerX ]

                    WithCode ->
                        showWithCode
            }
    , info = Nothing
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


showDiagram : List (Attribute msg) -> Element msg
showDiagram attributes =
    column
        (attributes
            ++ [ width (fill |> maximum 700)
               , height fill
               , spacing 5
               ]
        )
        [ image
            [ width fill
            , Background.color lightgray
            , Border.rounded 5
            , centerX
            ]
            { src = "/diagram-tea.png"
            , description = "The Elm Architecture"
            }
        , newTabLink
            [ centerX
            , Font.size 10
            , Font.color blue
            ]
            { url = "https://sporto.github.io/elm-workshop/03-tea/01-intro.html"
            , label = text "Image from sportio"
            }
        ]


showWithCode : Element msg
showWithCode =
    row [ spacing 50, height fill, centerX ]
        [ showDiagram [ alignLeft ]
        , column [ spacing 5, height fill ]
            [ el [ alignTop, height fill ] <|
                codeBlock
                    [ Font.size 20
                    , height fill
                    , scrollbarY
                    , moveUp 20
                    ]
                    "type alias Model =\n    { count : Int }\n\n\ninit : () -> (Model, Cmd Msg)\ninit () =\n    ( { count = 0 }\n    , Cmd.none\n    )\n\n\ntype Msg\n    = Increment\n    | Decrement\n\n\nupdate : Msg -> Model -> ( Model, Cmd Msg )\nupdate msg model =\n    case msg of\n        Increment ->\n            ( { model | count = model.count + 1 }\n            , Cmd.none\n            )\n\n        Decrement ->\n            ( { model | count = model.count - 1 }\n            , Cmd.none\n            )\n\n\nview : Model -> Html Msg\nview model =\n    div []\n        [ button [ onClick Increment ] [ text \"+1\" ]\n        , div [] [ text <| String.fromInt model.count ]\n        , button [ onClick Decrement ] [ text \"-1\" ]\n        ]"
            , newTabLink
                [ centerX
                , Font.color blue
                , Font.size 24
                ]
                { url = "https://ellie-app.com/k8pLSb2z53Za1"
                , label = text "Execute me in Ellie"
                }
            ]
        ]
