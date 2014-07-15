====================
gozer - the gozerian
====================

gozer destroys tweets.

Requirements
------------

You will need to create a twitter app, and generate an access token for
your account at twitters developer site.

You may use a pre-compiled release or compile as below with ghc/cabal.

Compiling
---------

1. Checkout this repo
2. Make a cabal sandbox: ``cabal sandbox init``
3. Get the dependencies: ``cabal install --only-dependencies``

.. note::

    For faster dependency installs, newer cabals support ``-j``, ie.:
        ``cabal install -j8 --only-dependencies``

4. Compile: ``cabal build``

You should now have a ``gozer`` binary under ``dist/build/gozer``.

Usage
-----

Create a config file:

.. code-block:: ini

    [DEFAULT]
    access_token = YOUR_TOKEN
    access_token_secret = YOUR_TOKEN_SECRET
    api_key = API_KEY
    api_secret = API_SECRET
    duration = 60       # How old (in days) tweets to delete should be
    username = twitter  # twitter username
    minimum_tweets = 1500 # (Optional) Minimum tweets to retain

Then run it:

.. code-block:: bash

    $ gozer config.ini

Tweets will be deleted.

Why?
----

.. image:: https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Duchamp_Fountaine.jpg/454px-Duchamp_Fountaine.jpg
