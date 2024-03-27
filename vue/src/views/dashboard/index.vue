<template>
  <div class="app-container">
    <el-row style="padding-top: 15px;padding-bottom: 15px;border-bottom: 1px solid white;">
      <el-table
        :data="nodes.slice((currpage-1)*pagesize, currpage*pagesize)"
        stripe
        style="width: 100%"
      >
        <el-table-column
          label="地址"
          width="150px">
          <template slot-scope="scope">
            {{ scope.row.addr }}
          </template>
        </el-table-column>

        <el-table-column
          label="类型"
          width="150px">
          <template slot-scope="scope">
            {{ scope.row.type }}
          </template>
        </el-table-column>

        <el-table-column
          label="名字"
          width="150px">
          <template slot-scope="scope">
            {{ scope.row.name }}
          </template>
        </el-table-column>

        <el-table-column
          label="状态"
          width="80px">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 'connected' ? 'success' : 'danger'" disable-transitions>
              {{ scope.row.status }}
            </el-tag>
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
          :total="nodes.length"
          @current-change="changePageIndex"
          @size-change="changePageSize"
        >
        </el-pagination>
      </div>
    </el-row>

    <el-row style="padding-top: 15px;padding-bottom: 15px;border-bottom: 1px solid white;">
      <el-col :md="24" :sm="24">
        <el-input :autosize="{minRows: 10, maxRows: 10}" v-model="editTargets" type="textarea" placeholder="Please input target" min-width="50px"/>
      </el-col>
    </el-row>

    <el-row style="padding-top: 15px;padding-bottom: 15px;border-bottom: 1px solid white;">
      <el-button type="primary" @click="onChangeTarget">提交</el-button>
    </el-row>

  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import * as ApiNode from '@/api/node'

@Component({
  name: 'Dashboard'
})
export default class extends Vue {
  editTargets: string = ''
  targets: string = ''
  nodes: Define.Node[] = []
  timer: any

  pagesize = 10
  currpage = 1

  mounted() {
    this.targets = this.editTargets = localStorage.getItem('servers') || ''
    this.query()
    this.timer = setInterval(this.query, 1000)
  }

  beforeDestroy() {
    clearInterval(this.timer)
  }
  
  changePageIndex(index: number) {
    this.currpage = index
  }

  changePageSize(psize: number) {
    this.pagesize = psize
  }

  onChangeTarget() {
    this.targets = this.editTargets
    localStorage.setItem('servers', this.targets)
    this.query()
  }

  async query() {
    if(this.targets == null || this.targets == ""){
      this.nodes = []
    }else{
      let targets = this.targets.split('\n')
      this.nodes = await ApiNode.getNodeList(targets)
    }
  }
}
</script>

