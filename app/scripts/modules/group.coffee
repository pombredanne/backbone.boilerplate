# Info module
define ["backbone", "underscore", "jquery", "app", "modules/common", "bootstrap"], (Backbone, _, $, app, common)->
  Group = app.module()

  Group.Models.GroupInfoModel = Backbone.Model.extend
    idAttribute: "gid"

    url: ->
      "#{app.api_url}/group/#{@get('gid')}/info?token=#{common.access_token()}&appid=02"

    parse: (data)->
      data["results"]

  Group.Models.SessionModel = Backbone.Model.extend
    idAttribute: "sid"

    running: ->
      @get("status") is "running"

  Group.Models.SessionCollection = Backbone.Collection.extend
    model: Group.Models.SessionModel

    comparator: (model)->
      -model.get("id")

  Group.Models.CycleModel = Backbone.Model.extend
    idAttribute: "cid"
    defaults:
      "livecount": 0

    live: ->
      @get("livecount") > 0

  Group.Models.CycleCollection = Backbone.Collection.extend
    model: Group.Models.CycleModel

    comparator: (model)->
      -model.get("cid")

    url: ->
      "#{app.api_url}/group/#{@gid}/testsummary?token=#{common.access_token()}&appid=02"

    parse: (data)->
      data["results"]

  Group.Views.LayoutView = Backbone.View.extend
    template: "group/layout"

  Group.Views.SessionItemView = Backbone.View.extend
    tagName: "tr"
    template: "group/sessionitem"
    events:
      "click": "select"

    initialize: ->
      @listenTo @model, "change", @render

    select: ->
      app.router.navigate "group/#{@model.get('gid')}/session/#{@model.get('sid')}", trigger: true
      false

    serialize: ->
      @model.toJSON()

    beforeRender: ->
      if @model.running()
        @$el.removeClass().addClass "success"
      else
        @$el.removeClass().addClass "info"

  Group.Views.SessionView = Backbone.View.extend
    template: "group/session"
    events:
      "click #tabs-group ul li a": "switchTab"

    initialize: ->
      @active = null
      @listenTo @collection, "reset", @render

    switchTab: (e)->
      @$(e.currentTarget).tab("show")
      @active = @$(e.currentTarget).attr("href")
      false

    beforeRender: ->
      running = []
      all = []
      @collection.each (model)=>
        running.push new Group.Views.SessionItemView(model: model) if model.running()
        all.push new Group.Views.SessionItemView(model: model)

      @insertViews
        "#panel-running tbody": running
        "#panel-plan tbody": all

    afterRender: ->
      @$(".tabbable ul a[href='#{@active}']").tab("show") if @active

  Group.Views.CycleItemView = Backbone.View.extend
    tagName: "li"
    template: "group/cycleitem"
    events:
      "click": "select"

    serialize: ->#TODO remove redundant data
      @model.toJSON()

    select: ->
      app.layout.getView("#content").getView("#details").collection.reset(@model.get("sessions"))
      false

  Group.Views.CycleView = Backbone.View.extend
    template: "group/cycle"

    initialize: ->
      @listenTo @collection, "add", @addView

    addView: (model, render)->
      selector = if model.live() then "ul#running"  else "ul#stopped"
      view = @insertView selector, new Group.Views.CycleItemView(model: model)
      view.render() if render isnt false

    beforeRender: ->
      @collection.each (model)=>
        @addView model, false

  Group