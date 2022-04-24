#!/usr/bin/env bash

function manual {
    echo "语法:./task3.sh [选项]... [参数]..."
    echo "这是一个用bash编写的对某Web服务器访问日志进行一些简单批处理的简陋脚本,好像有点健壮性"
    echo "选项:"
    echo "    -t, --top [ip]                   输出访问来源主机TOP100与分别对应出现的总次数,当添加参数ip时仅输出TOP100"
    echo "                                     中为IP格式的来源主机与分别对应出现的总次数"
    echo "    -u, --url                        输出最频繁被访问的URL TOP100"
    echo "    -s, --status                     输出不同响应状态码出现的次数与对应百分比"
    echo "    -e, --error                      输出不同4XX状态码的对应TOP10 URL与对应出现的总次数"
    echo "    -c, --check URL                  输出给定URL的TOP100访问来源主机与分别对应访问的总次数"
    echo "    -h, --help                       显示这条帮助信息"
    echo "示例:"
    echo "    ./task3.sh -t ip                 输出IP格式的访问来源主机与其分别对应出现的总次数"
    echo "    ./task3.sh --check "history.html"  输出URL位history.html的TOP100访问来源主机与分别对应访问的总次数"
}

function top {
    if [[ "$1" == "" ]];then
        echo "===================================================="
        echo "来源主机                                 总计访问次数"
        awk '
            BEGIN{
                FS="\t";
            }
            {
                if($1!="host"){
                    host[$1]++;
                }
            }
            END{
                for(i in host){
                    printf("%-40s \t%d\n",i,host[i]);
                }
            }
        ' web_log.tsv|sort -r -g -k 2|head -100
        echo "===================================================="
    elif [[ "$1" == "ip" ]];then
        echo "===================================================="
        echo "来源IP                                 总计访问次数"
        awk '
            BEGIN{
                FS="\t";
            }
            {
                if($1!="host"){
                    if(match($1, /^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$/)){
                        ip[$1]++;
                    }
                }
            }
            END{
                for(i in ip){
                    printf("%-40s \t%d\n",i,ip[i]);
                }
            }
        ' web_log.tsv|sort -r -g -k 2|head -100
        echo "===================================================="
    fi
}

function url {
    echo "===================================================================="
    echo "最频繁被访问URL                                         总计访问次数"
    awk '
        BEGIN{
            FS="\t";
        }
        {
            if($5!="url"){
                url[$5]++;
            }
        }
        END{
            for(i in url){
                printf("%-60s \t%d\n",i,url[i]);
            }
        }
    ' web_log.tsv|sort -r -g -k 2|head -100
    echo "===================================================================="
}

function status {
    awk '
        BEGIN{
            FS="\t";
            count=0;
        }
        {
            if($6!="response"){
                response[$6]++;
                count++;
            }
        }
        END{
            printf("=================================\n");
            printf("|状态码     |出现次数|对应百分比|\n");
            for(i in response){
                printf("|%-11s|%8d|%9.2f%%|\n",i,response[i],response[i]*100/count)
            }
            printf("=================================\n");
        }
    ' web_log.tsv
}

function error {
    #我是没想到居然404能多到淹没403，白写了个一次性统计4XX实现代码
    # awk '
    #     BEGIN{
    #         FS="\t";
    #     }
    #     {
    #         if($5!="url"&&$6!="response"){
    #             if(match($6,/^4[0-9]*[0-9]*$/)){
    #                 url[$5]=$6;
    #                 count[$5]++;
    #             }
    #         }
    #     }
    #     END{
    #         for(i in url){
    #             printf("%-40s \t%d\n",i,count[i])
    #         }
    #     }
    # ' web_log.tsv|sort -r -g -k 2|head -10
    echo "===================================================="
    echo "403的TOP10 URL                            出现总次数"
    awk '
        BEGIN{
            FS="\t";
        }
        {
            if($5!="url"&&$6!="response"){
                if($6==403){
                    forbidden[$5]++;
                }
            }
        }
        END{
            for(i in forbidden){
                printf("%-40s \t%d\n",i,forbidden[i]);
            }
        }
    ' web_log.tsv|sort -r -g -k 2|head -10
    echo "===================================================="
    echo "404的TOP10 URL                            出现总次数"
    awk '
        BEGIN{
            FS="\t";
        }
        {
            if($5!="url"&&$6!="response"){
                if($6==404){
                    notFound[$5]++;
                }
            }
        }
        END{
            for(i in notFound){
                printf("%-40s \t%d\n",i,notFound[i]);
            }
        }
    ' web_log.tsv|sort -r -g -k 2|head -10
    echo "===================================================="
}

function check {
    echo "=================================================="
    echo "访问来源主机                            出现总次数"
    awk '
        BEGIN{
            FS="\t";
        }
        {
            if($1!="host"&&$5!="url"){
                if($5=="'"$1"'"){
                    host[$1]++;
                }
            }
        }
        END{
            for(i in host){
                printf("%-40s \t%d\n",i,host[i])
            }
        }
    ' web_log.tsv|sort -r -g -k 2|head -100
    echo "=================================================="
}

case "$1" in
        "")
        echo "未选择操作,试试-h或者--help"
        ;;
    "-h"|"--help")
        manual
        ;;
    "-t"|"--top")
        if [[ "$2" == "" ]];then
            top
        elif [[ "$2" != "ip" ]];then
            echo "参数不正确,请参考帮助信息"
        else
            top "$2"
        fi
        ;;
    "-u"|"--url")
        url
        ;;
    "-s"|"--status")
        status
        ;;
    "-c"|"--check")
        if [[ "$2" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        else
            check "$2"
        fi
        ;;
esac
