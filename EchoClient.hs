{-# LANGUAGE OverloadedStrings #-}

module Main
    (
      main
    ) where

import           Control.Concurrent       (forkIO, threadDelay)
import           Control.Concurrent.Async (async, waitCatch)
import           Control.Exception        (finally)
import           Control.Monad            (forever, replicateM, void)
import           Data.ByteString          (hGetLine)
import           Data.ByteString.Char8    (hPutStrLn)
import           Data.IORef               (IORef, atomicModifyIORef', newIORef,
                                           readIORef)
import           Network                  (PortID (PortNumber), connectTo)
import           System.Environment       (getArgs)
import           System.IO                (BufferMode (LineBuffering),
                                           hSetBuffering)

main :: IO ()
main = do
    [ip, port, spawnCount, pingFreq] <- getArgs
    count <- newIORef (0 :: Int)
    void $ forkIO $ watcher count
    asyncs <- replicateM (read spawnCount) $
                async $ echoClient ip (read port) (read pingFreq) count
    mapM_ waitCatch asyncs

echoClient :: String -> Int -> Float -> IORef Int -> IO ()
echoClient host port pingFreq count = do
    h <- connectTo host (PortNumber (fromIntegral port))
    hSetBuffering h LineBuffering
    incRef count
    finally (loop h) (decRef count)
  where
    loop h = do
        hPutStrLn h "PING"
        _ <- hGetLine h
        threadDelay (round $ pingFreq*1000000)
        loop h

watcher :: IORef Int -> IO ()
watcher i = forever $ do
  count <- readIORef i
  putStrLn $ "Clients Connected: " ++ (show count)
  threadDelay (5*1000000)

incRef :: Num a => IORef a -> IO ()
incRef ref = void $ atomicModifyIORef' ref (\x -> (x+1, ()))

decRef :: Num a => IORef a -> IO ()
decRef ref = void $ atomicModifyIORef' ref (\x -> (x-1, ()))
