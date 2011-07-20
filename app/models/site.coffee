Site = module.exports = Spine.Model.setup("Site", ["name", "url", "username", "password", "notes"])

Site.extend
  social: ->
    (site for site in Site.all() when site.group == 1)

Site.include
  addError: (field, message) ->
    @errors.push({field: field, message: message})

  validate: ->
    @errors = []
    if not @name
      @addError('name', 'Name is required')
    if not @url
      @addError('url', 'URL is required')
    @errors if @errors.length > 0

