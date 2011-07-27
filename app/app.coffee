window.Site = require("models/site")
window.Group = require("models/group")
window.Sites = require("controllers/sites")

module.exports = Spine.Controller.create
  init: ->
    @sites = Sites.init(el: $("#sites"))

    $.getJSON "/lastpass/fixtures.json", (data) ->
      Group.refresh(data.groups)
      Site.refresh(data.sites)
      console.log 'sites loaded: ' + Site.count()

