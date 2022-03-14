# 实验报告

## 实验问题

- 使用表格方式记录至少2个不同Linux发行版本上以下信息的获取方法，使用[asciinema](https://asciinema.org/)录屏方式**分段**记录相关信息的获取过程和结果
  - 【软件包管理】在目标发行版上安装`tmux`和`tshark`；查看这2个软件被安装到哪些路径；卸载`tshark`；验证`tshark`卸载结果
  - 【文件管理】复制以下`shell`代码到终端运行，在目标Linux发行版系统中构造测试数据集，然后回答以下问题：
    - 找到`/tmp`目录及其所有子目录下，文件名包含`666`的所有文件
    - 找到`/tmp`目录及其所有子目录下，文件内容包含`666`的所有文件

  ```bash
  cd /tmp && for i in $(seq 0 1024);do dir="test-$RANDOM";mkdir "$dir";echo "$RANDOM" > "$dir/$dir-$RANDOM";done
  ```
  
  - 【文件压缩与解压缩】练习课件中[文件压缩与解压缩](https://c4pr1c3.github.io/LinuxSysAdmin/chap0x02.md.html#/12/1)一节所有提到的压缩与解压缩命令的使用方法
  - 【跟练】[子进程管理实验](https://asciinema.org/a/f3ux5ogwbxwo2q0wxxd0hmn54)
  - 【硬件信息获取】目标系统的CPU、内存大小、硬盘数量与硬盘容量

## 问题解决记录



## 总结与整理

遇到的问题或者踩的坑就在这里总结吧。

### 一些趣事

### 一些踩坑

## 参考链接