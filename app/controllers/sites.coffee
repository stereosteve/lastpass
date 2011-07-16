Site = require('models/site')


SiteList = Spine.List.create
  selectFirst: true
  template: (items) ->
    require("views/sites/list")(items)



SiteDetail = Spine.Controller.create
  proxied: ['render']

  events:
    "submit form.site": "onSubmit"
  
  init: ->
    @render()

  render: ->
    return unless @current
    html = require("views/sites/form")(@current)
    @el.html(html)

  onSubmit: (e) ->
    e.preventDefault()
    return unless @current
    data = $("form.site").serializeForm()
    @current.updateAttributes(data)
    errors = @current.validate()
    console.log(errors)
    #console.log(data)
    #console.log(@current)

  active: (item) ->
    @current = item if item
    @render()


module.exports = Spine.Controller.create
  
  proxied: ["render", "change"]

  init: ->
    @list = SiteList.init(el: $('.site-list'))
    @list.bind 'change', @change
    Site.bind 'refresh change', @render
    Site.bind 'error', @error

    @detail = SiteDetail.init(el: $('.site-detail'))


  render: ->
    @list.render(Site.all())

  change: (item) ->
    @detail.active(item)

  error: (e) ->
    console.log "ERROR"

