(function(){window.ext.notification={alias:"noti",_load:function(){return alert("notification")},basic:function(a,b,c){return"chrome"===ext.browser&&chrome.notifications.create("",{iconUrl:c,type:"basic",title:a,message:b},function(){}),"safari"===ext.browser?new Notification(a,{body:b}):void 0}}}).call(this);