(function(){window.message="hey",require(["jquery","underscore","extPlugin/uuid","ext","extPlugin/storage","extPlugin/clipboard","extPlugin/extension","extPlugin/notification","extPlugin/tabs"],function(a,b,c,d){return d.ini({silent:!1}),d.menu.icon.setBadge(parseInt(d.storage.get("google"))),d.menu.icon.click(function(){return d.tabs.indexOf("htt*//plus.google.com**",function(a){return 0===a.length?(d.storage.set("google",parseInt(d.storage.get("google"))+1),d.menu.icon.setBadge(d.storage.get("google")),d.tabs.create("https://plus.google.com",!0)):void 0})})})}).call(this);