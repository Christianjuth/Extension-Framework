(function(){window.ext.clipboard={_info:{authors:["Christian Juth"],name:"Clippy",version:"0.1.0",compatibility:{chrome:"full",safari:"none"}},_aliases:["clippy"],write:function(a){var b,c,d;return c=a,d=c,b=$("<input/>"),b.val(c),$("body").append(b),b.select(),document.execCommand("copy"),b.remove(),d},read:function(){var a,b,c;return a="",b="",c=$("<input/>"),$("body").append(c),c.select(),document.execCommand("paste"),b=c.val(),c.remove(),b}}}).call(this);