module Yuki.Commands.Weather (weather) where

import Discord
import Discord.Types

import Yuki.Reply (reply)

weather :: Message -> DiscordHandler ()
weather m = do
  reply m "Weather!"