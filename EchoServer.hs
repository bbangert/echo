module Main
    (
      main
    ) where

import           Control.Concurrent    (forkFinally)
import           Control.Monad         (forever)
import           Data.ByteString       (hGetLine)
import           Data.ByteString.Char8 (hPutStrLn)
import           Network               (PortID (PortNumber), accept, listenOn,
                                        withSocketsDo)
import           System.IO             (BufferMode (LineBuffering), Handle,
                                        hClose, hSetBuffering)
import           Text.Printf           (printf)

port :: Int
port = 8080

main :: IO ()
main = withSocketsDo $ do
    sock <- listenOn (PortNumber (fromIntegral port))
    printf "Listening on port %d\n" port
    forever $ do
        (handle, _, _) <- accept sock
        forkFinally (echo handle) (\_ -> hClose handle)

echo :: Handle -> IO ()
echo h = do
    hSetBuffering h LineBuffering
    loop
  where
    loop = do
        line <- hGetLine h
        hPutStrLn h line
        loop
