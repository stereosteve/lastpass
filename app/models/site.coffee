Site = module.exports = Spine.Model.setup("Site", ["name", "url", "username", "password", "notes"])

Site.extend

  sorted: ->
    @all().sort (a, b) ->
      return 1 if a.name > b.name
      return -1 if b.name < a.name
      return 0

  select: (callback) ->
    (item for item in @sorted() when callback(item))

  filterGroupId: (id) ->
    @select (item) ->
      item.group == id

  search: (term) ->
    pattern = new RegExp(term, 'i')
    @select (item) ->
      pattern.test(item.name) or pattern.test(item.url) or pattern.test(item.username)



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

  favicon: ->
    "/favicons/" + @name.toLowerCase() + ".png"
