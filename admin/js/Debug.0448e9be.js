(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["Debug"],{"49e8":function(e,t,n){"use strict";n.r(t);var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"app-container"},[n("el-row",{staticStyle:{"padding-top":"15px","padding-bottom":"15px","border-bottom":"1px solid white"}},[n("NodeFilter",{ref:"nodeFilter",on:{selectNodeServiceChange:e.onSelectNodeServiceChange}})],1),n("el-row",{staticStyle:{"padding-top":"15px","padding-bottom":"15px","border-bottom":"1px solid white"}},[n("el-table",{staticStyle:{width:"100%"},attrs:{data:e.nodeServices.slice((e.currpage-1)*e.pagesize,e.currpage*e.pagesize),stripe:""}},[n("el-table-column",{attrs:{label:"类型",width:"100px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.base.node.type)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"节点",width:"100px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.base.node.name)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"地址",width:"100px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.base.node.addr)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"服务地址",width:"100px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.base.addr)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"服务名",width:"150px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.base.name)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"结果",height:"600px",width:"750px"},scopedSlots:e._u([{key:"default",fn:function(t){return[n("el-input",{attrs:{type:"textarea",placeholder:"执行结果",autosize:{minRows:3,maxRows:3}},model:{value:t.row.result,callback:function(n){e.$set(t.row,"result",n)},expression:"scope.row.result"}})]}}])})],1),n("div",{staticStyle:{"text-align":"center","margin-top":"30px"}},[n("el-pagination",{attrs:{background:"",layout:"prev, pager, next, sizes, total, jumper","page-sizes":[5,10,15,20],"page-size":e.pagesize,"current-page":e.currpage,total:e.nodeServices.length},on:{"update:pageSize":function(t){e.pagesize=t},"update:page-size":function(t){e.pagesize=t},"update:currentPage":function(t){e.currpage=t},"update:current-page":function(t){e.currpage=t},"current-change":e.changePageIndex,"size-change":e.changePageSize}})],1)],1),n("el-row",{staticStyle:{"padding-top":"15px","padding-bottom":"15px","border-bottom":"1px solid white"}},[n("el-col",{attrs:{md:24,sm:24}},[n("el-input",{attrs:{autosize:{minRows:10,maxRows:10},type:"textarea",placeholder:"Please input script","min-width":"50px"},model:{value:e.debugScript,callback:function(t){e.debugScript=t},expression:"debugScript"}})],1)],1),n("el-row",{staticStyle:{"padding-top":"15px","padding-bottom":"15px","border-bottom":"1px solid white"}},[n("el-button",{attrs:{type:"primary"},on:{click:function(t){return e.commitDebugCommand()}}},[e._v("执行")])],1)],1)},o=[],a=n("4d47"),c=a["a"],i=n("2877"),s=Object(i["a"])(c,r,o,!1,null,null,null);t["default"]=s.exports},"4d47":function(e,t,n){"use strict";(function(e){n("ac4d"),n("8a81"),n("1c4c"),n("7f7f"),n("6b54"),n("2397"),n("5df3"),n("f400"),n("96cf");var r=n("3b8d"),o=(n("4917"),n("ac6a"),n("d225")),a=n("b0b4"),c=n("4e2b"),i=n("308d"),s=n("6bb5"),u=n("9ab4"),l=n("60a3"),p=n("26de");function d(e){if("undefined"===typeof Symbol||null==e[Symbol.iterator]){if(Array.isArray(e)||(e=f(e))){var t=0,n=function(){};return{s:n,n:function(){return t>=e.length?{done:!0}:{done:!1,value:e[t++]}},e:function(e){throw e},f:n}}throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}var r,o,a=!0,c=!1;return{s:function(){r=e[Symbol.iterator]()},n:function(){var e=r.next();return a=e.done,e},e:function(e){c=!0,o=e},f:function(){try{a||null==r.return||r.return()}finally{if(c)throw o}}}}function f(e,t){if(e){if("string"===typeof e)return b(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);return"Object"===n&&e.constructor&&(n=e.constructor.name),"Map"===n||"Set"===n?Array.from(n):"Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)?b(e,t):void 0}}function b(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=new Array(t);n<t;n++)r[n]=e[n];return r}function g(e){return function(){var t,n=Object(s["a"])(e);if(m()){var r=Object(s["a"])(this).constructor;t=Reflect.construct(n,arguments,r)}else t=n.apply(this,arguments);return Object(i["a"])(this,t)}}function m(){if("undefined"===typeof Reflect||!Reflect.construct)return!1;if(Reflect.construct.sham)return!1;if("function"===typeof Proxy)return!0;try{return Date.prototype.toString.call(Reflect.construct(Date,[],(function(){}))),!0}catch(e){return!1}}var h=function(t){Object(c["a"])(i,t);var n=g(i);function i(){var e;return Object(o["a"])(this,i),e=n.apply(this,arguments),e.currpage=1,e.pagesize=5,e.nodeServices=[],e.curNodeServices=[],e.debugScript="",e.runAmount=0,e.websock=null,e}return Object(a["a"])(i,[{key:"onSelectNodeServiceChange",value:function(e){var t=this;this.curNodeServices=[],e.forEach((function(e){t.curNodeServices.push({base:e,result:"",tempMap:null})})),0===this.runAmount&&(this.currpage=1,this.nodeServices=this.curNodeServices)}},{key:"changePageIndex",value:function(e){this.currpage=e}},{key:"changePageSize",value:function(e){this.pagesize=e}},{key:"commitDebugCommand",value:function(){var t=this;this.websock&&this.websock.close();var n=window.location.host,o=Object({NODE_ENV:"production",BASE_URL:"/admin/"}).VUE_APP_BASE_API||"/admin/";if(o){var a=o.match(/http:\/\/(.*)\//);n=a?a[1]:n}this.runAmount++,this.currpage=1,this.nodeServices=this.curNodeServices,this.websock=new WebSocket("ws://"+n+"/api/debug_run"),this.websock.onmessage=function(){var e=Object(r["a"])(regeneratorRuntime.mark((function e(n){var r,o,a,c,i,s,u;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,new Response(n.data).text();case 2:r=e.sent,o=JSON.parse(r),a=d(t.nodeServices);try{for(a.s();!(c=a.n()).done;)if(i=c.value,i.base.node&&o.node_id==i.base.node.addr&&o.addr==i.base.addr)if("error"===o.type)i.result="".concat(o.type,": ").concat(o.msg,"\n"),i.tempMap=null;else if("print"===o.type){if(null==i.tempMap&&(i.tempMap=new Map),i.tempMap.set(o.msg.index,o.msg.text),void 0!==i.tempMap.get(0)&&i.tempMap.size>=o.msg.max+1){for(s="",u=o.msg.max;u>=0;--u)s+=i.tempMap.get(u);i.result+="".concat(o.type,": ").concat(s,"\n"),i.tempMap=null}}else i.result+="".concat(o.type,": ").concat(o.msg,"\n")}catch(l){a.e(l)}finally{a.f()}case 6:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),this.websock.onopen=function(){var n=[];for(var r in t.nodeServices)t.nodeServices[r].result="",n.push(t.nodeServices[r].base);var o=JSON.stringify({cmd:"run",script:t.debugScript,targets:n});t.websock.send(e.from(o))},this.websock.onclose=function(){console.log("socket close")},this.websock.onerror=function(e){console.log("socket err: ".concat(e.message))}}}]),i}(l["c"]);h=Object(u["a"])([Object(l["a"])({name:"Debug",components:{NodeFilter:p["a"]}})],h),t["a"]=h}).call(this,n("b639").Buffer)}}]);
//# sourceMappingURL=Debug.0448e9be.js.map