rm -rf public/lastpass/js
mkdir -p public/lastpass/js
curl http://localhost:9294/lastpass/js/libs.js > public/lastpass/js/libs.js
curl http://localhost:9294/lastpass/js/app.js > public/lastpass/js/app.js
