<template>
  <div class="app-container">
    <el-row style="padding-top: 15px; padding-bottom: 15px; border-bottom: 1px solid white;">
      <NodeFilter
        ref="nodeFilter"
        @selectNodeServiceChange="onSelectNodeServiceChange"
      />
    </el-row>

    <el-row style="padding-top: 15px;padding-bottom: 15px;border-bottom: 1px solid white;">
      <el-table
        :data="nodeServices.slice((currpage-1)*pagesize, currpage*pagesize)"
        stripe
        style="width: 100%"
      >
        <el-table-column
          label="类型"
          width="100px">
          <template slot-scope="scope">
            {{ scope.row.base.node.type }}
          </template>
        </el-table-column>

        <el-table-column
          label="节点"
          width="100px">
          <template slot-scope="scope">
            {{ scope.row.base.node.name }}
          </template>
        </el-table-column>

        <el-table-column
          label="地址"
          width="100px">
          <template slot-scope="scope">
            {{ scope.row.base.node.addr }}
          </template>
        </el-table-column>

        <el-table-column
          label="服务地址"
          width="100px">
          <template slot-scope="scope">
            {{ scope.row.base.addr }}
          </template>
        </el-table-column>

        <el-table-column
          label="服务名"
          width="150px">
          <template slot-scope="scope">
            {{ scope.row.base.name }}
          </template>
        </el-table-column>

        <el-table-column
          label="flamegraph"
          width="150px">
          <template slot-scope="scope">
            <el-button size="normal" :disabled="scope.row.result == ''" @click="onShowFlameGraph(scope.row)">{{'查看'}}</el-button>
          </template>
        </el-table-column>

        <el-table-column
          label="size"
          width="50px">
          <template slot-scope="scope">
            {{ scope.row.result.length }}
          </template>
        </el-table-column>

        <el-table-column
          v-if="true"
          label="error"
          width="150px">
          <template slot-scope="scope">
            <el-input placeholder="" v-model="scope.row.error"></el-input>
          </template>
        </el-table-column>
      </el-table>
      <div style="text-align: center;margin-top: 30px;">
        <el-pagination
          background
          layout="prev, pager, next, sizes, total, jumper"
          :page-sizes="[5, 10, 15, 20]"
          :page-size.sync="pagesize"
          :current-page.sync="currpage"
          :total="nodeServices.length"
          @current-change="changePageIndex"
          @size-change="changePageSize"
        >
        </el-pagination>
      </div>
    </el-row>

    <el-row style="padding-top: 15px;padding-bottom: 15px;border-bottom: 1px solid white;">
      <el-input-number v-model="checkTime"/>秒
    </el-row>
    <el-row style="padding-top: 15px;padding-bottom: 15px;border-bottom: 1px solid white;">
      <el-button type="primary" @click="commitDebugCommand()">{{buttonText}}</el-button>
    </el-row>

    <el-dialog
      :visible.sync="showFlameGraph"
      :title="dialogTitle"
      height="95%"
      width="95%">
      <flamegraph ref="flamegraph" :flamegraphData="flamegraphData"/>
    </el-dialog>

  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import flamegraph from '@/views/flamegraph/flamegraph.vue'
import NodeFilter from '@/views/nodeFilter.vue'

type DebugService = {
  base: Define.LuaService
  result: string
  error: string
  tempPrint: string
}

@Component({
  name: 'CpuProfiler',
  components: {
    NodeFilter,
    flamegraph
  }
})
export default class extends Vue {
  currpage = 1
  pagesize = 5
  nodeServices: DebugService[] = []
  curNodeServices: DebugService[] = []
  runAmount = 0

  showFlameGraph = false
  dialogTitle: string = ''
  flamegraphData: any = null

  websock: any = null
  checkTime: number = 10

  buttonText: string = '开始'
  buttonTime: any = 0

  onShowFlameGraph(row: DebugService) {
    this.dialogTitle = `${row.base.node && row.base.node.name} ${row.base.addr}-${row.base.name}`
    this.flamegraphData = {
      fconfig: {
        fonttype: 'Verdana',     // font type
        fontsize: 12,            // base text size
        imagewidth: '100%',          // max width, pixels
        frameheight: 16.0,          // max height is dynamic
        fontwidth: 0.59,          // avg width relative to fontsize
        minwidth: 0.1,           // min function width, pixels
        countname: 'samples',     // what are the counts in the data?
        colors: 'hot',         // color theme
        bgcolor1: '#eeeeee',     // background color gradient start
        bgcolor2: '#eeeeb0',     // background color gradient stop
        timemax: Infinity,      // (override the) sum of the counts
        factor: 1,             // factor to scale counts by
        hash: true,          // color by function name
        titletext: 'Flame Graph', // centered heading
        nametype: 'Function:',   // what are the names in the data?
        removenarrows: true,        // removes narrow functions instead of adding a 'hidden' class
        profile: {
          shortStack: true,
          unresolveds: false,
          v8internals: false,
          v8gc: true,
          sysinternals: false
        }
      },
      data: JSON.parse(row.result)
    }
    this.showFlameGraph = true
  }

  onSelectNodeServiceChange(nodeServices: Define.LuaService[]) {
    this.curNodeServices = []
    nodeServices.forEach((node) => {
      this.curNodeServices.push({ base: node, result: '', error: '', tempPrint: '' })
    })

    if (this.runAmount == 0) {
      this.currpage = 1
      this.nodeServices = this.curNodeServices
    }
  }

  changePageIndex(index: number) {
    this.currpage = index
  }

  changePageSize(psize: number) {
    this.pagesize = psize
  }

  commitDebugCommand() {
    if (this.websock) {
      this.websock.close()
    }

    if (this.buttonTime) {
      window.clearInterval(this.buttonTime)
    }
    let total = Number(this.checkTime)
    this.buttonText = total + 's'
    this.buttonTime = window.setInterval(() => {
      total--
      this.buttonText = total + 's'
      if (total <= 0) {
        window.clearInterval(this.buttonTime)
        this.buttonTime = null
        this.buttonText = '开始'
      }
    },1000)

    let baseHost: string = window.location.host
    let baseUrl = (process.env.VUE_APP_BASE_API || process.env.BASE_URL)
    if (baseUrl) {
      let r = baseUrl.match(/http:\/\/(.*)\//)
      baseHost = (r ? r[1] : baseHost)
    }

    this.runAmount++
    this.currpage = 1
    this.nodeServices = this.curNodeServices

    this.websock = new WebSocket('ws://' + baseHost + '/api/cpu_profiler')
    this.websock.onmessage = async (event: any) => {
      let text = await (new Response(event.data)).text()
      const msg = JSON.parse(text)
      for (let row of this.nodeServices) {
        // let row = this.nodeServices[k]
        if (row.base.node && msg.node_id == row.base.node.addr && msg.addr == row.base.addr) { // eslint-disable-line
          if (msg.type == 'error') {
            row.error = msg.msg
          }
          if (msg.type == 'print') {
            row.tempPrint += msg.msg.text

            if (msg.msg.index == 0) {
              row.result = row.tempPrint
              row.tempPrint = ''
            }
          }
        }
      }
    }

    this.websock.onopen = () => {
      let targets: any[] = []
      for (let k in this.nodeServices) {
        this.nodeServices[k].result = ''
        this.nodeServices[k].error = ''
        targets.push(this.nodeServices[k].base)
      }

      let msg = JSON.stringify({ cmd: 'run', time: Number(this.checkTime), targets: targets })
      this.websock.send(Buffer.from(msg))
    }

    this.websock.onclose = () => {
      console.log(`socket close`)
    }
    this.websock.onerror = (err: Error) => {
      console.log(`socket err: ${err.message}`)
    }
  }
}
</script>
