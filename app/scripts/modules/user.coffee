# Info module
define ["backbone", "underscore", "jquery", "app", "modules/common", "jquery.cookie", "jquery.md5", "bootstrap"], (Backbone, _, $, app, common)->
  User = app.module()

  User.Views.GroupItemView = Backbone.View.extend
    template: "user/groupitem"

    tagName: "tr"

    events:
      "click a#group_delete": "delGroup"
      "click": "showGroup"

    serialize: ->
      @model.toJSON()

    delGroup: ->
      console.log "delete group #{@model.get('gid')}"
      false

    showGroup: ->
      app.router.navigate "group/#{@model.get('gid')}", trigger: true
      false

  User.Views.GroupView = Backbone.View.extend
    initialize: ->
      @.listenTo common.UserInfo, "change:inGroups", @render

    template: "user/group"

    events:
      "click #tabs-group ul a": "switchTab"

    switchTab: (e)->
      @$(e.currentTarget).tab("show")
      false

    beforeRender: ->
      if common.UserInfo.has("inGroups")
        for item in common.UserInfo.get("inGroups")
          model = new Backbone.Model(item)
          @insertView "#panel-group tbody", new User.Views.GroupItemView(model: model)

  User.Views.LayoutView = Backbone.View.extend
    template: "user/layout"


  User