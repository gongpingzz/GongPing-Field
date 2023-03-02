# ASN.1概述
ASN.1[抽象语法标记](https://baike.baidu.com/item/%E6%8A%BD%E8%B1%A1%E8%AF%AD%E6%B3%95%E6%A0%87%E8%AE%B0/3024369?fromModule=lemma_inlink)（Abstract Syntax Notation One）是一种 ISO/ITU-T 标准，描述了一种对数据进行表示、编码、传输和解码的数据格式。它提供了一整套正规的格式用于描述对象的结构，而不管语言上如何执行及这些数据的具体指代，也不用去管到底是什么样的应用程序。*--来自百度百科 [ASN.1_百度百科 (baidu.com)](https://baike.baidu.com/item/ASN.1/498523?fr=aladdin)* 

ASN.1抽象语法描述信息的示例如下：
```
TestModule DEFINITIONS ::= BEGIN 	-- Module parameters preamble
	Circle ::= SEQUENCE { 			-- Definition of Circle type
	position-x INTEGER, 			-- Integer position
	position-y INTEGER, 			-- Position along Y-axis
	radius INTEGER (0..MAX) 		-- Positive radius
 } 									-- End of Circle type
END									-- End of TestModule
```
ASN.1 广泛应用于5G协议语法定义，以及部分通用协议和工控协议语法定义。

## 编码
除了描述数据的抽象语法，ASN.1还定义了一些方法去编码数据，各种编码方式在**空间，互操作性，效率**方面的能力不同，协议设计者可以选择**文本**，**字节**或者**位**的编码规则。
![](Pasted%20image%2020230302223633.png)

# asn1c
asn1c是一个开源的ASN.1编译器，它能把ASN.1的描述文件转化成c++兼容的c源代码，该代码可用于将本机C语言结构序列化为紧凑且明确的基于 BER/OER/PER/XER 的数据文件，并能将这些文件反序列化回来。BER/OER/PER/XER是编码方式。这是官网地址：[Lev Walkin's home site (lionet.info)](http://lionet.info/) 

从官网下载linux源码，编译之后能得到一个可执行程序asn1c，这就是ASN.1的编译器。编译器的输入就是使用ASN.1编写的数据文件，称为ASN.1模块，如果多个模块之间有依赖，编译时必须同时指定所有模块。编译后的输出主要分为3部分：
1. 由ASN.1模块定义的数据类型转化的对应的.c .h文件
2. 通用编码解码文件（BER/OER/PER/XER）和一些帮助程序
3. 一个主程序可以负责PDU（协议数据单元）和各种编码之间的转化

# 举例
1、这是LDAP协议中使用ASN.1描述 LDAPMessage 消息的部分内容
```
LDAPMessage ::= SEQUENCE {
	 messageID       MessageID,
	 protocolOp      CHOICE {
		  bindRequest           BindRequest,
		  bindResponse          BindResponse,
		  ...,
		  intermediateResponse  IntermediateResponse },
	 controls       [0] Controls OPTIONAL }
```
2、使用编译器转化成C语言类型
```c
/* LDAPMessage */
typedef struct LDAPMessage {
	MessageID_t	 messageID;
	struct LDAPMessage__protocolOp {
		LDAPMessage__protocolOp_PR present;
		union LDAPMessage__protocolOp_u {
			BindRequest_t	 bindRequest;
			BindResponse_t	 bindResponse;
			...
			IntermediateResponse_t	 intermediateResponse;
		} choice;
		asn_struct_ctx_t _asn_ctx;
	} protocolOp;
	struct Controls	*controls	/* OPTIONAL */;
	asn_struct_ctx_t _asn_ctx;
} LDAPMessage_t;
```
3、组装一条 LDAPMessage 消息，组装的参数如下：
>messageID: 1
>protocolOp: BindRequest
>BindRequest中version: 3
>BindRequest中name: uid=a,dc=com
>BindRequest中authentication: password

然后使用BER编码得到字节序：
```shell
0000000: 3020 0201 0160 1b02 0103 040c 7569 643d  0 ...`......uid=
0000010: 612c 6463 3d63 6f6d 8008 7061 7373 776f  a,dc=com..passwo
0000020: 7264                                     rd
```
4、通过网络传输序列化后的内容到对端，对端采用BER解码器以及已知协议消息结构，反序列化得到xml表示的数据内容，也可以反序列化成其他格式：
```xml
<LDAPMessage>
    <messageID>1</messageID>
    <protocolOp>
        <bindRequest>
            <version>3</version>
            <name>75 69 64 3D 61 2C 64 63 3D 63 6F 6D</name>
            <authentication>
                <simple>70 61 73 73 77 6F 72 64</simple>
            </authentication>
        </bindRequest>
    </protocolOp>
</LDAPMessage>
```

# 总结：如何解析ASN.1相关解析
若要解析使用到ASN.1语法描述和编码的协议，首先其编解码的实现是相同的，也就是针对BER，PER等编码规则的解码逻辑应该是相同的；
另一方面常规的思路下若要解析协议，清楚其结构逆向解码即可，对ASN.1语法描述的协议而言，其ASN.1模块（也就是ASN.1描述文件）不就是现成的协议文档吗，其内容就是现成的协议结构，人可读，但是困难，费时，若用机器阅读并翻译成解码代码，就是现成的解码器。
