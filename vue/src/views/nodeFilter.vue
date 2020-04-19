<template>
  <div>
    类型:<el-select v-model="selectTypeList" placeholder="类型"  @change="onSelectType" collapse-tags multiple default-first-option>
        <el-option v-for="item in searchTypeList" :key="item" :label="item" :value="item"/>
    </el-select>
    服务:<el-select v-model="selectServiceList" placeholder="服务"  @change="onSelectService" collapse-tags multiple default-first-option>
      <el-option v-for="item in searchServiceList" :key="item" :label="item" :value="item"/>
    </el-select>
    节点匹配:<el-input v-model="selectName" placeholder="例:*1|node2" @change="onSelectName" style="width:250px"></el-input>
    地址匹配:<el-input v-model="selectServiceAddr" placeholder="例:*a|*9" @change="onSelectServiceAddr" style="width:250px"></el-input>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import * as ApiNode from '@/api/node'

@Component({
  name: 'NodeFilter'
})
export default class NodeFilter extends Vue {
  selectTypeList: string[] = []
  searchTypeList: string[] = []
  selectName: string = ''
  selectServiceAddr: string = ''

  selectServiceList: string[] = []
  searchServiceList: string[] = []

  created() {
  }

  mounted() {
    this.getNodeList()
  }

  beforeDestroy() {
  }

  onSelectType() {
    this.getNodeList()
  }

  onSelectService() {
    this.getNodeList()
  }

  onSelectName() {
    this.getNodeList()
  }
  onSelectServiceAddr() {
    this.getNodeList()
  }

  public async getNodeList() {
    let nodelist = await ApiNode.getNodeList()
    let types: string[] = []
    let selectNodes: Define.Node[] = []
    let id2Node: Map<string, Define.Node> = new Map<string, Define.Node>()

    let existsServices: string[] = []

    let selectServices: Define.LuaService[] = []

    let reName: any = null
    if (this.selectName) {
      reName = new RegExp(this.selectName);
    }
    let reServiceAddr: any = null
    if (this.selectServiceAddr) {
      reServiceAddr = new RegExp(this.selectServiceAddr);
    }

    for (let node of nodelist) {
      if (types.indexOf(node.type) === -1) {
        types.push(node.type)
      }
      if (this.selectTypeList.length === 0 || this.selectTypeList.indexOf(node.type) !== -1) {
        if (!reName || node.name.match(reName)) {
          selectNodes.push(node)
          id2Node.set(node.id, node)
        }
      }
    }
    let servicelist = await ApiNode.getNodeServices(selectNodes.map((node) => { return node.id }))
    for (let nodeId in servicelist) {
      let services = servicelist[nodeId]
      for (let serviceAddr in services) {
        let serviceName = services[serviceAddr]

        if (existsServices.indexOf(serviceName) === -1) {
          existsServices.push(serviceName)
        }

        if (this.selectServiceList.length === 0 || this.selectServiceList.indexOf(serviceName) !== -1) {
          if (!reServiceAddr || serviceAddr.match(reServiceAddr)) {
            selectServices.push({ node: id2Node.get(nodeId), name: serviceName, addr: serviceAddr })
          }
        }
      }
    }

    this.searchTypeList = types
    this.searchServiceList = existsServices
    this.$emit('selectNodeServiceChange', selectServices)
  }
}
</script>
