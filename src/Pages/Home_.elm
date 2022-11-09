module Pages.Home_ exposing (Model, Msg, layout, page)

import Browser.Navigation as Nav
import Colors exposing (black)
import Element exposing (..)
import Element.Font as Font
import KeyListener
import Layout exposing (Layout)
import Logo
import Page exposing (Page)
import Route.Path as Path
import View exposing (View)


type alias Model =
    {}


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing


layout : Layout
layout =
    Layout.Navigation


page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigatePrevious ->
            ( model, Cmd.none )

        NavigateNext ->
            ( model, Nav.load <| Path.toString Path.Language )

        DoNothing ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    KeyListener.subscription NavigatePrevious NavigateNext DoNothing


view : Model -> View Msg
view _ =
    { title = "ELM"
    , body =
        column
            [ centerX
            , centerY
            , spacing 30
            ]
            [ Logo.elm
                [ centerX
                ]
            , column [ centerX ]
                [ el [ Font.size 36, centerX ] <| text "ELM"
                , paragraph []
                    [ text "If it compiles it works!"
                    ]
                ]
            ]
    , previous = Nothing
    , next = Just NavigateNext
    }
