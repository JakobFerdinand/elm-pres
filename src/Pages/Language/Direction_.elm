module Pages.Language.Direction_ exposing (Model, Msg, layout, page)

import Chart as C
import Chart.Attributes as CA
import Chart.Item as CI
import Colors exposing (..)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Font as Font
import Html.Attributes exposing (style)
import KeyListener
import Layout exposing (Layout)
import Navigation exposing (navigate)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import Svg as S
import View exposing (Slide(..), View)


page : Shared.Model -> Route { direction : String } -> Page Model Msg
page shared route =
    Page.new
        { init = init route.params.direction
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


layout : Layout
layout =
    Layout.Navigation



-- INIT


type Model
    = Init Bool
    | ShowDiagram Bool


init : String -> () -> ( Model, Effect Msg )
init param () =
    ( case param of
        "backward" ->
            ShowDiagram False

        "forward" ->
            Init False

        _ ->
            Init False
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing
    | MouseEnteredInfoBox
    | MouseLeftInfoBox


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case ( msg, model ) of
        ( NavigatePrevious, Init _ ) ->
            ( model, navigate Path.Overview )

        ( NavigatePrevious, ShowDiagram _ ) ->
            ( Init False, Effect.none )

        ( NavigateNext, Init _ ) ->
            ( ShowDiagram False, Effect.none )

        ( NavigateNext, ShowDiagram _ ) ->
            ( model, navigate Path.Compiler )

        ( MouseEnteredInfoBox, Init _ ) ->
            ( Init True, Effect.none )

        ( MouseLeftInfoBox, Init _ ) ->
            ( Init False, Effect.none )

        ( MouseEnteredInfoBox, ShowDiagram _ ) ->
            ( ShowDiagram True, Effect.none )

        ( MouseLeftInfoBox, ShowDiagram _ ) ->
            ( ShowDiagram False, Effect.none )

        ( DoNothing, _ ) ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ KeyListener.subscription NavigatePrevious NavigateNext DoNothing
        ]



-- VIEW


view : Model -> View Msg
view model =
    { title = "Elm Language"
    , body =
        Slide
            { header = text "Elm Language"
            , body =
                column
                    [ spacing 20
                    , width fill
                    , height fill
                    ]
                    (case model of
                        Init _ ->
                            viewLanguageHighlights

                        ShowDiagram _ ->
                            [ viewChart ]
                    )
            }
    , info =
        Just
            { onMouseEnter = MouseEnteredInfoBox
            , onMouseLeave = MouseLeftInfoBox
            , showInfoBox =
                case model of
                    Init show ->
                        show

                    ShowDiagram show ->
                        show
            , infoBox =
                case model of
                    Init _ ->
                        viewLanguageHighlightsInfo

                    ShowDiagram _ ->
                        viewChartInfo
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewLanguageHighlights : List (Element msg)
viewLanguageHighlights =
    let
        statement : Color -> String -> Element msg
        statement color s =
            el
                [ centerX
                , Font.color color
                ]
            <|
                text s
    in
    [ column
        [ width fill
        , centerY
        , spacing 20
        , Font.size 44
        ]
        [ statement green "functional"
        , statement blue "strongly typed"
        , statement orange "statically typed"
        , statement blue "immutable"
        , statement green "pure"
        ]
    ]


viewLanguageHighlightsInfo : Element msg
viewLanguageHighlightsInfo =
    column [ width fill, spacing 10 ]
        [ paragraph [ width fill ]
            [ text "For more infos about strong and static types take a look at "
            , newTabLink [ Font.color blue ]
                { url = "https://dev.to/leolas95/static-and-dynamic-typing-strong-and-weak-typing-5b0m"
                , label = text "that article about the differences"
                }
            , text "."
            ]
        , paragraph [ width fill ]
            [ text "Immutable means that a value can never be changed. "
            , text "Every time you want to change for example the field of a record"
            , text "it is required to create a new instance of the record with the updated field."
            ]
        , paragraph [ width fill ]
            [ text "Pure means that a function always provides the same output when given the same input. "
            , text "Also no side-effects can happen."
            ]
        ]


viewChart : Element msg
viewChart =
    let
        data =
            [ { maintainability = 20, useability = 85, language = "JavaScript", color = orangeHex }
            , { maintainability = 30, useability = 85, language = "Python", color = greenHex }
            , { maintainability = 40, useability = 85, language = "TypeScript", color = blueHex }
            , { maintainability = 70, useability = 70, language = "C#", color = greenHex }
            , { maintainability = 85, useability = 85, language = "Rust", color = orangeHex }
            , { maintainability = 90, useability = 40, language = "Haskell", color = blueHex }
            , { maintainability = 90, useability = 90, language = "Elm", color = blueHex }
            ]
    in
    C.chart
        [ CA.height 200
        , CA.width 300
        , CA.padding { top = 0, bottom = 0, left = 30, right = 10 }
        , CA.range
            [ CA.lowest 10 CA.orLower
            , CA.highest 100 CA.orHigher
            ]
        , CA.domain
            [ CA.lowest 10 CA.orLower
            , CA.highest 100 CA.orHigher
            ]
        ]
        [ C.xAxis [ CA.color lightgrayHex ]
        , C.yAxis [ CA.color lightgrayHex ]
        , C.series .useability
            [ C.scatter .maintainability [ CA.opacity 0, CA.borderWidth 0 ]
                |> C.variation (\i d -> [ CA.size 150 ])
            ]
            data
        , C.eachDot <|
            \p dot ->
                [ C.label
                    [ CA.moveDown 5, CA.color (CI.getData dot).color ]
                    [ S.text (CI.getData dot).language ]
                    (CI.getCenter p dot)
                ]
        , C.labelAt .min
            CA.middle
            [ CA.moveLeft 5, CA.rotate 90 ]
            [ S.text "Maintainable" ]
        , C.labelAt
            CA.middle
            .min
            [ CA.moveDown 18 ]
            [ S.text "Usable" ]
        ]
        |> Element.html
        |> el
            [ width (fill |> maximum 800)
            , height fill
            , centerX
            , centerY
            , Font.size 24
            ]


viewChartInfo : Element msg
viewChartInfo =
    none
