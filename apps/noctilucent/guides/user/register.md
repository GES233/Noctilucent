# 注册

注册业务预计使用两种接口：一种是命令行接口；另一种是网络接口。

## 业务流程

目前的注册采用开放注册制，只需要用户名以及密码即可。

其中，用户名允许空格、制表符外的 ASCII 字符。

参见 `Noctilucent.Account.User.username_changeset/2` 。

密码需要字母，参见 `Noctilucent.Account.User.validate_password/1` 。

## 事务记录
