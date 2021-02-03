<center><font face="黑体" size=6>MARKDOWN-插入图片</font></center>

## 1 markdown是什么
>Markdown 是一种轻量级标记语言，创始人为约翰·格鲁伯（John Gruber）,它允许人们使用易读易写的纯文本格式编写文档，然后转换成有效的HTML文档。
&nbsp;


## 2 markdown 插入图片的三种方式


### 2.1 插入本地图片
只需要在markdown插入图片语法的括号中填入图片本地路径：
```
![Alt text](本地图片位置路径)
eg: ![avatar](C:\Users\pgong\Pictures\30972457.png)
```
> Alt text：图片的Alt标签，用来描述图片的关键词，可以不写。
> 缺点：不灵活不好分享，本地图片的路径更改或丢失都会造成markdown文件调不出图。


### 2.2 插入网络图片
只需要在markdown插入图片语法的括号中填入图片网络链接：
```
![Alt text](网络图片链接)
eg: ![avatar](http://baidu.com/pic/doge.png)
```
>  缺点：图片存在网络服务器上，非常依赖网络。


### 2.3 把图片存入markdown文件
鉴于前两种方法存在的问题，现在推荐第三种方法：首先把图片转换成一段 base64 字符串，然后把字符填入 markdown 插入图片基础语法中的括号里。基础用法如下：
```
![Alt text](iVBORw0K......)
```
但是你会发现，base64字符串很长，这么长一段字符串横在文档中间，一定十分影响文档编辑体验，所以推荐如下方式：把大段的 base64 字符放在末尾，通过一个 ID 来调用：
```
![avatar][base64str]
[base64str]:data:image/png;base64,iVBORw0K......
```

## 3 如何得到图片的 base64 字符串呢
python 代码如下：

```
python image2base64.py  "图片的本地路径"
eg: python image2base64.py "C:\Users\pgong\Pictures\30972457.png"
# 会在图片目录下得到一个与图片名相同 base64 的 .txt 文件
```



```python
# coding = UTF-8
# image2base64.py

"""
this will  convert image file to Base64 string
"""

import os
import base64
import argparse

#def get_filename(absolute_path):


def write_to_txt(string,filename): #(base64字符串，绝对路径文件名)
    (dir_name,base_filename) = os.path.split(filename)
    base_filename = os.path.splitext(base_filename)[0]
    suffix = '_base64.txt'
    txt_name = os.path.join(dir_name,base_filename + suffix ) #拼接包含路径的 txt 文件名
    #print(txt_name)
    #print(dir_name)
    f = open(txt_name,'w')
    f.write(string)
    f.close


def convert(filename):
    f=open(filename,'rb') #二进制方式打开图文件
    ls_f=base64.b64encode(f.read()) #读取文件内容，转换为base64编码
    write_to_txt(ls_f,filename)
    f.close()


def get_parser():
    parser = argparse.ArgumentParser(description='change extension of files in a working directory')
    parser.add_argument('filename', metavar='FILENAME', type=str, nargs=1, help='photo`s filename')
    return parser


def main():
    parser = get_parser()
    args = vars(parser.parse_args())
    filename = args['filename'][0]
    convert(filename)


if __name__ == '__main__':
    main()
```

