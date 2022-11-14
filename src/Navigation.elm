module Navigation exposing (navigate)

import Browser.Navigation as Nav
import Effect
import Route.Path


navigate to =
    to
        |> Route.Path.toString
        |> Nav.load
        |> Effect.fromCmd
