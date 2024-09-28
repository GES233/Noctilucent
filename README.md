# 夜光云

一个内网部署的轻量化自建社交网络服务。

代码架构参考了[Bytepack](https://github.com/dashbitco/bytepack_archive)。

## 路线图

### 页面

- [ ] 用自己的代码取代掉 Phoenix 脚手架
  - [ ] 首页
  - [ ] 颜色主题
  - [ ] 「打倒 `CoreComponent`」 *彻底替换掉原来的 CoreComponents*

### 业务

- [ ] 用户（*纯粹的业务逻辑层面，不考虑鉴权相关*）
  - [ ] 用户的基本信息
  - [ ] 用户的注册与认证
    - 无邮件服务的内网服务不支持认证邮件
- [ ] 最基本的内容载体
  - 纯 Markdown 就可以了

### infra

#### 鉴权

- 网页
  - Session Cookie
- 应用
  - Token

#### 音频直播

- [ ] 实时服务的可行性
  - 现实例子：Discord 等
- [ ] 相关算法（例如人声基频的判断）
