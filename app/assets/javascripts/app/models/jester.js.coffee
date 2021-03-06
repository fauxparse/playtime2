class App.Models.Jester extends Spine.Model
  @configure "Jester", "slug", "name", "email", "phone", "active", "admin", "password", "password_confirmation", "type", "options"
  @extend Spine.Model.Ajax

  url: -> "/jesters/#{@slug}"
  
  toString: -> @name
  
  image: -> @avatar or "/assets/unknown.png"
  
  compare: (b) -> @toString().localeCompare b.toString()

  canEdit: (another) ->
    @admin or @eql(another)

  validate: ->
    errors = {}
    errors.name = "blank" unless @name
    errors.email = "blank" unless @email
    if @password
      unless @password_confirmation is @password
        errors.password = "mismatch"
    else
      delete @password
      delete @password_confirmation
    errors if (k for own k of errors).length

  options: (value) ->
    if value?
      delete value.set
      @_options = value
    @_options or= {}

  @sorted: ->
    all = @all()
    all.sort comparator
    all
  
  @current: (id) ->
    @_current = @exists id if id?
    @_current

  @musos: ->
    musos = (j for j in @all() when j.type is "Muso")
    musos.sort comparator
    musos

comparator = (a, b) ->
  if a.active
    if b.active
      a.compare b
    else
      -1
  else if b.active
    1
  else
    a.compare b