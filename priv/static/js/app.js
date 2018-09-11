!function(){"use strict";var e="undefined"==typeof global?self:global;if("function"!=typeof e.require){var n={},t={},i={},o={}.hasOwnProperty,r=/^\.\.?(\/|$)/,s=function(e,n){for(var t,i=[],o=(r.test(n)?e+"/"+n:n).split("/"),s=0,a=o.length;s<a;s++)t=o[s],".."===t?i.pop():"."!==t&&""!==t&&i.push(t);return i.join("/")},a=function(e){return e.split("/").slice(0,-1).join("/")},c=function(n){return function(t){var i=s(a(n),t);return e.require(i,n)}},u=function(e,n){var i=m&&m.createHot(e),o={id:e,exports:{},hot:i};return t[e]=o,n(o.exports,c(e),o),o.exports},l=function(e){return i[e]?l(i[e]):e},h=function(e,n){return l(s(a(e),n))},f=function(e,i){null==i&&(i="/");var r=l(e);if(o.call(t,r))return t[r].exports;if(o.call(n,r))return u(r,n[r]);throw new Error("Cannot find module '"+e+"' from '"+i+"'")};f.alias=function(e,n){i[n]=e};var d=/\.[^.\/]+$/,p=/\/index(\.[^\/]+)?$/,v=function(e){if(d.test(e)){var n=e.replace(d,"");o.call(i,n)&&i[n].replace(d,"")!==n+"/index"||(i[n]=e)}if(p.test(e)){var t=e.replace(p,"");o.call(i,t)||(i[t]=e)}};f.register=f.define=function(e,i){if(e&&"object"==typeof e)for(var r in e)o.call(e,r)&&f.register(r,e[r]);else n[e]=i,delete t[e],v(e)},f.list=function(){var e=[];for(var t in n)o.call(n,t)&&e.push(t);return e};var m=e._hmr&&new e._hmr(h,f,n,t);f._cache=t,f.hmr=m&&m.wrap,f.brunch=!0,e.require=f}}(),function(){var e=("undefined"==typeof window?this:window,function(e,n,t){var i={},o=function(n,t){var r;try{return r=e(t+"/node_modules/"+n)}catch(s){if(s.toString().indexOf("Cannot find module")===-1)throw s;if(t.indexOf("node_modules")!==-1){var a=t.split("/"),c=a.lastIndexOf("node_modules"),u=a.slice(0,c).join("/");return o(n,u)}}return i};return function(r){if(r in n&&(r=n[r]),r){if("."!==r[0]&&t){var s=o(r,t);if(s!==i)return s}return e(r)}}});require.register("phoenix/priv/static/phoenix.js",function(n,t,i){t=e(t,{},"phoenix"),function(){!function(e,t){"object"==typeof n?t(n):"function"==typeof define&&define.amd?define(["exports"],t):t(e.Phoenix=e.Phoenix||{})}(this,function(e){"use strict";function n(e){if(Array.isArray(e)){for(var n=0,t=Array(e.length);n<e.length;n++)t[n]=e[n];return t}return Array.from(e)}function t(e,n){if(!(e instanceof n))throw new TypeError("Cannot call a class as a function")}Object.defineProperty(e,"__esModule",{value:!0});var i="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},o=function(){function e(e,n){var t=[],i=!0,o=!1,r=void 0;try{for(var s,a=e[Symbol.iterator]();!(i=(s=a.next()).done)&&(t.push(s.value),!n||t.length!==n);i=!0);}catch(c){o=!0,r=c}finally{try{!i&&a["return"]&&a["return"]()}finally{if(o)throw r}}return t}return function(n,t){if(Array.isArray(n))return n;if(Symbol.iterator in Object(n))return e(n,t);throw new TypeError("Invalid attempt to destructure non-iterable instance")}}(),r=function(){function e(e,n){for(var t=0;t<n.length;t++){var i=n[t];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(e,i.key,i)}}return function(n,t,i){return t&&e(n.prototype,t),i&&e(n,i),n}}(),s="2.0.0",a={connecting:0,open:1,closing:2,closed:3},c=1e4,u=1e3,l={closed:"closed",errored:"errored",joined:"joined",joining:"joining",leaving:"leaving"},h={close:"phx_close",error:"phx_error",join:"phx_join",reply:"phx_reply",leave:"phx_leave"},f=[h.close,h.error,h.join,h.reply,h.leave],d={longpoll:"longpoll",websocket:"websocket"},p=function(){function e(n,i,o,r){t(this,e),this.channel=n,this.event=i,this.payload=o||{},this.receivedResp=null,this.timeout=r,this.timeoutTimer=null,this.recHooks=[],this.sent=!1}return r(e,[{key:"resend",value:function(e){this.timeout=e,this.reset(),this.send()}},{key:"send",value:function(){this.hasReceived("timeout")||(this.startTimeout(),this.sent=!0,this.channel.socket.push({topic:this.channel.topic,event:this.event,payload:this.payload,ref:this.ref,join_ref:this.channel.joinRef()}))}},{key:"receive",value:function(e,n){return this.hasReceived(e)&&n(this.receivedResp.response),this.recHooks.push({status:e,callback:n}),this}},{key:"reset",value:function(){this.cancelRefEvent(),this.ref=null,this.refEvent=null,this.receivedResp=null,this.sent=!1}},{key:"matchReceive",value:function(e){var n=e.status,t=e.response;e.ref;this.recHooks.filter(function(e){return e.status===n}).forEach(function(e){return e.callback(t)})}},{key:"cancelRefEvent",value:function(){this.refEvent&&this.channel.off(this.refEvent)}},{key:"cancelTimeout",value:function(){clearTimeout(this.timeoutTimer),this.timeoutTimer=null}},{key:"startTimeout",value:function(){var e=this;this.timeoutTimer&&this.cancelTimeout(),this.ref=this.channel.socket.makeRef(),this.refEvent=this.channel.replyEventName(this.ref),this.channel.on(this.refEvent,function(n){e.cancelRefEvent(),e.cancelTimeout(),e.receivedResp=n,e.matchReceive(n)}),this.timeoutTimer=setTimeout(function(){e.trigger("timeout",{})},this.timeout)}},{key:"hasReceived",value:function(e){return this.receivedResp&&this.receivedResp.status===e}},{key:"trigger",value:function(e,n){this.channel.trigger(this.refEvent,{status:e,response:n})}}]),e}(),v=e.Channel=function(){function e(n,i,o){var r=this;t(this,e),this.state=l.closed,this.topic=n,this.params=i||{},this.socket=o,this.bindings=[],this.timeout=this.socket.timeout,this.joinedOnce=!1,this.joinPush=new p(this,h.join,this.params,this.timeout),this.pushBuffer=[],this.rejoinTimer=new k(function(){return r.rejoinUntilConnected()},this.socket.reconnectAfterMs),this.joinPush.receive("ok",function(){r.state=l.joined,r.rejoinTimer.reset(),r.pushBuffer.forEach(function(e){return e.send()}),r.pushBuffer=[]}),this.onClose(function(){r.rejoinTimer.reset(),r.socket.log("channel","close "+r.topic+" "+r.joinRef()),r.state=l.closed,r.socket.remove(r)}),this.onError(function(e){r.isLeaving()||r.isClosed()||(r.socket.log("channel","error "+r.topic,e),r.state=l.errored,r.rejoinTimer.scheduleTimeout())}),this.joinPush.receive("timeout",function(){if(r.isJoining()){r.socket.log("channel","timeout "+r.topic+" ("+r.joinRef()+")",r.joinPush.timeout);var e=new p(r,h.leave,{},r.timeout);e.send(),r.state=l.errored,r.joinPush.reset(),r.rejoinTimer.scheduleTimeout()}}),this.on(h.reply,function(e,n){r.trigger(r.replyEventName(n),e)})}return r(e,[{key:"rejoinUntilConnected",value:function(){this.rejoinTimer.scheduleTimeout(),this.socket.isConnected()&&this.rejoin()}},{key:"join",value:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:this.timeout;if(this.joinedOnce)throw"tried to join multiple times. 'join' can only be called a single time per channel instance";return this.joinedOnce=!0,this.rejoin(e),this.joinPush}},{key:"onClose",value:function(e){this.on(h.close,e)}},{key:"onError",value:function(e){this.on(h.error,function(n){return e(n)})}},{key:"on",value:function(e,n){this.bindings.push({event:e,callback:n})}},{key:"off",value:function(e){this.bindings=this.bindings.filter(function(n){return n.event!==e})}},{key:"canPush",value:function(){return this.socket.isConnected()&&this.isJoined()}},{key:"push",value:function(e,n){var t=arguments.length>2&&void 0!==arguments[2]?arguments[2]:this.timeout;if(!this.joinedOnce)throw"tried to push '"+e+"' to '"+this.topic+"' before joining. Use channel.join() before pushing events";var i=new p(this,e,n,t);return this.canPush()?i.send():(i.startTimeout(),this.pushBuffer.push(i)),i}},{key:"leave",value:function(){var e=this,n=arguments.length>0&&void 0!==arguments[0]?arguments[0]:this.timeout;this.state=l.leaving;var t=function(){e.socket.log("channel","leave "+e.topic),e.trigger(h.close,"leave")},i=new p(this,h.leave,{},n);return i.receive("ok",function(){return t()}).receive("timeout",function(){return t()}),i.send(),this.canPush()||i.trigger("ok",{}),i}},{key:"onMessage",value:function(e,n,t){return n}},{key:"isMember",value:function(e,n,t,i){if(this.topic!==e)return!1;var o=f.indexOf(n)>=0;return!i||!o||i===this.joinRef()||(this.socket.log("channel","dropping outdated message",{topic:e,event:n,payload:t,joinRef:i}),!1)}},{key:"joinRef",value:function(){return this.joinPush.ref}},{key:"sendJoin",value:function(e){this.state=l.joining,this.joinPush.resend(e)}},{key:"rejoin",value:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:this.timeout;this.isLeaving()||this.sendJoin(e)}},{key:"trigger",value:function(e,n,t,i){var o=this,r=this.onMessage(e,n,t,i);if(n&&!r)throw"channel onMessage callbacks must return the payload, modified or unmodified";this.bindings.filter(function(n){return n.event===e}).map(function(e){return e.callback(r,t,i||o.joinRef())})}},{key:"replyEventName",value:function(e){return"chan_reply_"+e}},{key:"isClosed",value:function(){return this.state===l.closed}},{key:"isErrored",value:function(){return this.state===l.errored}},{key:"isJoined",value:function(){return this.state===l.joined}},{key:"isJoining",value:function(){return this.state===l.joining}},{key:"isLeaving",value:function(){return this.state===l.leaving}}]),e}(),m={encode:function(e,n){var t=[e.join_ref,e.ref,e.topic,e.event,e.payload];return n(JSON.stringify(t))},decode:function(e,n){var t=JSON.parse(e),i=o(t,5),r=i[0],s=i[1],a=i[2],c=i[3],u=i[4];return n({join_ref:r,ref:s,topic:a,event:c,payload:u})}},y=(e.Socket=function(){function e(n){var i=this,o=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};t(this,e),this.stateChangeCallbacks={open:[],close:[],error:[],message:[]},this.channels=[],this.sendBuffer=[],this.ref=0,this.timeout=o.timeout||c,this.transport=o.transport||window.WebSocket||y,this.defaultEncoder=m.encode,this.defaultDecoder=m.decode,this.transport!==y?(this.encode=o.encode||this.defaultEncoder,this.decode=o.decode||this.defaultDecoder):(this.encode=this.defaultEncoder,this.decode=this.defaultDecoder),this.heartbeatIntervalMs=o.heartbeatIntervalMs||3e4,this.reconnectAfterMs=o.reconnectAfterMs||function(e){return[1e3,2e3,5e3,1e4][e-1]||1e4},this.logger=o.logger||function(){},this.longpollerTimeout=o.longpollerTimeout||2e4,this.params=o.params||{},this.endPoint=n+"/"+d.websocket,this.heartbeatTimer=null,this.pendingHeartbeatRef=null,this.reconnectTimer=new k(function(){i.disconnect(function(){return i.connect()})},this.reconnectAfterMs)}return r(e,[{key:"protocol",value:function(){return location.protocol.match(/^https/)?"wss":"ws"}},{key:"endPointURL",value:function(){var e=g.appendParams(g.appendParams(this.endPoint,this.params),{vsn:s});return"/"!==e.charAt(0)?e:"/"===e.charAt(1)?this.protocol()+":"+e:this.protocol()+"://"+location.host+e}},{key:"disconnect",value:function(e,n,t){this.conn&&(this.conn.onclose=function(){},n?this.conn.close(n,t||""):this.conn.close(),this.conn=null),e&&e()}},{key:"connect",value:function(e){var n=this;e&&(console&&console.log("passing params to connect is deprecated. Instead pass :params to the Socket constructor"),this.params=e),this.conn||(this.conn=new this.transport(this.endPointURL()),this.conn.timeout=this.longpollerTimeout,this.conn.onopen=function(){return n.onConnOpen()},this.conn.onerror=function(e){return n.onConnError(e)},this.conn.onmessage=function(e){return n.onConnMessage(e)},this.conn.onclose=function(e){return n.onConnClose(e)})}},{key:"log",value:function(e,n,t){this.logger(e,n,t)}},{key:"onOpen",value:function(e){this.stateChangeCallbacks.open.push(e)}},{key:"onClose",value:function(e){this.stateChangeCallbacks.close.push(e)}},{key:"onError",value:function(e){this.stateChangeCallbacks.error.push(e)}},{key:"onMessage",value:function(e){this.stateChangeCallbacks.message.push(e)}},{key:"onConnOpen",value:function(){var e=this;this.log("transport","connected to "+this.endPointURL()),this.flushSendBuffer(),this.reconnectTimer.reset(),this.conn.skipHeartbeat||(clearInterval(this.heartbeatTimer),this.heartbeatTimer=setInterval(function(){return e.sendHeartbeat()},this.heartbeatIntervalMs)),this.stateChangeCallbacks.open.forEach(function(e){return e()})}},{key:"onConnClose",value:function(e){this.log("transport","close",e),this.triggerChanError(),clearInterval(this.heartbeatTimer),this.reconnectTimer.scheduleTimeout(),this.stateChangeCallbacks.close.forEach(function(n){return n(e)})}},{key:"onConnError",value:function(e){this.log("transport",e),this.triggerChanError(),this.stateChangeCallbacks.error.forEach(function(n){return n(e)})}},{key:"triggerChanError",value:function(){this.channels.forEach(function(e){return e.trigger(h.error)})}},{key:"connectionState",value:function(){switch(this.conn&&this.conn.readyState){case a.connecting:return"connecting";case a.open:return"open";case a.closing:return"closing";default:return"closed"}}},{key:"isConnected",value:function(){return"open"===this.connectionState()}},{key:"remove",value:function(e){this.channels=this.channels.filter(function(n){return n.joinRef()!==e.joinRef()})}},{key:"channel",value:function(e){var n=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{},t=new v(e,n,this);return this.channels.push(t),t}},{key:"push",value:function(e){var n=this,t=e.topic,i=e.event,o=e.payload,r=e.ref,s=e.join_ref,a=function(){n.encode(e,function(e){n.conn.send(e)})};this.log("push",t+" "+i+" ("+s+", "+r+")",o),this.isConnected()?a():this.sendBuffer.push(a)}},{key:"makeRef",value:function(){var e=this.ref+1;return e===this.ref?this.ref=0:this.ref=e,this.ref.toString()}},{key:"sendHeartbeat",value:function(){if(this.isConnected()){if(this.pendingHeartbeatRef)return this.pendingHeartbeatRef=null,this.log("transport","heartbeat timeout. Attempting to re-establish connection"),void this.conn.close(u,"hearbeat timeout");this.pendingHeartbeatRef=this.makeRef(),this.push({topic:"phoenix",event:"heartbeat",payload:{},ref:this.pendingHeartbeatRef})}}},{key:"flushSendBuffer",value:function(){this.isConnected()&&this.sendBuffer.length>0&&(this.sendBuffer.forEach(function(e){return e()}),this.sendBuffer=[])}},{key:"onConnMessage",value:function(e){var n=this;this.decode(e.data,function(e){var t=e.topic,i=e.event,o=e.payload,r=e.ref,s=e.join_ref;r&&r===n.pendingHeartbeatRef&&(n.pendingHeartbeatRef=null),n.log("receive",(o.status||"")+" "+t+" "+i+" "+(r&&"("+r+")"||""),o),n.channels.filter(function(e){return e.isMember(t,i,o,s)}).forEach(function(e){return e.trigger(i,o,r,s)}),n.stateChangeCallbacks.message.forEach(function(n){return n(e)})})}}]),e}(),e.LongPoll=function(){function e(n){t(this,e),this.endPoint=null,this.token=null,this.skipHeartbeat=!0,this.onopen=function(){},this.onerror=function(){},this.onmessage=function(){},this.onclose=function(){},this.pollEndpoint=this.normalizeEndpoint(n),this.readyState=a.connecting,this.poll()}return r(e,[{key:"normalizeEndpoint",value:function(e){return e.replace("ws://","http://").replace("wss://","https://").replace(new RegExp("(.*)/"+d.websocket),"$1/"+d.longpoll)}},{key:"endpointURL",value:function(){return g.appendParams(this.pollEndpoint,{token:this.token})}},{key:"closeAndRetry",value:function(){this.close(),this.readyState=a.connecting}},{key:"ontimeout",value:function(){this.onerror("timeout"),this.closeAndRetry()}},{key:"poll",value:function(){var e=this;this.readyState!==a.open&&this.readyState!==a.connecting||g.request("GET",this.endpointURL(),"application/json",null,this.timeout,this.ontimeout.bind(this),function(n){if(n){var t=n.status,i=n.token,o=n.messages;e.token=i}else var t=0;switch(t){case 200:o.forEach(function(n){return e.onmessage({data:n})}),e.poll();break;case 204:e.poll();break;case 410:e.readyState=a.open,e.onopen(),e.poll();break;case 0:case 500:e.onerror(),e.closeAndRetry();break;default:throw"unhandled poll status "+t}})}},{key:"send",value:function(e){var n=this;g.request("POST",this.endpointURL(),"application/json",e,this.timeout,this.onerror.bind(this,"timeout"),function(e){e&&200===e.status||(n.onerror(e&&e.status),n.closeAndRetry())})}},{key:"close",value:function(e,n){this.readyState=a.closed,this.onclose()}}]),e}()),g=e.Ajax=function(){function e(){t(this,e)}return r(e,null,[{key:"request",value:function(e,n,t,i,o,r,s){if(window.XDomainRequest){var a=new XDomainRequest;this.xdomainRequest(a,e,n,i,o,r,s)}else{var c=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("Microsoft.XMLHTTP");this.xhrRequest(c,e,n,t,i,o,r,s)}}},{key:"xdomainRequest",value:function(e,n,t,i,o,r,s){var a=this;e.timeout=o,e.open(n,t),e.onload=function(){var n=a.parseJSON(e.responseText);s&&s(n)},r&&(e.ontimeout=r),e.onprogress=function(){},e.send(i)}},{key:"xhrRequest",value:function(e,n,t,i,o,r,s,a){var c=this;e.open(n,t,!0),e.timeout=r,e.setRequestHeader("Content-Type",i),e.onerror=function(){a&&a(null)},e.onreadystatechange=function(){if(e.readyState===c.states.complete&&a){var n=c.parseJSON(e.responseText);a(n)}},s&&(e.ontimeout=s),e.send(o)}},{key:"parseJSON",value:function(e){if(!e||""===e)return null;try{return JSON.parse(e)}catch(n){return console&&console.log("failed to parse JSON response",e),null}}},{key:"serialize",value:function(e,n){var t=[];for(var o in e)if(e.hasOwnProperty(o)){var r=n?n+"["+o+"]":o,s=e[o];"object"===("undefined"==typeof s?"undefined":i(s))?t.push(this.serialize(s,r)):t.push(encodeURIComponent(r)+"="+encodeURIComponent(s))}return t.join("&")}},{key:"appendParams",value:function(e,n){if(0===Object.keys(n).length)return e;var t=e.match(/\?/)?"&":"?";return""+e+t+this.serialize(n)}}]),e}();g.states={complete:4};var k=(e.Presence={syncState:function(e,n,t,i){var o=this,r=this.clone(e),s={},a={};return this.map(r,function(e,t){n[e]||(a[e]=t)}),this.map(n,function(e,n){var t=r[e];if(t){var i=n.metas.map(function(e){return e.phx_ref}),c=t.metas.map(function(e){return e.phx_ref}),u=n.metas.filter(function(e){return c.indexOf(e.phx_ref)<0}),l=t.metas.filter(function(e){return i.indexOf(e.phx_ref)<0});u.length>0&&(s[e]=n,s[e].metas=u),l.length>0&&(a[e]=o.clone(t),a[e].metas=l)}else s[e]=n}),this.syncDiff(r,{joins:s,leaves:a},t,i)},syncDiff:function(e,t,i,o){var r=t.joins,s=t.leaves,a=this.clone(e);return i||(i=function(){}),o||(o=function(){}),this.map(r,function(e,t){var o=a[e];if(a[e]=t,o){var r;(r=a[e].metas).unshift.apply(r,n(o.metas))}i(e,o,t)}),this.map(s,function(e,n){var t=a[e];if(t){var i=n.metas.map(function(e){return e.phx_ref});t.metas=t.metas.filter(function(e){return i.indexOf(e.phx_ref)<0}),o(e,t,n),0===t.metas.length&&delete a[e]}}),a},list:function(e,n){return n||(n=function(e,n){return n}),this.map(e,function(e,t){return n(e,t)})},map:function(e,n){return Object.getOwnPropertyNames(e).map(function(t){return n(t,e[t])})},clone:function(e){return JSON.parse(JSON.stringify(e))}},function(){function e(n,i){t(this,e),this.callback=n,this.timerCalc=i,this.timer=null,this.tries=0}return r(e,[{key:"reset",value:function(){this.tries=0,clearTimeout(this.timer)}},{key:"scheduleTimeout",value:function(){var e=this;clearTimeout(this.timer),this.timer=setTimeout(function(){e.tries=e.tries+1,e.callback()},this.timerCalc(this.tries+1))}}]),e}())})}()}),require.register("phoenix_html/priv/static/phoenix_html.js",function(n,t,i){t=e(t,{},"phoenix_html"),function(){"use strict";!function(){function e(){function e(e,n){n=n||{bubbles:!1,cancelable:!1,detail:void 0};var t=document.createEvent("CustomEvent");return t.initCustomEvent(e,n.bubbles,n.cancelable,n.detail),t}return"function"==typeof window.CustomEvent?window.CustomEvent:(e.prototype=window.Event.prototype,e)}function n(e,n){var t=document.createElement("input");return t.type="hidden",t.name=e,t.value=n,t}function t(e){var t=e.getAttribute("data-to"),i=n("_method",e.getAttribute("data-method")),o=n("_csrf_token",e.getAttribute("data-csrf")),r=document.createElement("form"),s=e.getAttribute("target");r.method="get"===e.getAttribute("data-method")?"get":"post",r.action=t,r.style.display="hidden",s&&(r.target=s),r.appendChild(o),r.appendChild(i),document.body.appendChild(r),r.submit()}var i=e();window.addEventListener("click",function(e){for(var n=e.target;n&&n.getAttribute;){var o=new i("phoenix.link.click",{bubbles:!0,cancelable:!0});if(!n.dispatchEvent(o))return e.preventDefault(),!1;if(n.getAttribute("data-method"))return t(n),e.preventDefault(),!1;n=n.parentNode}},!1),window.addEventListener("phoenix.link.click",function(e){var n=e.target.getAttribute("data-confirm");n&&!window.confirm(n)&&e.preventDefault()},!1)}()}()}),require.register("js/app.js",function(e,n,t){"use strict";function i(e){return e&&e.__esModule?e:{"default":e}}n("phoenix_html");var o=n("./socket");i(o);window.copy_share_link=function(e,n){var t=(window.navigator.clipboard,""+e+n),i=document.querySelector("#share-link-container-"+n+" a");navigator.clipboard.writeText(t).then(function(){i.classList.toggle("is-success"),i.querySelector(".copy-share-link").innerHTML="Link Copied!",setTimeout(function(){i.classList.toggle("is-success"),i.querySelector(".copy-share-link").innerHTML="Share Link"},3e3)})["catch"](function(e){console.log("error")})},document.addEventListener("DOMContentLoaded",function(){var e=document.querySelector(".navbar-burger"),n=document.querySelector(".navbar-menu");e.addEventListener("click",function(){e.classList.toggle("is-active"),n.classList.toggle("is-active")})}),document.addEventListener("DOMContentLoaded",function(){var e=document.documentElement,n=document.querySelector(".modal"),t=document.querySelector(".modal-button"),i=document.querySelector(".modal-cancel");t.addEventListener("click",function(){e.classList.add("is-clipped"),n.classList.add("is-active")}),i.addEventListener("click",function(){o()}),document.addEventListener("keydown",function(e){var n=e||window.event;27===n.keyCode&&o()});var o=function(){e.classList.remove("is-clipped"),n.classList.remove("is-active")}}),window.remove_option=function(e){var n=document.querySelector(".option-section");n.querySelector("#option-"+e).remove()},window.add_option=function(){var e=document.querySelector(".option-section"),n=e.querySelectorAll("input").length;e.innerHTML+=r(n+1)};var r=function(e){return'\n  <div class="field" id="option-'+e+'">\n    <label class="label">Option '+e+':</label>\n    <div class="control">\n      <input class="input" id="question_params_option'+e+'" name="question_params[option'+e+']" placeholder="Option" type="text">\n    </div>\n    <p class="help is-danger" onclick="window.remove_option('+e+')">\n      <a class="button is-small is-danger is-outlined">\n        <span class="icon">\n          <i class="fas fa-times"></i>\n        </span>\n        <span>\n          Delete\n        </span>\n      </a>\n    </p>\n  </div>\n  '}}),require.register("js/socket.js",function(e,n,t){"use strict";function i(e){return Array.isArray(e)?e:Array.from(e)}Object.defineProperty(e,"__esModule",{value:!0});var o=function(){function e(e,n){var t=[],i=!0,o=!1,r=void 0;try{for(var s,a=e[Symbol.iterator]();!(i=(s=a.next()).done)&&(t.push(s.value),!n||t.length!==n);i=!0);}catch(c){o=!0,r=c}finally{try{!i&&a["return"]&&a["return"]()}finally{if(o)throw r}}return t}return function(n,t){if(Array.isArray(n))return n;if(Symbol.iterator in Object(n))return e(n,t);throw new TypeError("Invalid attempt to destructure non-iterable instance")}}(),r=n("phoenix"),s=document.cookie.replace(/(?:(?:^|.*;\s*)question_token\s*\=\s*([^;]*).*$)|^.*$/,"$1"),a=new r.Socket("/socket",{params:{token:window.userToken,question_token:s}}),c={};if("/sesh"==window.location.pathname||window.location.pathname.includes("/sesh/join")){a.connect();var u=window.sesh_id,l=document.querySelector(".answers"),h=document.querySelector(".questions"),f=a.channel("sesh:"+u,{});f.join().receive("ok",function(e){console.log("Joined successfully",e)}).receive("error",function(e){console.log("Unable to join",e)}),f.on("questions",function(e){var n=e.questions;window.user||(k(n),d(n),b(e.answered_questions)),E(n)}),f.on("updated_question",function(e){window.user||g(e)}),f.on("new_question",function(e){window.user||(y(e),p(e)),C(e)}),f.on("updated_answer",function(e){q(e)}),f.on("remove_question",function(e){j(e),x(e)}),f.on("presence_state",function(e){c=r.Presence.syncState(c,e),R(c)}),f.on("presence_diff",function(e){c=r.Presence.syncDiff(c,e),R(c)});var d=function(e){e.forEach(function(e){p(e)})},p=function(e){var n=v(e.id),t=o(n,4),i=t[0],r=t[1],s=t[2],a=t[3],c=document.cookie.replace(/(?:(?:^|.*;\s*)question_token\s*\=\s*([^;]*).*$)|^.*$/,"$1");r.addEventListener("click",function(){var n=i.querySelector("select");n.value&&(m(r,s,a),f.push("answer",{question_id:e.id,answer:n.value,question_token:c}).receive("ok",function(e){document.cookie="question_token="+e.question_token+";max-age=2592000"}))})},v=function(e){var n=document.getElementById("question_id_"+e),t=n.querySelector("button"),i=n.querySelector(".select"),o=n.querySelector("select");return[n,t,i,o]},m=function(e,n,t){e.disabled=!0,e.innerHTML='<span class="icon"><i class="fas fa-comment-times"></i></span><span>Answered</span>',e.classList.toggle("is-primary"),e.classList.toggle("is-danger"),n.classList.toggle("is-primary"),n.classList.toggle("is-danger"),t.disabled=!t.disabled},y=function(e){h.innerHTML=_(e)+h.innerHTML},g=function(e){var n=h.querySelector("#question_id_"+e.id);n.innerHTML=_(e)},k=function(e){h.childElementCount>0&&(h.innerHTML=""),window.user||e.forEach(function(e){h.innerHTML+=_(e)})},b=function(e){var n=window.sesh_id;e[n]&&Object.entries(e[n]).forEach(function(e){var n=o(e,2),t=n[0],i=n[1];w(t,i)})},w=function(e,n){var t=v(e),i=o(t,4),r=(i[0],i[1]),s=i[2],a=i[3];m(r,s,a),a.value=n},_=function(e){return'\n      <div class="column is-one-quarter" id="question_column_'+e.id+'">\n        <div class="card question" id="question_id_'+e.id+'">\n          <header class="header">\n              <p class="card-header-title">\n                  Question: '+e.text+'\n              </p>\n          </header>\n          <div class="card-content">\n            <div class="field">\n              <label class="label">Options:</label>\n              <div class="control">\n                <div class="select is-fullwidth is-rounded is-primary">\n                  <select>\n                    <option></option>\n                    '+e.options.map(function(e){return"<option>"+e+"</option>"})+'\n                  </select>\n                </div>\n              </div>\n            </div>\n          </div>\n          <div class="card-footer">\n            <div class="card-footer-item">\n              <button class="button is-primary is-outlined is-fullwidth">\n                <span class="icon">\n                  <i class="fas fa-comment-alt-plus"></i>\n                </span>\n                <span>Answer</span>\n              </button>\n            </div>\n          </div>\n        </div>\n      </div>\n    '},j=function(e){document.querySelector("#question_column_"+e.id).remove()},q=function(e){var n=l.querySelector("#answer_id_"+e.question_id+" ul");n.innerHTML="",Object.entries(e.answers).forEach(function(e){return n.innerHTML+=S(e)})},E=function(e){l.childElementCount>0&&(l.innerHTML=""),e.forEach(function(e){C(e)})},C=function(e){l.innerHTML=T(e)+l.innerHTML,Object.entries(e.answers).forEach(function(n){return document.querySelector("#answer_id_"+e.id+" ul").innerHTML+=S(n)})},T=function(e){return'\n      <div class="column is-one-quarter" id="answer_column_'+e.id+'">\n        <div class="card answer" id="answer_id_'+e.id+'">\n          <header class="header">\n              <p class="card-header-title">\n                  Question: '+e.text+'\n              </p>\n          </header>\n          <div class="card-content">\n            <p class="has-text-weight-bold">Options:</p>\n            <ul></ul>\n          </div>\n        </div>\n      </div>\n    '},S=function(e){return"\n      <li>Option "+e[0]+": "+e[1]+" Votes</li>\n    "},x=function(e){document.querySelector("#answer_column_"+e.id).remove()},R=function(e){r.Presence.list(e,function(e,n){var t=i(n.metas),o=(t[0],t.slice(1));window.user&&(document.querySelector(".pollr-count").innerText=o.length)})}}e["default"]=a}),require.alias("phoenix/priv/static/phoenix.js","phoenix"),require.alias("phoenix_html/priv/static/phoenix_html.js","phoenix_html"),require.register("___globals___",function(e,n,t){})}(),require("___globals___"),require("js/app");