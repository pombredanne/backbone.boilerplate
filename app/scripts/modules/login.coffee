# Login module
define ["backbone", "underscore", "jquery", "app", "modules/common", "jquery.cookie", "jquery.md5", "bootstrap"], (Backbone, _, $, app, common)->
  Login = app.module()

  Login.Views.LoginView  = Backbone.View.extend
    template: "login/form"
    events:
      "submit form": "submit"
      "click button.btn": "submit"

    submit: ->
      url = "#{app.api_url}/account/login"

      $.ajax(
        url: url
        type: "POST"
        contentType: "application/json"
        data: JSON.stringify(@form())
        dataType: "json"
      ).done (data) ->
        if "results" of data and "token" of data["results"]
          common.AccessToken.set("access_token", data["results"]["token"])
          # Navigate to main page
          app.router.navigate "", trigger: true
        else
          console.log "Invalid username or password !!!"
          #TODO prompt a warning message.

      false

    form: ->
      username: @$("#inputEmail").val()
      password:$.md5( @$("#inputPassword").val())
      appid: "02"

  Login