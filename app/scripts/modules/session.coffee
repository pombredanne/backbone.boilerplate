define ["backbone", "underscore", "jquery", "app", "modules/common", "bootstrap"], (Backbone, _, $, app, common)->
  Session = app.module()

  Session.Models.TestModel = Backbone.Model.extend
    idAttribute: "tid"

  Session.Models.TestCollection = Backbone.Collection.extend
    model: Session.Models.TestModel

    url: ->
      "#{app.api_url}/group/#{@gid}/test/#{@sid}/history?token=#{common.access_token()}&type=total&appid=02"

    parse: (data)->
      data["results"]["cases"]

  Session.Views.LayoutView = Backbone.View.extend
    template: "session/layout"

  Session.Views.TestView = Backbone.View.extend
    template: "session/test"

    initialize: ->
      @listenTo @collection, "sync reset", @render

    beforeRender: ->
      views = []
      @collection.each (model)=>
        views.push new Session.Views.TestItemView(model: model)
      @insertViews "table tbody": views

  Session.Views.TestItemView = Backbone.View.extend
    tagName: "tr"
    template: "session/testitem"
    events:
      "click": "select"

    select: ->
      console.log "#{JSON.stringify(@model.toJSON())}"

    serialize: ->
      @model.toJSON()

    beforeRender: ->
      @$el.addClass(if @model.get("result") is "pass" then "success" else "error")

  Session.Views.SidebarView = Backbone.View.extend
    template: "session/sidebar"

    events:
      "click li": "click"

    click: (e)->
      e.preventDefault()
      @$(e.currentTarget).addClass "active"
      false

  Session