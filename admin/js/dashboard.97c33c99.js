(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["dashboard"],{"0390":function(e,t,n){"use strict";var r=n("02f4")(!0);e.exports=function(e,t,n){return t+(n?r(e,t).length:1)}},"214f":function(e,t,n){"use strict";n("b0c5");var r=n("2aba"),a=n("32e9"),i=n("79e5"),c=n("be13"),u=n("2b4c"),o=n("520a"),s=u("species"),l=!i((function(){var e=/./;return e.exec=function(){var e=[];return e.groups={a:"7"},e},"7"!=="".replace(e,"$<a>")})),p=function(){var e=/(?:)/,t=e.exec;e.exec=function(){return t.apply(this,arguments)};var n="ab".split(e);return 2===n.length&&"a"===n[0]&&"b"===n[1]}();e.exports=function(e,t,n){var d=u(e),f=!i((function(){var t={};return t[d]=function(){return 7},7!=""[e](t)})),g=f?!i((function(){var t=!1,n=/a/;return n.exec=function(){return t=!0,null},"split"===e&&(n.constructor={},n.constructor[s]=function(){return n}),n[d](""),!t})):void 0;if(!f||!g||"replace"===e&&!l||"split"===e&&!p){var h=/./[d],v=n(c,d,""[e],(function(e,t,n,r,a){return t.exec===o?f&&!a?{done:!0,value:h.call(t,n,r)}:{done:!0,value:e.call(n,t,r)}:{done:!1}})),b=v[0],x=v[1];r(String.prototype,e,b),a(RegExp.prototype,d,2==t?function(e,t){return x.call(e,this,t)}:function(e){return x.call(e,this)})}}},"28a5":function(e,t,n){"use strict";var r=n("aae3"),a=n("cb7c"),i=n("ebd6"),c=n("0390"),u=n("9def"),o=n("5f1b"),s=n("520a"),l=n("79e5"),p=Math.min,d=[].push,f="split",g="length",h="lastIndex",v=4294967295,b=!l((function(){RegExp(v,"y")}));n("214f")("split",2,(function(e,t,n,l){var x;return x="c"=="abbc"[f](/(b)*/)[1]||4!="test"[f](/(?:)/,-1)[g]||2!="ab"[f](/(?:ab)*/)[g]||4!="."[f](/(.?)(.?)/)[g]||"."[f](/()()/)[g]>1||""[f](/.?/)[g]?function(e,t){var a=String(this);if(void 0===e&&0===t)return[];if(!r(e))return n.call(a,e,t);var i,c,u,o=[],l=(e.ignoreCase?"i":"")+(e.multiline?"m":"")+(e.unicode?"u":"")+(e.sticky?"y":""),p=0,f=void 0===t?v:t>>>0,b=new RegExp(e.source,l+"g");while(i=s.call(b,a)){if(c=b[h],c>p&&(o.push(a.slice(p,i.index)),i[g]>1&&i.index<a[g]&&d.apply(o,i.slice(1)),u=i[0][g],p=c,o[g]>=f))break;b[h]===i.index&&b[h]++}return p===a[g]?!u&&b.test("")||o.push(""):o.push(a.slice(p)),o[g]>f?o.slice(0,f):o}:"0"[f](void 0,0)[g]?function(e,t){return void 0===e&&0===t?[]:n.call(this,e,t)}:n,[function(n,r){var a=e(this),i=void 0==n?void 0:n[t];return void 0!==i?i.call(n,a,r):x.call(String(a),n,r)},function(e,t){var r=l(x,e,this,t,x!==n);if(r.done)return r.value;var s=a(e),d=String(this),f=i(s,RegExp),g=s.unicode,h=(s.ignoreCase?"i":"")+(s.multiline?"m":"")+(s.unicode?"u":"")+(b?"y":"g"),y=new f(b?s:"^(?:"+s.source+")",h),m=void 0===t?v:t>>>0;if(0===m)return[];if(0===d.length)return null===o(y,d)?[d]:[];var w=0,R=0,k=[];while(R<d.length){y.lastIndex=b?R:0;var S,j=o(y,b?d:d.slice(R));if(null===j||(S=p(u(y.lastIndex+(b?0:R)),d.length))===w)R=c(d,R,g);else{if(k.push(d.slice(w,R)),k.length===m)return k;for(var _=1;_<=j.length-1;_++)if(k.push(j[_]),k.length===m)return k;R=w=S}}return k.push(d.slice(w)),k}]}))},"520a":function(e,t,n){"use strict";var r=n("0bfb"),a=RegExp.prototype.exec,i=String.prototype.replace,c=a,u="lastIndex",o=function(){var e=/a/,t=/b*/g;return a.call(e,"a"),a.call(t,"a"),0!==e[u]||0!==t[u]}(),s=void 0!==/()??/.exec("")[1],l=o||s;l&&(c=function(e){var t,n,c,l,p=this;return s&&(n=new RegExp("^"+p.source+"$(?!\\s)",r.call(p))),o&&(t=p[u]),c=a.call(p,e),o&&c&&(p[u]=p.global?c.index+c[0].length:t),s&&c&&c.length>1&&i.call(c[0],n,(function(){for(l=1;l<arguments.length-2;l++)void 0===arguments[l]&&(c[l]=void 0)})),c}),e.exports=c},"5f1b":function(e,t,n){"use strict";var r=n("23c6"),a=RegExp.prototype.exec;e.exports=function(e,t){var n=e.exec;if("function"===typeof n){var i=n.call(e,t);if("object"!==typeof i)throw new TypeError("RegExp exec method returned something other than an Object or null");return i}if("RegExp"!==r(e))throw new TypeError("RegExp#exec called on incompatible receiver");return a.call(e,t)}},6462:function(e,t,n){"use strict";n.d(t,"a",(function(){return i})),n.d(t,"b",(function(){return c}));n("96cf");var r=n("3b8d"),a=n("b32d"),i=function(){var e=Object(r["a"])(regeneratorRuntime.mark((function e(t){var n,r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return n={agents:t},e.next=3,Object(a["a"])({url:"/api/agent_list",method:"post",data:n});case 3:return r=e.sent,e.abrupt("return",r.data.data);case 5:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),c=function(){var e=Object(r["a"])(regeneratorRuntime.mark((function e(t){var n,r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return n={agents:t},e.next=3,Object(a["a"])({url:"/api/agent_services",method:"post",data:n});case 3:return r=e.sent,e.abrupt("return",r.data.data);case 5:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}()},9406:function(e,t,n){"use strict";n.r(t);var r=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"app-container"},[n("el-row",{staticStyle:{"padding-top":"15px","padding-bottom":"15px","border-bottom":"1px solid white"}},[n("el-table",{staticStyle:{width:"100%"},attrs:{data:e.nodes.slice((e.currpage-1)*e.pagesize,e.currpage*e.pagesize),stripe:""}},[n("el-table-column",{attrs:{label:"地址",width:"150px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.addr)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"类型",width:"150px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.type)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"名字",width:"150px"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n          "+e._s(t.row.name)+"\n        ")]}}])}),n("el-table-column",{attrs:{label:"状态",width:"80px"},scopedSlots:e._u([{key:"default",fn:function(t){return[n("el-tag",{attrs:{type:"connected"===t.row.status?"success":"danger","disable-transitions":""}},[e._v("\n            "+e._s(t.row.status)+"\n          ")])]}}])})],1),n("div",{staticStyle:{"text-align":"center","margin-top":"30px"}},[n("el-pagination",{attrs:{background:"",layout:"prev, pager, next, sizes, total, jumper","page-sizes":[5,10,15,20],"page-size":e.pagesize,"current-page":e.currpage,total:e.nodes.length},on:{"update:pageSize":function(t){e.pagesize=t},"update:page-size":function(t){e.pagesize=t},"update:currentPage":function(t){e.currpage=t},"update:current-page":function(t){e.currpage=t},"current-change":e.changePageIndex,"size-change":e.changePageSize}})],1)],1),n("el-row",{staticStyle:{"padding-top":"15px","padding-bottom":"15px","border-bottom":"1px solid white"}},[n("el-col",{attrs:{md:24,sm:24}},[n("el-input",{attrs:{autosize:{minRows:10,maxRows:10},type:"textarea",placeholder:"Please input target","min-width":"50px"},model:{value:e.editTargets,callback:function(t){e.editTargets=t},expression:"editTargets"}})],1)],1),n("el-row",{staticStyle:{"padding-top":"15px","padding-bottom":"15px","border-bottom":"1px solid white"}},[n("el-button",{attrs:{type:"primary"},on:{click:e.onChangeTarget}},[e._v("提交")])],1)],1)},a=[],i=(n("6b54"),n("2397"),n("28a5"),n("96cf"),n("3b8d")),c=n("d225"),u=n("b0b4"),o=n("4e2b"),s=n("308d"),l=n("6bb5"),p=n("9ab4"),d=n("60a3"),f=n("6462");function g(e){return function(){var t,n=Object(l["a"])(e);if(h()){var r=Object(l["a"])(this).constructor;t=Reflect.construct(n,arguments,r)}else t=n.apply(this,arguments);return Object(s["a"])(this,t)}}function h(){if("undefined"===typeof Reflect||!Reflect.construct)return!1;if(Reflect.construct.sham)return!1;if("function"===typeof Proxy)return!0;try{return Date.prototype.toString.call(Reflect.construct(Date,[],(function(){}))),!0}catch(e){return!1}}var v=function(e){Object(o["a"])(n,e);var t=g(n);function n(){var e;return Object(c["a"])(this,n),e=t.apply(this,arguments),e.editTargets="",e.targets="",e.nodes=[],e.pagesize=10,e.currpage=1,e}return Object(u["a"])(n,[{key:"mounted",value:function(){this.targets=this.editTargets=localStorage.getItem("servers")||"",this.query(),this.timer=setInterval(this.query,1e3)}},{key:"beforeDestroy",value:function(){clearInterval(this.timer)}},{key:"changePageIndex",value:function(e){this.currpage=e}},{key:"changePageSize",value:function(e){this.pagesize=e}},{key:"onChangeTarget",value:function(){this.targets=this.editTargets,localStorage.setItem("servers",this.targets),this.query()}},{key:"query",value:function(){var e=Object(i["a"])(regeneratorRuntime.mark((function e(){var t;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:if(null!=this.targets&&""!=this.targets){e.next=4;break}this.nodes=[],e.next=8;break;case 4:return t=this.targets.split("\n"),e.next=7,f["a"](t);case 7:this.nodes=e.sent;case 8:case"end":return e.stop()}}),e,this)})));function t(){return e.apply(this,arguments)}return t}()}]),n}(d["c"]);v=Object(p["a"])([Object(d["a"])({name:"Dashboard"})],v);var b=v,x=b,y=n("2877"),m=Object(y["a"])(x,r,a,!1,null,null,null);t["default"]=m.exports},b0c5:function(e,t,n){"use strict";var r=n("520a");n("5ca1")({target:"RegExp",proto:!0,forced:r!==/./.exec},{exec:r})}}]);
//# sourceMappingURL=dashboard.97c33c99.js.map