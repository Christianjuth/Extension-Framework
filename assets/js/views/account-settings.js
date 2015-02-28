define(["jquery", "underscore", "mustache", "backbone", "parse", "text!templates/account-settings.html"], function($, _, Mustache, Backbone, Parse, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'click .logout': 'logout'
    },
    render: function() {
      var compiledTemplate, email, user, username;
      user = Parse.User.current();
      username = user.getUsername();
      email = user.getEmail();
      compiledTemplate = Mustache.render(Template, {
        user: username,
        email: email
      });
      this.$el.html(compiledTemplate);
      return $('.loader').fadeOut(100);
    },
    logout: function(e) {
      e.preventDefault();
      Parse.User.logOut();
      return Backbone.history.navigate("account/login", {
        trigger: true
      });
    }
  });
  return View;
});