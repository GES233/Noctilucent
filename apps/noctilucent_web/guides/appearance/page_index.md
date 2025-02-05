# 首页

![img](assets/index.png)

## 背景

计划：采用 Tailwind 组件或 CSS 手搓一个类似于夜光云的画面。

## 内容

### Header

导航栏：

- 关于（左侧）
- 登录/注册相关（右侧）

### Main

Title: Noctilucent

Description: 借用了宠物蜥蜴娘的某首歌的歌词，从俄文翻译到英文。

采用了如下来实现发光效果：

```css
text-shadow:0 0 8px rgba(255, 255, 255, 0.8),
            0 0 16px rgba(255, 255, 255, 0.6),
            0 0 32px rgba(173, 216, 230, 0.5);
```

### Footer

关于网站：

- Powered by ...
- 统计信息

对应的背景：地面的部分

## 引入登录系统后的安排

默认不显示该首页，除非地址栏存在设置 `?skip_welcome=false` 。
