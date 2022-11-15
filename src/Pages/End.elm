module Pages.End exposing (Model, Msg, layout, page)

import Browser.Events as E
import Colors exposing (blue)
import Cycle
import Effect exposing (Effect)
import Element exposing (..)
import Element.Font as Font
import Html
import Html.Attributes exposing (style)
import Html.Events exposing (on, onClick)
import Json.Decode as D
import KeyListener
import Layout exposing (Layout)
import Logo
import Navigation exposing (navigate)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import Time
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


type alias Model =
    { time : Float
    , logo : Logo.Model
    , patterns : Cycle.Cycle Logo.Pattern
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { time = 0
      , logo = Logo.start
      , patterns =
            Cycle.init Logo.heart
                [ Logo.logo
                , Logo.bird
                , Logo.logo
                , Logo.camel
                , Logo.logo
                , Logo.cat
                , Logo.logo
                , Logo.child
                , Logo.logo
                , Logo.house
                ]
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing
    | MouseMoved Float Float Float Float Float
    | MouseClicked
    | TimeDelta Float
    | TimePassed


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NavigatePrevious ->
            ( model, navigate Path.Packages )

        NavigateNext ->
            ( model, Effect.none )

        DoNothing ->
            ( model, Effect.none )

        MouseClicked ->
            ( { model
                | patterns = Cycle.step model.patterns
                , logo = Logo.setPattern (Cycle.next model.patterns) model.logo
              }
            , Effect.none
            )

        MouseMoved t x y dx dy ->
            ( { model
                | time = t
                , logo = Logo.perturb (t - model.time) x y dx dy model.logo
              }
            , Effect.none
            )

        TimeDelta timeDelta ->
            ( { model
                | logo =
                    if Logo.isMoving model.logo then
                        Logo.step timeDelta model.logo

                    else
                        model.logo
              }
            , Effect.none
            )

        TimePassed ->
            ( { model
                | patterns = Cycle.step model.patterns
                , logo = Logo.setPattern (Cycle.next model.patterns) model.logo
              }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ KeyListener.subscription NavigatePrevious NavigateNext DoNothing
        , if Logo.isMoving model.logo then
            E.onAnimationFrameDelta TimeDelta

          else
            Time.every 10000 (\_ -> TimePassed)
        ]



-- VIEW


view : Model -> View Msg
view model =
    { title = "ELM"
    , body =
        Header <|
            column
                [ centerX
                , centerY
                ]
                [ el
                    [ width (px 500)
                    , height (px 500)
                    , scale 1.3
                    , moveUp 50
                    ]
                  <|
                    tangram model
                , column
                    [ spacing 50 ]
                    [ el
                        [ Font.size 44, centerX ]
                      <|
                        text "Thank you!"
                    , link [ Font.color blue ]
                        { url = "https://elm-pres.jakobferdinand.at"
                        , label = text "https://elm-pres.jakobferdinand.at"
                        }
                    ]
                ]
    , previous = Just NavigatePrevious
    , next = Nothing
    }


tangram : Model -> Element Msg
tangram model =
    html <|
        Logo.view
            "-600 -600 1200 1200"
            [ style "max-height" "500px"
            , style "max-width" "500px"
            , onMouseMove
            , onClick MouseClicked
            ]
            model.logo


onMouseMove : Html.Attribute Msg
onMouseMove =
    on "mousemove" <|
        D.map7 (\t x y dx dy w h -> MouseMoved t (x / w - 0.5) (0.5 - y / h) (dx / w) (-dy / h))
            (D.field "timeStamp" D.float)
            (D.field "offsetX" D.float)
            (D.field "offsetY" D.float)
            (D.field "movementX" D.float)
            (D.field "movementY" D.float)
            (D.field "currentTarget" (D.field "clientWidth" D.float))
            (D.field "currentTarget" (D.field "clientHeight" D.float))
