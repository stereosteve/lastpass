window.Site = require("models/site")
window.Sites = require("controllers/sites")

module.exports = Spine.Controller.create
  init: ->
    @sites = Sites.init(el: $("#sites"))

    $.getJSON "fixtures.json", (data) ->
      Site.refresh(data.sites)
      console.log 'sites loaded: ' + Site.count()

