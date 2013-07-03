# Info module
define ["backbone", "underscore", "jquery", "app", "modules/common", "bootstrap"], (Backbone, _, $, app, common)->
  Group = app.module()

  Group.Models.GroupInfoModel = Backbone.Model.extend
    initialize: ->

    idAttribute: "gid"

    url: ->
      "#{app.api_url}/group/#{@get('gid')}/info?token=#{common.access_token()}&appid=02"

    parse: (data)->
      data["results"]

  Group.Models.SessionModel = Backbone.Model.extend
    initialize: ->

    idAttribute: "sid"

    running: ->
      @get("endtime") is "N/A"

  Group.Models.SessionCollection = Backbone.Collection.extend
    initialize: (models, options)-> # Must pass gid in param 'options'
      @gid = options.gid

    model: Group.Models.SessionModel

    comparator: (model)->
      -model.get("id")

    url: ->
      "#{app.api_url}/group/#{@gid}/testsummary?token=#{common.access_token()}&appid=02"

    parse: (data)->
      data["results"]["sessions"]

  Group.Views.LayoutView = Backbone.View.extend
    template: "group/layout"

  Group.Views.SessionItemView = Backbone.View.extend
    tagName: "tr"
    template: "group/sessionitem"

    initialize: ->
      @listenTo @model, "change", @render

    serialize: ->
      @model.toJSON()

    beforeRender: ->
      switch @model.get("endtime")
        when "N/A" then @$el.removeClass().addClass "success"
        when "idle" then @$el.removeClass().addClass "error"
        else @$el.removeClass().addClass "info"

  Group.Views.SessionView = Backbone.View.extend
    template: "group/session"

    initialize: ->
      @listenTo @collection, "sync", @render

    events:
      "click #tabs-group ul a": "switchTab"

    switchTab: (e)->
      @$(e.currentTarget).tab("show")
      false

    beforeRender: ->
      running = []
      all = []
      @collection.each (model)=>
        if model.running()
          running.push new Group.Views.SessionItemView(model: model)
        all.push new Group.Views.SessionItemView(model: model)


      @insertViews
        "#panel-running tbody": running
        "#panel-plan tbody": all

  Group