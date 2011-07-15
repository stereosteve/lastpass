Site = require('models/site')

module.exports = Spine.Controller.create

  proxied: ['render']

  events:
    "submit form.site": "onSubmit"
  
  init: ->
    @render()

  render: ->
    html = require("views/sites/form")(@item)
    @el.html(html)

  onSubmit: (e) ->
    e.preventDefault()
    data = $("form.site").serializeForm()
    @item.updateAttributes(data)
    console.log(data)
    console.log(@item)

