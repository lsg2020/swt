# swt
skynet 火焰图 flamegraph + debug, 运行过程中随时启停profiler,方便调试线上问题


## 使用说明
* 引入调试命令 `SWT_RUN` 让服务支持debug脚本执行
    * 配置 `preload = "./lualib/swt/debug.lua"`
    * 或者在服务启动时 `require "swt.debug"`
* 启动 master 节点
``` lua
local swt       = require "swt"
swt.start_master("0.0.0.0:9527") -- 监听地址
```

* 启动 agent节点
``` lua
local swt       = require "swt"
swt.start_agent("app", "node1", "127.0.0.1:9527") -- 类型名,节点名,master连接地址
```

* 进入管理界面 `http://127.0.0.1:9527/admin`

## 示例
* `make`
* 启动`./build/skynet ./config`
* 进入`http://127.0.0.1:9527/admin`

## 展示 
![cpuprofile](https://github.com/lsg2020/swt/blob/master/doc/images/cpuprofiler3.png)
![cpuprofile](https://github.com/lsg2020/swt/blob/master/doc/images/cpuprofiler.png)
![cpuprofile](https://github.com/lsg2020/swt/blob/master/doc/images/cpuprofiler2.png)
![debug](https://github.com/lsg2020/swt/blob/master/doc/images/debug.png)

