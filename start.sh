#!/bin/bash

#根目录
path='/usr/app/'

#获取最新版本
get_latest_version(){
 latest_version=`curl -X HEAD -I --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0" 'https://github.com/v2fly/v2ray-core/releases/latest' -s  | grep  'location: ' | awk -F "/" '{print $NF}'  | tr '\r' ' ' | awk '{print $1}'`
}

#运行程序
start(){
    #获取最新版本
    get_latest_version
    #判断文件夹是否存在
    if [ ! -d $path$latest_version ]; then
        #下载地址
        download="https://github.com/v2fly/v2ray-core/releases/download/";
        file="/v2ray-linux-64.zip";
        echo $download$latest_version$file
        
        #文件夹不存在
        mkdir -p $path$latest_version
        #下载文件
        curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL $download$latest_version$file -o $path$latest_version/v2ray-linux-64.zip
        unzip -q $path$latest_version/v2ray-linux-64.zip -d $path$latest_version/
            #循环删除其他版本
            for vfile in ` ls $path | grep -v $latest_version`
            do
                
                vfilepid=`ps -ef |grep $vfile | grep -v 'grep'  | awk '{print $1}' | tr "\n" " "`
                if [ ! -z "$vfilepid" ]; then  
                    echo $vfilepid
                    kill -9 $vfilepid
                fi 
                rm -fr $path$vfile
            
            done

        nohup $path$latest_version/v2ray -config /usr/config.json  >/usr/share/nginx/html/config.html 2>&1 & 
        nohup $path$latest_version/v2ray -config /usr/configm.json  >/usr/share/nginx/html/configm.html 2>&1 & 
        echo `date`"-"$latest_version > /usr/share/nginx/html/version.html
    fi
}



#由于不支持crontab 改用 while
#由于容器长时间无连接会被销毁 有新连接时会被创建
#基本不会通过while进行更新会在每次容器创建时更新
while true
do
    echo start
    start
    sleep 1d
done
