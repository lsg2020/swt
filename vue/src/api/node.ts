import request from '@/utils/request'

export const getNodeList = async (agents: string[]) => {
  let data = { agents: agents }
  let ret = await request({
    url: '/api/agent_list',
    method: 'post',
    data
  })

  return ret.data.data as Define.Node[]
}

export const getNodeServices = async (agents: string[]) => {
  let data = { agents: agents }
  let ret =  await request({
    url: '/api/agent_services',
    method: 'post',
    data
  })

  return ret.data.data
}
