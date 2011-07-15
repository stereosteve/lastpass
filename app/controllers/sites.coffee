Site = require('models/site')


SiteList = Spine.List.create
  selectFirst: true
  template: (items) ->
    require("views/sites/list")(items)


module.exports = Spine.Controller.create
  
  proxied: ["render", "change"]

  init: ->
    @list = SiteList.init(el: @el)
    @list.bind 'change', @change
    Site.bind 'refresh', @render

  render: ->
    @list.render(Site.all())

  change: (item) ->
    @trigger("change", item)

