declare namespace Define {
    type Node = {
      addr: string
      type: string
      name: string
      status: string
    }

    type LuaService = {
      node?: Node
      addr: string
      name: string
    }    
}
