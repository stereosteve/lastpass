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

  elements:
    "#site-search": "siteSearch"
    "#clear-search": "clearSearch"
  
  proxied: ["render", "selectSite", "search", "selectGroup", "showAll"]

  init: ->
    @groups = GroupList.init(el: $('.group-list'))
    @groups.bind 'change', @selectGroup
    Group.bind 'refresh change', @render

    @list = SiteList.init(el: $('.site-list'))
    @list.bind 'change', @selectSite

    Site.bind 'refresh change', @render
    Site.bind 'error', @error

    @detail = SiteDetail.init(el: $('.site-detail'))

    @siteSearch.bind("keyup", @search)
    @clearSearch.bind("click", @showAll)

  showAll: ->
    console.log("show all")
    Site.currentSearch = null
    Site.currentGroup = null
    @render()
    $(".group.item.active").removeClass('active')
    $("#site-search").val('')

  render: ->
    @list.render(Site.current())
    @groups.render(Group.all())

  selectSite: (item) ->
    @detail.active(item)

  search: (ev) ->
    Site.currentSearch = @siteSearch.val()
    @render()

  selectGroup: (group) ->
    Site.currentGroup = group.id
    @render()

  error: (e) ->
    console.log "ERROR"

