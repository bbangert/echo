============================
Basic Echo Server and Client
============================

This repo demonstrates a small TCP echo server/client in Haskell.

Setting a large amount of client connections with a very small (<1)
ping frequency interval causes memory usage to spike quite highly.

Regularly starting/quitting the echoclient also results in the base
usage of the echoserver to continually rise.
