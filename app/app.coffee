window.Site = require("models/site")
window.Sites = require("controllers/sites")
window.SiteDetail = require("controllers/site_detail")

module.exports = Spine.Controller.create
  elements:
    "ul#siteList": "sites"
  init: ->
    @sites = Sites.init(el: @sites)

    @sites.bind "change", (item) =>
      @siteDetail = SiteDetail.init(el: $("#site-detail"), item: item)
      console.log('changed')
    
    $.getJSON "fixtures.json", (data) ->
      Site.refresh(data.sites)
      console.log 'sites loaded: ' + Site.count()

