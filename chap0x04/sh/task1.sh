#!/usr/bin/env bash

function manual(){
    echo "语法:./task1.sh [选项]... [参数]..."
    echo "这是一个用bash编写的对当前目录下JPEG/PNG/SVG图像进行一些简单批处理的简陋脚本,没有什么健壮性可言"
    echo "选项:"
    echo "    -c, --compress ratio             按照给定压缩比例对当前目录下所有JPEG图像进行压缩,ratio取值为1%~100%"
    echo "    -r, --resize percentage          按照给定百分比缩小当前目录下所有JPEG/PNG/SVG图像分辨率,不改变图片宽高比,"
    echo "                                     percentage取值为1%~100%"
    echo "    -w, --watermark size string      将自定义文本添加为当前目录下所有图像的水印"
    echo "    -p, --prefix string              添加自定义文本作为当前目录下所有图像的文件名前缀"
    echo "    -s, --suffix string              添加自定义文本作为当前目录下所有图像的文件名后缀,不影响文件扩展名"
    echo "    -f, --format                     将当前目录下所有PNG/SVG图像转换为JPEG图像"
    echo "    -h, --help                       显示这条帮助信息"
    echo "示例:"
    echo "    ./task1.sh -c 85%                将当前目录下所有JEPG文件质量压缩为原本的85%"
    echo "    ./task1.sh --prefix 233          将233添加到当前目录下所有图片的文件名开头"
}

function compress {
    ratio="$1"
    for image in *.jpg;do
        convert "${image}" -quality "${ratio}" "${image}" 2>/dev/null
        if [[ "${image%.*}" == "*" ]];then
            echo "当前目录下没有${image##*.}格式图像"
            continue
        else
            echo "${image}压缩完成"
        fi
    done
}

function resize {
    percentage="$1"
    for image in *.{jpg,png,svg};do
        convert "${image}" -resize "${percentage}" "${image}" 2>/dev/null
        if [[ "${image%.*}" == "*" ]];then
            echo "当前目录下没有${image##*.}格式图像"
            continue
        else
            echo "${image}分辨率修改完成"
        fi
    done
}

function watermark {
    size="$1"
    string="$2"
    for image in *.{jpg,png,svg};do
        convert "${image}" -pointsize "${size}" -fill cyan -gravity southeast -draw "text 50 50 ${string}" "${image}" 2>/dev/null
        if [[ "${image%.*}" == "*" ]];then
            echo "当前目录下没有${image##*.}格式图像"
            continue
        else
            echo "${image}已添加水印${string}"
        fi
    done
}

function prefix {
    string="$1"
    for image in *.{jpg,png,svg};do
        mv "${image}" "${string}""${image}" 2>/dev/null
        if [[ "${image%.*}" == "*" ]];then
            echo "当前目录下没有${image##*.}格式图像"
            continue
        else
            echo "${image}已添加文件名前缀${string}"
        fi
    done
}

function suffix {
    string="$1"
    for image in *.{jpg,png,svg};do
        mv "${image}" "${image%.*}$1"".${image##*.}" 2>/dev/null
        if [[ "${image%.*}" == "*" ]];then
            echo "当前目录下没有${image##*.}格式图像"
            continue
        else
            echo "${image}已添加文件名后缀${string}"
        fi
    done
}

function format {
    for image in *.{png,svg};do
        convert "${image}" "${image%.*}.jpg" 2>/dev/null
        if [[ "${image%.*}" == "*" ]];then
            echo "当前目录下没有${image##*.}格式图像"
            continue
        else
            echo "${image}已转换为jpg格式,源文件未删除"
        fi
    done
}

case "$1" in
    "")
        echo "未选择操作,试试-h或者--help"
        ;;
    "-h"|"--help")
        manual
        ;;
    "-c"|"--compress")
        if [[ "$2" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        else
            compress "$2"
        fi
        ;;
    "-r"|"--resize")
        if [[ "$2" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        else
            resize "$2"
        fi
        ;;
    "-w"|"--watermark")
        if [[ "$2" == "" || "$3" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        else
            watermark "$2" "$3"
        fi
        ;;
    "-p"|"--prefix")
        if [[ "$2" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        else
            prefix "$2"
        fi
        ;;
    "-s"|"--suffix")
        if [[ "$2" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        else
            suffix "$2"
        fi
        ;;
    "-f"|"--format")
        format
        ;;
esac
