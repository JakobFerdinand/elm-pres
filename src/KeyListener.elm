module KeyListener exposing (Key, handle, subscription)

import Browser.Events
import Json.Decode


type Key
    = Character Char
    | Control String


subscription : msg -> msg -> msg -> Sub msg
subscription onLeftKeyPressed onRightKeyPressed onAnyOtherKeyPressed =
    Browser.Events.onKeyDown (keyDecoder onLeftKeyPressed onRightKeyPressed onAnyOtherKeyPressed)


keyDecoder : msg -> msg -> msg -> Json.Decode.Decoder msg
keyDecoder left right other =
    Json.Decode.map (toKey left right other) (Json.Decode.field "key" Json.Decode.string)


toKey : msg -> msg -> msg -> String -> msg
toKey left right other string =
    handle left right other <|
        case String.uncons string of
            Just ( char, "" ) ->
                Character char

            _ ->
                Control string


handle :
    msg
    -> msg
    -> msg
    -> Key
    -> msg
handle left right other key =
    case key of
        Control "ArrowLeft" ->
            left

        Control "ArrowRight" ->
            right

        Character ' ' ->
            right

        _ ->
            other
