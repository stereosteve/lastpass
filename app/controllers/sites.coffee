Site = require('models/site')
Group = require('models/group')


SiteList = Spine.List.create
  selectFirst: true
  template: (items) ->
    require("views/sites/list")(items)

GroupList = Spine.List.create
  template: (items) ->
    require("views/sites/group-list")(items)




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
    if errors = @current.validate()
      console.log(errors)
      @showError(error) for error in errors

  showError: (error) ->
    field = error.field
    el = $('.'+field)
    el.addClass('error')
    $('span.error-message', el).text(error.message)


  active: (item) ->
    @current = item if item
    @render()

  

module.exports = Spine.Controller.create
  
  proxied: ["render", "change", "selectGroup"]

  init: ->
    @groups = GroupList.init(el: $('.group-list'))
    @groups.bind 'change', @selectGroup
    Group.bind 'refresh change', @render

    @list = SiteList.init(el: $('.site-list'))
    @list.bind 'change', @change

    Site.bind 'refresh change', @render
    Site.bind 'error', @error

    @detail = SiteDetail.init(el: $('.site-detail'))


  render: ->
    @list.render(Site.sorted())
    @groups.render(Group.all())

  change: (item) ->
    @detail.active(item)

  selectGroup: (item) ->
    sites = Site.filterGroupId(item.id)
    console.log(sites)
    @list.render(sites)

  error: (e) ->
    console.log "ERROR"

