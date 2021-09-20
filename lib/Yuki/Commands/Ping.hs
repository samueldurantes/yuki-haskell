module Yuki.Commands.Ping (ping) where

import Discord.Types
import qualified Discord.Requests as R

ping :: Message -> R.ChannelRequest Message
ping m = R.CreateMessage (messageChannel m) "Pong!"
