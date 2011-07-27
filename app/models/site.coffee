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
    @select (item) ->
      item.search(term)

  current: ->
    @select (site) =>
      return false if @currentSearch and !site.search(@currentSearch)
      return false if @currentGroup and site.group != @currentGroup
      true




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
    "/lastpass/favicons/" + @name.toLowerCase() + ".png"

  search: (term) ->
    pattern = new RegExp(term, 'i')
    pattern.test(@name) or pattern.test(@url)

