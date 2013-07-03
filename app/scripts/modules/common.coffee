define ["backbone", "underscore", "jquery", "app", "jquery.cookie", "jquery.md5", "bootstrap"], (Backbone, _, $, app)->
  Token = Backbone.Model.extend
    initialize: ->
      @on "change:access_token", @tokenChanged, @

    defaults:
      "access_token": null

    tokenChanged: ->
      if @.has("access_token")
        $.cookie('access_token', @.get("access_token"))
      else
        $.removeCookie("access_token")

  Common = app.module
    AccessToken: new Token("access_token": $.cookie('access_token'))

    access_token: ->
      @AccessToken.get("access_token")

    logined: ->
      @AccessToken.has("access_token")

    logout: ->
      @AccessToken.clear()
      app.router.navigate "login",
        trigger: true
        replace: true

  UserInfo = Backbone.Model.extend
    initialize: ->
      @listenTo Common.AccessToken, "change", @tokenChanged
      if Common.logined()
        @tokenChanged()

    idAttribute: 'uid'

    defaults:
      "username": null

    url: ->
      "#{app.api_url}/account/info?token=#{Common.access_token()}&appid=02"

    parse: (data)->
      data["results"]

    tokenChanged: ->
      if Common.logined() then @fetch() else @clear()

  Common.UserInfo = new UserInfo()

  Common.Views.NavbarView = Backbone.View.extend
    template: "common/navbar"

    initialize: ->
      @listenTo Common.UserInfo, "change:username", @render

    serialize: ->
      if Common.UserInfo.has("username")
        "username": Common.UserInfo.get("username")
      else
        "username": "Guest"

    beforeRender: ->

  Common