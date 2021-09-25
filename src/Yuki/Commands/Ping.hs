module Yuki.Commands.Ping (ping) where

import Discord
import Discord.Types

import Yuki.Reply (reply)

ping :: Message -> DiscordHandler ()
ping m = do
  reply m "Pong!"