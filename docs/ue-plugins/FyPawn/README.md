<div style="text-align: center; padding: 40px 0 30px 0;">
  <h1 style="font-size: 2.2em; font-weight: 800; color: #1d1d1f; letter-spacing: -0.5px; border: none;">📦 [FyPawn] 使用指南</h1>
</div>


> **当前版本：** v1.0.0 &nbsp;&nbsp;|&nbsp;&nbsp; **支持引擎：** UE 4.26 - 5.7 &nbsp;&nbsp;|&nbsp;&nbsp; **更新日期：** 2026-04-23

* 欢迎使用`FyPawn`！🎉

* 本插件专为 **数字孪生**、**智慧园区**与**设计院汇报**打造的 C++ 底层漫游 Pawn。

* 旨在解决传统弹簧臂组件在数字孪生应用中的**性能**和**手感**问题。

* 彻底**弃用弹簧臂**，采用**射线绝对物理打点**，提供极致丝滑的 **"抓手平移"** 与 **"定点旋转"** 手感。🔧

* 基于 `GameplayTags`（🎮标签）的全局视角管理与无缝跳转。

* **性能友好**：采用⚡事件驱动与启动时“主动注册”机制，拒绝高昂的每帧遍历（Tick/GetAllActors）开销。🚀

---

## 🛒 1. 获取方式

本插件已上架官方 Fab 商城，支持正版，享受后续永久免费更新。

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/c1f5c64f262246de87adcacb4773351e.png)

* 👉 **[点击此处前往 Fab 商城获取插件](https://www.fab.com/zh-cn/listings/10bb85fd-3c35-480f-975f-c4583b58dd1e)** ---

## 📺 2. 视频教程

俗话说一图胜千言，视频教程更直观！强烈建议在阅读文档前，先观看我在 B 站录制的使用演示：

* ▶️ **[B站视频：[FyPawn] 保姆级入门与实战演示](https://www.bilibili.com/video/BV1f6DfBoEHy)**

* ▶️ **[B站视频：[FyPawn] 核心原理与设计思路（录制中）](https://www.bilibili.com/video/BV1f6DfBoEHy)**

---



## 📜 3. 目录结构与快速体验

* **资源目录**：
* `Blueprints`（蓝图）
* `Enums`（枚举）
* `Maps`（地图）
* `Materials`（材质）
* `Models`（模型）
*  `Structs`（结构体）

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-8073295541906045671ouY8dE.png)


* **测试关卡**：打开 `WPP_Pawn_Map` 即可快速体验所有核心控制与跳转功能。

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-675202582372364499802uYHv.png)



## 🛠️ 5. 常见问题 (FAQ)

**Q：打包项目时报错，提示缺少模块怎么办？**
A：请检查你的 `.uproject` 或 `Build.cs` 文件，确保已经在 `PublicDependencyModuleNames` 中添加了 `"YourPluginName"` 模块。

**Q：插件支持多人联机 (Replication) 吗？**
A：当前版本（v1.0）的节点主要运行在 Client 端（客户端渲染），暂未原生支持 Server 端的属性同步。联机功能将在后续版本中更新。

---

<div style="text-align: center; color: #86868b; font-size: 13px; margin-top: 40px;">
  技术支持：如有其他未解问题，欢迎在 B 站视频下方留言，或前往 <a href="../contact.md" style="color:#007aff; text-decoration:none;">联系页面</a> 咨询。
</div>