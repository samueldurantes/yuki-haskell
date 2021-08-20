module Main where

import Data.Text (pack)
import Control.Monad (void)
import System.Environment (getEnv)

import Configuration.Dotenv (loadFile, defaultConfig)

import qualified Yuki

main :: IO ()
main = do
  void $ loadFile defaultConfig
  token <- getEnv "DISCORD_TOKEN"

  Yuki.login . pack $ token