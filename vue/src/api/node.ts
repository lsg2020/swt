import request from '@/utils/request'

export const getNodeList = async () => {
  let data = await request({
    url: '/api/agent_list',
    method: 'get'
  })

  let ret: Define.Node[] = [];
  for (let k in data.data) {
    ret.push(data.data[k] as Define.Node)
  }
  return ret
}

export const getNodeServices = async (nodeIds: string[]) => {
  let data = { ids: nodeIds }
  let ret =  await request({
    url: '/api/agent_services',
    method: 'post',
    data
  })

  return ret.data
}
