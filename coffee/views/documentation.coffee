define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "highlight",
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Parse, hljs, Err) ->


  View = Backbone.View.extend {
    el: $('.content'),

    render: (file) ->

      #Using Underscore we can compile our template with data
      data = {}
      Template = ""

      $.ajax {
        type: "GET",
        url: "//ext-js.org/templates/docs/" + file + ".html"
        async: false,
        success : (data) ->
          Template = data
        error : ->
          Template = Err
      }

      if /^(<html>|<body>|<!doctype)/i.test(Template)
        Template = Err

      compiledTemplate = Mustache.render( Template , {})
      this.$el.html( compiledTemplate )

      if window.innerWidth < 850
        $(".sidebar .links").slideUp()
        $(".sidebar").attr "toggle","false"

      $('pre > code').each (i, block) ->
        hljs.highlightBlock(block)

      $('.loader').fadeOut(100)

  }

  #Our module now returns our view
  return View;