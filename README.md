# linux-init

## quick start
```sh
	git clone https://github.com/msuadOf/linux-init.git
	cd linux-init && ./init.sh
```

## Install
```sh
	git clone https://github.com/msuadOf/linux-init.git
```
or
```sh
	git clone https://gitee.com/msuad/linux-init.git
```

## Usage
```sh
	cd linux-init
	./init.sh
```

## function
1. some commands:
`proxy_on` => `on`
`proxy_off` => `off`
`proxy_test`

`proxy_on`:
    case 参数数量 == 0:
        // 使用默认值，无需处理
        使用 127.0.0.1:7890
    
    case 参数数量 == 1:
        $1 = 第一个参数
        
        case $1 是纯数字:
            // 如 "8080", "9090"
            PORT = 参数
        
        case $1 包含冒号":":
            // 如 "192.168.1.100:8080", "localhost:9090"
            按冒号分割字符串为两部分
            IP = 前部分
            PORT = 后部分
        
        othercase:
            // 其他情况，如 "192.168.1.100", "localhost"
            IP = 参数
    
    case 参数数量 >= 2
        IP = 第一个参数
        PORT = 第二个参数