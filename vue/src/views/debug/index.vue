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
          label="结果"
          height="600px"
          width="750px">
          <template slot-scope="scope">
            <el-input type="textarea" placeholder="执行结果" v-model="scope.row.result" :autosize="{minRows: 3, maxRows: 3}"></el-input>
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
      <el-col :md="24" :sm="24">
        <el-input :autosize="{minRows: 10, maxRows: 10}" v-model="debugScript" type="textarea" placeholder="Please input script" min-width="50px"/>
      </el-col>
    </el-row>

    <el-row style="padding-top: 15px;padding-bottom: 15px;border-bottom: 1px solid white;">
      <el-button type="primary" @click="commitDebugCommand()">执行</el-button>
    </el-row>

  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import NodeFilter from '@/views/nodeFilter.vue'

type DebugService = {
  base: Define.LuaService
  result: string
  tempPrint: string
}

@Component({
  name: 'Debug',
  components: {
    NodeFilter
  }
})
export default class extends Vue {
  currpage = 1
  pagesize = 5
  nodeServices: DebugService[] = []
  curNodeServices: DebugService[] = []
  debugScript: string = ''
  runAmount = 0

  websock: any = null

  onSelectNodeServiceChange(nodeServices: Define.LuaService[]) {
    this.curNodeServices = []
    nodeServices.forEach((node) => {
      this.curNodeServices.push({ base: node, result: '', tempPrint: '' })
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

    let baseHost: string = window.location.host
    let baseUrl = (process.env.VUE_APP_BASE_API || process.env.BASE_URL)
    if (baseUrl) {
      let r = baseUrl.match(/http:\/\/(.*)\//)
      baseHost = (r ? r[1] : baseHost)
    }

    this.runAmount++
    this.currpage = 1
    this.nodeServices = this.curNodeServices

    this.websock = new WebSocket('ws://' + baseHost + '/api/debug_run')
    this.websock.onmessage = async (event: any) => {
      let text = await (new Response(event.data)).text()
      const msg = JSON.parse(text)
      for (let row of this.nodeServices) {
        // let row = this.nodeServices[k]
        if (row.base.node && msg.node_id == row.base.node.addr && msg.addr == row.base.addr) { // eslint-disable-line
          if (msg.type == 'print') {
            row.tempPrint += msg.msg.text

            if (msg.msg.index == 0) {
              row.result += `${msg.type}: ${row.tempPrint}\n`
              row.tempPrint = ''
            }
          } else {
            row.result = row.result + `${msg.type}: ${msg.msg}\n`
          }
        }
      }
    }

    this.websock.onopen = () => {
      let targets: any[] = []
      for (let k in this.nodeServices) {
        this.nodeServices[k].result = ''
        targets.push(this.nodeServices[k].base)
      }

      let msg = JSON.stringify({ cmd: 'run', script: this.debugScript, targets: targets })
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
