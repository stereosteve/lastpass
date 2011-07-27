# Lastpass

This is a design project to build a new javascript client for the 
"lastpass":http://www.lastpass.com service.  It is a sideproject of mine,
not affiliated with lastpass.

This was an exercise to learn coffeescript and spine, which is very siilar
to backbone.js.  I worked on this while reading:

* "JavaScript web applications":http://oreilly.com/catalog/0636920018421
* "JavaScript the good parts":http://oreilly.com/catalog/9780596517748/

## Status

Right now it is just a static HTML + CSS + JS client UI.  The real lastpass client
encryptes the records client-side before sending them to the lastpass server.

The next step is to create a simple server to store encrypted records, and
adapt the spine.ajax code to encrypt records before sending to server.

## Demo

http://stereosteve.github.com/lastpass/

## To Run

    cd lastpass
    npm install
    node index.js
