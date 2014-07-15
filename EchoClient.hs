{-# LANGUAGE OverloadedStrings #-}

module Main
    (
      main
    ) where

import           Control.Concurrent       (threadDelay)
import           Control.Concurrent.Async (async, waitCatch)
import           Control.Monad            (replicateM)
import           Data.ByteString          (hGetLine)
import           Data.ByteString.Char8    (hPutStrLn)
import           Network                  (PortID (PortNumber), connectTo)
import           System.Environment       (getArgs)
import           System.IO                (BufferMode (LineBuffering),
                                           hSetBuffering)

main :: IO ()
main = do
    [ip, port, spawnCount, pingFreq] <- getArgs
    asyncs <- replicateM (read spawnCount) $
                async $ echoClient ip (read port) (read pingFreq)
    mapM_ waitCatch asyncs

echoClient :: String -> Int -> Float -> IO ()
echoClient host port pingFreq = do
    h <- connectTo host (PortNumber (fromIntegral port))
    hSetBuffering h LineBuffering
    loop h
  where
    loop h = do
        hPutStrLn h "PING"
        _ <- hGetLine h
        threadDelay (round $ pingFreq*1000000)
        loop h
