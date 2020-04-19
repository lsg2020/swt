declare namespace Define {

    type Node = {
      id: string
      type: string
      name: string
    }

    type LuaService = {
      node?: Node
      addr: string
      name: string
    }
}
