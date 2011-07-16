Site = module.exports = Spine.Model.setup("Site", ["name", "url", "username", "password", "notes"])

Site.include({
  validate: ->
    errors = {}
    if not @name
      errors['name'] = 'site name is required'
    if not @url
      errors['url'] = 'site url is required'
    return errors
})
