Site = require('models/site')


SiteList = Spine.Controller.create

  events:
    "click .item": "click"

  proxied:
    ['change']

  init: ->
    @bind('change', @change)

  render: (items) ->
    @el.html('')
    @el.append("<div class='site item' data-id='#{item.id}'><img class='favicon' src='/favicons/#{item.name.toLowerCase()}.png' />#{item.name}</div>") for item in items
    @change(@current)

  change: (item) ->
    return unless item
    @current = item
    @el.children().removeClass('active')
    $(".site[data-id=#{item.id}]").addClass('active')

  click: (e) ->
    id = $(e.target).data('id')
    item = Site.find(id)
    @trigger('change', item)






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

