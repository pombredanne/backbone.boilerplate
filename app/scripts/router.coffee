# Router.
define ["app"], (app) ->

  # Defining the application router, you can attach sub routers here.
  Router = Backbone.Router.extend(
    routes:
      "": "index"

    index: ->
        app.useLayout('layouts/main').render()
  )
  Router
