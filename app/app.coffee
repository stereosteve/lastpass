window.Site = require("models/site")
window.Sites = require("controllers/sites")

module.exports = Spine.Controller.create
  elements:
    "ul#siteList": "sites"
  init: ->
    @sites = Sites.init(el: @sites)

    @sites.bind "change", (item) =>
      console.log('changed')
    
    $.getJSON "fixtures.json", (data) ->
      Site.refresh(data.sites)
      console.log 'sites loaded: ' + Site.count()

