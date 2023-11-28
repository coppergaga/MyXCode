# 目标

期望为Xcode增加一些常用能力扩展

# 使用

1. 将编译产物**MyXCode**放入**Application**文件目录中
2. 运行**MyXCode**
3. 打开*系统设置* -> *隐私与安全性* -> *扩展* -> *Xcode Source Editor*，打勾启用
4. 打开Xcode，在Editor菜单最底部会出现MyXCodeExt选项，至此即可使用
5. 可以在Xcode -> *设置* -> *KeyBindings*中为这些扩展设置快捷键

# Feat List

## 快速换行

## Swift代码块格式化

[规则支持](https://github.com/apple/swift-format/blob/main/Documentation/Configuration.md)

插件使用了苹果提供的[格式化能力](https://github.com/apple/swift-format/tree/main)

# Local Compile

1. clone this Project
2. 进入根目录，打开MyXCode.xcodeproj
3. 使用自己的Apple Developer账号（无需成为Developer Program会员，普通开发账号就行）
4. 替换**ConstValue**文件中的*GroupIdentifier*为你自己的
5. build and run
