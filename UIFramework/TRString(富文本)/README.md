#TRString
 
1. 字符串拼接，.append()和,.string()方法内可以直接传入基本类型及NSString类型，也可以直接传入对象。
2. 做了空处理，对Null，nil，长度为0的字符串做了处理，默认转换为@"",可以通过.null()进行设置。

##文本使用
```
TRString.string(@"hello")
        .append(10086)
        .append(3.14)
        .append(CGRectMake(0, 0, 10, 10))
        .append([NSNull null])
        .append(nil)
        .null(@"-ERROR-")
        .toString;
```
console 

```
hello100863.14{{0, 0}, {10, 10}}-ERROR--ERROR-
```

##富文本使用

```
TRString.string(@"red").color([UIColor redColor]).fontSize(16)
        .append(@"blue").color([UIColor blueColor]).fontSize(18)
        .append(@"green").color([UIColor greenColor]).fontSize(22).ln()
        .append(nil).color([UIColor purpleColor]).fontSize(30).ln()
        .append(CGPointMake(0, 0)).color([UIColor brownColor]).fontSize(36).ln()
        .append([NSNull null]).color([UIColor whiteColor]).font(@"GillSans-Light", 42).ln()
        .append(1).color([UIColor whiteColor]).fontSize(23).ln()
        .append(1.2).color([UIColor whiteColor]).fontSize(50).ln()
        .null(@"-ERROR-")
        .toAttributedString;
```
![输出效果](https://git.oschina.net/uploads/images/2017/0721/101849_ec2b170d_752853.png "Simulator Screen Shot 2017年7月21日 10.17.10副本.png")