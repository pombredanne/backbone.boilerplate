# Router.
define ["app", "modules/common", "modules/login", "modules/user", "modules/group"], (app, common, login, user, group) ->

  # Defining the application router, you can attach sub routers here.
  Router = Backbone.Router.extend
    routes:
      "": "index"
      "login": "login"
      "logout": "logout"
      "group/:gid": "group"

    index: ->
      layout = app.useLayout 'layouts/main'
      layout.setViews
        "#navbar": new common.Views.NavbarView()
        "#content": new user.Views.LayoutView
          views:
            "#details": new user.Views.GroupView()
      layout.render()

    login: ->
      layout = app.useLayout 'layouts/main'
      layout.setViews
        "#navbar": new common.Views.NavbarView()
        "#content": new login.Views.LoginView()
      layout.render()

    logout: ->
      common.logout()

    group: (gid)->
      CycleCollection = group.Models.CycleCollection.extend gid: gid
      collection = new CycleCollection()
      collection.fetch()
      layout = app.useLayout 'layouts/main'
      layout.setViews
        "#navbar": new common.Views.NavbarView()
        "#content": new group.Views.LayoutView
          views:
            "#sidebar": new group.Views.CycleView(collection: collection)
            "#details": new group.Views.SessionView(collection: new group.Models.SessionCollection([]))

      layout.render()

  Router
