module Pages.Home_ exposing (Model, Msg, layout, page)

import Element exposing (..)
import Element.Font as Font
import KeyListener
import Layout exposing (Layout)
import Logo
import Page exposing (Page)
import View exposing (View)


type alias Model =
    {}


type Msg
    = LeftKeyPressed
    | RightKeyPressed
    | OtherKeyPressed


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
        LeftKeyPressed ->
            ( model, Cmd.none )

        RightKeyPressed ->
            ( model, Cmd.none )

        OtherKeyPressed ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    KeyListener.subscription LeftKeyPressed RightKeyPressed OtherKeyPressed


view : Model -> View Msg
view model =
    { title = "Homepage"
    , body =
        Logo.elm
            [ centerX
            , centerY
            , inFront <|
                column
                    [ centerX
                    , centerY
                    , spacing 30
                    ]
                    [ el [ Font.size 36, centerX ] <| text "ELM"
                    , paragraph []
                        [ text "If it compiles it works!"
                        ]
                    ]
            ]
    , next = Just "/second"
    , previous = Nothing
    }
