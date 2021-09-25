module Yuki.Commands ( ping
                     , weather
                     , verifyCommand
                     , Commands(..)
                     ) where

import Yuki.Commands.Ping (ping)
import Yuki.Commands.Weather (weather)

import Data.Text (Text, isPrefixOf)

data Commands
  = Ping
  | Weather

verifyCommand :: Text -> Maybe Commands
verifyCommand m
  | m `isPrefixOf` "ping" = Just Ping
  | m `isPrefixOf` "weather" = Just Weather
  | otherwise = Nothing
