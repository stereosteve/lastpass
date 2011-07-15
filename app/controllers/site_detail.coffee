Site = require('models/site')

module.exports = Spine.Controller.create

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
    console.log(data)
    console.log(@current)

  active: (item) ->
    @current = item if item
    @render()

