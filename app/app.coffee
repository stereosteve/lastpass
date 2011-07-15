window.Site = require("models/site")
window.Sites = require("controllers/sites")
window.SiteDetail = require("controllers/site_detail")

module.exports = Spine.Controller.create
  elements:
    "ul#siteList": "sites"
  init: ->
    @sites = Sites.init(el: @sites)
    @detail = SiteDetail.init(el: $("#site-detail"))

    @sites.bind "detail", (item) =>
      @detail.active(item)
    
    $.getJSON "fixtures.json", (data) ->
      Site.refresh(data.sites)
      console.log 'sites loaded: ' + Site.count()

