#!/usr/bin/env bash

function manual {
    echo "语法:./task2.sh [选项]... [参数]..."
    echo "这是一个用bash编写的对2014世界杯运动员数据进行一些简单批处理的简陋脚本,好像有点健壮性"
    echo "选项:"
    echo "    -s, --stats                      统计20岁以下,20~30岁,30岁以上的球员数量,百分比"
    echo "    -p, --player                     统计不同场上位置的球员数量,百分比"
    echo "    -n, --name longest/shortest      显示名字最长/最短的球员名字"
    echo "    -a, --age oldest/youngest        显示年龄最大/最小的球员名字与其年龄"
    echo "    -h, --help                       显示这条帮助信息"
    echo "示例:"
    echo "    ./task2.sh -n longest            显示名字最长的球员名字"
    echo "    ./task2.sh --age youngest        显示年龄最小的球员名字与其年龄"
}

function stats {
    awk '
        BEGIN{
            FS="\t";
            lessThan20=0;
            between20And30=0;
            greaterThan30=0;
        }
        {
            if($6!="Age"){
                if($6<20){
                    lessThan20++;
                }
                else if($6>=20&&$6<=30){
                    between20And30++;
                }
                else{
                    greaterThan30++;
                }
            }
        }
        END{
            sum=lessThan20+between20And30+greaterThan30;
            printf("=================================\n");
            printf("|年龄       |球员数量|所占百分比|\n");
            printf("|小于20岁   |%8d|%9.2f%%|\n",lessThan20,lessThan20*100/sum);
            printf("|20~30岁之间|%8d|%9.2f%%|\n",between20And30,between20And30*100/sum);
            printf("|大于30岁   |%8d|%9.2f%%|\n",greaterThan30,greaterThan30*100/sum);
            printf("=================================\n");
        }
    ' worldcupplayerinfo.tsv
}

function playerAmount {
    awk '
        BEGIN{
            FS="\t";
            kinds=0;
        }
        {
            if($5!="Position"){
                position[$5]++;
                kinds++;
            }
        }
        END{
            printf("=================================\n");
            printf("|场上位置   |球员数量|所占百分比|\n");
            for(i in position){
                printf("|%-11s|%8d|%9.2f%%|\n",i,position[i],position[i]*100/kinds);
            }
            printf("=================================\n");
        }
    ' worldcupplayerinfo.tsv
}

function name {
    if [[ $1 == "longest" ]];then
        awk '
            BEGIN{
                FS="\t";
                compare=0;
            }
            {
                if($9!="Player"){
                    nameLength=length($9);
                    result[$9]=nameLength;
                    if(nameLength>=compare){
                        compare=nameLength;
                    }
                }
            }
            END{
                printf("=================================\n");
                printf("名字最长的球员为:\n")
                for(i in result){
                    if(result[i]==compare){
                        printf("%s\n",i);
                    }
                }
                printf("=================================\n");
            }
        ' worldcupplayerinfo.tsv
    elif [[ $1 == "shortest" ]];then
        awk '
            BEGIN{
                FS="\t";
                compare=65535;
            }
            {
                if($9!="Player"){
                    nameLength=length($9);
                    result[$9]=nameLength;
                    if(nameLength<=compare){
                        compare=nameLength;
                    }
                }
            }
            END{
                printf("=================================\n");
                printf("名字最短的球员为:\n")
                for(i in result){
                    if(result[i]==compare){
                        printf("%s\n",i);
                    }
                }
                printf("=================================\n");
            }
        ' worldcupplayerinfo.tsv
    fi
}

function age {
    if [[ $1 == "oldest" ]];then
        awk '
            BEGIN{
                FS="\t";
                compare=0;
            }
            {
                if($6!="Age"&&$9!="Player"){
                    age=$6;
                    result[$9]=age;
                    if(age>=compare){
                        compare=age;
                    }
                }
            }
            END{
                printf("=================================\n");
                printf("年龄最大的球员为:\n")
                for(i in result){
                    if(result[i]==compare){
                        printf("%s,年龄为%d岁\n",i,result[i]);
                    }
                }
                printf("=================================\n");
            }
        ' worldcupplayerinfo.tsv
    elif [[ $1 == "youngest" ]];then
        awk '
            BEGIN{
                FS="\t";
                compare=65535;
            }
            {
                if($6!="Age"&&$9!="Player"){
                    age=$6;
                    result[$9]=age;
                    if(age<=compare){
                        compare=age;
                    }
                }
            }
            END{
                printf("=================================\n");
                printf("年龄最小的球员为:\n")
                for(i in result){
                    if(result[i]==compare){
                        printf("%s,年龄为%d岁\n",i,result[i]);
                    }
                }
                printf("=================================\n");
            }
        ' worldcupplayerinfo.tsv
    fi
}

case "$1" in
    "")
        echo "未选择操作,试试-h或者--help"
        ;;
    "-h"|"--help")
        manual
        ;;
    "-s"|"--stats")
        stats
        ;;
    "-p"|"--player")
        playerAmount
        ;;
    "-n"|"--name")
        if [[ "$2" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        elif [[ "$2" != "longest" && "$2" != "shortest" ]];then
            echo "参数不正确,请参考帮助信息"
        else
            name "$2"
        fi
        ;;
    "-a"|"--age")
        if [[ "$2" == "" ]];then
            echo "缺少参数,请参考帮助信息"
        elif [[ "$2" != "oldest" && "$2" != "youngest" ]];then
            echo "参数不正确,请参考帮助信息"
        else
            age "$2"
        fi
        ;;
esac
