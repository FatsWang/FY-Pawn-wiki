# 📦 [FyPawn] 使用指南

> **当前版本：** v1.0.0 &nbsp;&nbsp;|&nbsp;&nbsp; **支持引擎：** UE 4.26 - 5.7 &nbsp;&nbsp;|&nbsp;&nbsp; **更新日期：** 2026-04-21

欢迎使用 **[FyPawn]**  ！本插件专为数字孪生及智慧城市项目开发;
旨在解决 [专为数字孪生、智慧园区与设计院汇报打造的 C++ 底层漫游 Pawn。彻底弃用弹簧臂，采用射线绝对物理打点，提供极致丝滑的“抓手平移”与“定点旋转”手感。内置 GameplayTag 零代码全局视角跳转系统。] 问题。

---

### 🛒 1. 获取方式

本插件已上架官方 Fab 商城，支持正版，享受后续永久免费更新。

* 👉 **[点击此处前往 Fab 商城获取插件](https://www.fab.com/zh-cn/listings/10bb85fd-3c35-480f-975f-c4583b58dd1e)** ---

### 📺 2. 视频教程

俗话说一图胜千言，视频教程更直观！强烈建议在阅读文档前，先观看我在 B 站录制的使用演示：

* ▶️ **[B站视频：[插件名称] 保姆级入门与实战演示](https://www.bilibili.com/video/BV1f6DfBoEHy)**

---

### ⚙️ 3. 安装步骤

1.  **下载**：在 Fab 商城购买或下载插件包。
2.  **解压**：将压缩包解压，你将得到一个名为 `YourPluginName` 的文件夹。
3.  **放入工程**：打开你的 UE 工程目录，在根目录下创建一个名为 `Plugins` 的文件夹（如果没有的话）。
4.  **复制**：将解压后的 `YourPluginName` 文件夹复制到 `Plugins` 目录下。
5.  **重启引擎**：重新打开你的 UE 工程。在顶部菜单栏选择 `Edit -> Plugins`，搜索插件名称，勾选 `Enable`，并根据提示再次重启引擎即可。

详情请参考安装教程：[FyPawn 安装指南](/ue-plugins/FyPawn/install.md)

---

### 🔌 4. 核心节点介绍

本插件封装了以下核心蓝图节点，方便你在任意 Blueprint 中调用：

| 节点名称 (Node) | 输入参数 (Inputs) | 输出结果 (Outputs) | 功能描述 (Description) |
| :--- | :--- | :--- | :--- |Markdown
| **`Init Twin Data`** | `String URL` <br> `Int Port` | `Boolean Success` | 初始化数据流连接，配置 IP 和端口。 |
| **`Spawn Actor By JSON`** | `JSON Object` | `Actor Reference` | 解析 JSON 数据，并在场景中动态生成对应的 3D 资产。 |
| **`Update Transform`** | `Actor Ref`<br>`Vector Loc` | `None` | 平滑更新指定物体的坐标，附带缓动插值效果。 |

> 💡 **Tip / 提示：**
> 在调用 `Spawn Actor By JSON` 之前，请务必确保 `Init Twin Data` 节点返回的是 `True`，否则会导致数据解析失败。

---

### 🛠️ 5. 常见问题 (FAQ)

**Q：打包项目时报错，提示缺少模块怎么办？**
A：请检查你的 `.uproject` 或 `Build.cs` 文件，确保已经在 `PublicDependencyModuleNames` 中添加了 `"YourPluginName"` 模块。

**Q：插件支持多人联机 (Replication) 吗？**
A：当前版本（v1.0）的节点主要运行在 Client 端（客户端渲染），暂未原生支持 Server 端的属性同步。联机功能将在后续版本中更新。

---

<div style="text-align: center; color: #86868b; font-size: 13px; margin-top: 40px;">
  技术支持：如有其他未解问题，欢迎在 B 站视频下方留言，或前往 <a href="../contact.md" style="color:#007aff; text-decoration:none;">联系页面</a> 咨询。
</div>