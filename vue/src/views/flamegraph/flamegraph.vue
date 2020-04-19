<template>
<svg class="flamegraph-view" ref="svg" version="1.1" id="flamegraph-svg"
  data-width="100%" width="100%"
  :height="data.imageheight" :data-height="data.imageheight"
  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">

<defs>
	<linearGradient id="background" y1="0" y2="1" x1="0" x2="0">
    <stop :stop-color="data.bgcolor1" offset="5%" />
    <stop :stop-color="data.bgcolor2" offset="95%" />
	</linearGradient>
</defs>

<rect x="0.0" y="0" id="svg-background" width="100%" :height="data.imageheight" fill="url(#background)" />
<text text-anchor="left" :x="data.xpad" :y="data.detailsY" :font-size="data.fontsize" :font-family="data.fonttype" fill="rgb(0,0,0)" id="details">{{ show }}</text>
<text text-anchor="" :x="data.xpad" y="21" :font-size="data.fontsize" :font-family="data.fonttype" fill="rgb(0,0,0)" ref="unzoom" v-on:click.stop="unzoom()" style="opacity:0.0;cursor:pointer" >Reset Zoom</text>
<text text-anchor="" :x="data.xpad3" y="21" :font-size="data.fontsize" :font-family="data.fonttype" fill="rgb(0,0,0)" ref="enlarge" v-on:mouseover="zoomover()" v-on:mouseout="zoomout()" v-on:click.stop="set_parent_inf" style="opacity:0.1;cursor:pointer">{{ enlarge }}</text>
<text text-anchor="" :x="data.xpad2" y="21" :font-size="data.fontsize" :font-family="data.fonttype" fill="rgb(0,0,0)" ref="search" v-on:mouseover="searchover()" v-on:mouseout="searchout()" v-on:click.stop="search_prompt()" style="opacity:0.1;cursor:pointer" >Search</text>
<text text-anchor="" :x="data.xpad2" :y="data.detailsY" :font-size="data.fontsize" :font-family="data.fonttype" fill="rgb(0,0,0)" ref="matched" >{{ matchedtxt }}</text>

<g v-for="node in nodes" :node-index="node.index" class="func_g" v-on:mouseover="s(`${node.name} ${node.samples}`)" v-on:mouseout="c()" v-on:click.stop="zoom($event)" :data-search="node.search" :data-funcname="node.func">
  <title>{{ node.name }} {{node.samples}}</title>
  <rect :node-index="node.index" :x="node.rect_x" :data-x="node.rect_x" :y="node.rect_y" :width="node.rect_w" :data-width="node.rect_w" :height="node.rect_h" :data-height="node.rect_h" :fill="node.rect_fill" rx="2" ry="2"></rect>
  <text :data-x="node.text_x" :x="node.text_x" :y="node.text_y" :font-size="data.fontsize" :font-family="data.fonttype" fill="rgb(0,0,0)">{{ node.text }}</text>
</g>
</svg>

</template>

<script>
import jsflamegraph from '@/views/flamegraph/flamegraph.js'
export default {
    data() {
        return {
            data: {},
            matchedtxt: '',
            show: 'SWT',
            need_unzoom: {}
        }
    },

    props: ['flamegraphData', 'showBigPic'],

    mounted: function() { jsflamegraph.mounted.call(this); },

    methods: {
        s(info) { jsflamegraph.methods.s.call(this, info); },
        c() { jsflamegraph.methods.c.call(this); },
        zoom(event) { jsflamegraph.methods.zoom.call(this, event); },
        unzoom() { jsflamegraph.methods.unzoom.call(this); },
        searchover() { jsflamegraph.methods.searchover.call(this); },
        searchout() { jsflamegraph.methods.searchout.call(this); },
        search_prompt() { jsflamegraph.methods.search_prompt.call(this); },
        set_parent_inf() { jsflamegraph.methods.set_parent_inf.call(this); },
        zoomover() { this.$refs.enlarge.style["opacity"] = "1.0"; },
        zoomout() { this.$refs.enlarge.style["opacity"] = "0.1"; }
    },

    computed: {
        nodes(){ return jsflamegraph.computed.nodes.call(this); },
        enlarge() { return this.showBigPic && 'ZoomOut' || 'ZoomIn'; }
    },

    watch: {
        showBigPic() { return jsflamegraph.watch.showBigPic.call(this); },
        flamegraphData() {
          return jsflamegraph.watch.showBigPic.call(this);
        }
    }
}
</script>
