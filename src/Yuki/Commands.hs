module Yuki.Commands ( ping
                     , weather
                     , together
                     , verifyCommand
                     , Commands(..)
                     ) where

import Yuki.Commands.Ping (ping)
import Yuki.Commands.Weather (weather)
import Yuki.Commands.Together (together)

import Data.Text (Text, isPrefixOf)

data Commands
  = Ping
  | Weather
  | Together

verifyCommand :: Text -> Maybe Commands
verifyCommand m
  | m `isPrefixOf` "ping" = Just Ping
  | m `isPrefixOf` "weather" = Just Weather
  | m `isPrefixOf` "together" = Just Together
  | otherwise = Nothing
