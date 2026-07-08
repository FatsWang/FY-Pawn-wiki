# UE 如何使用 NVIDIA DLSS 和设置 DLSS 参数

> DLSS（深度学习超级采样）支持 DLSS-SR / DLSS-FG / DLSS-RR，有效提升场景 FPS，远离卡顿。

---

## 1. 下载

前往 **NVIDIA DLSS 官网**下载插件：
<https://developer.nvidia.com/rtx/dlss?sortBy=developer_learning_library/sort/featured:desc,title:asc&hitsPerPage=6#getstarted>

![DLSS 官网](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105506.png)

---

## 2. 安装

往下拉找到下载位置，记得选择对应 UE 版本。

![选择版本](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105630.png)

复制好插件之后，重启引擎。

---

## 3. 启用插件

在 **插件管理** 中勾选以下 DLSS 相关插件，然后重启引擎：

![勾选插件](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105645.png)

![启用 DLSS](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105655.png)

> **注意**：启用插件后，运行项目时会自动开启 DLSS。编辑模式下默认不启用 DLSS，如需在编辑模式下启用，请勾选上图中的选项。

---

## 4. 设置 DLSS 参数的节点介绍

### 4.1 `Set DLSS/DLAA Mode (No Auto)`

![No Auto 模式](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105708.png)

**功能：**

- **DLSS Mode**：手动设置 DLSS 模式，可选择关闭（Off）或启用不同模式（如性能模式、质量模式等）。
- **DLAA Enabled**：勾选后启用 DLAA（基于深度学习的抗锯齿技术）。
- **Restore Full Res When Disabled**：勾选后，当 DLSS 被禁用时，渲染将恢复为全分辨率。

**适用场景：**
需要手动控制图像质量与性能之间平衡的场景，不依赖自动调整。

---

### 4.2 `Set DLSS/DLAA (Auto Mode)`

![Auto 模式](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105723.png)

**功能：**

- **Screen Resolution (X, Y)**：手动设置期望的屏幕分辨率。
- **DLSS Auto**：勾选后，DLSS 以自动模式运行，根据渲染负载和显示分辨率自动调整抗锯齿效果和超分辨率。
- **DLAA Enabled**：启用 DLAA 的选项。
- **Restore Full Res When Disabled**：禁用 DLSS 后恢复全分辨率。

**适用场景：**
相比手动模式，强调自动化功能，适合快速实现"即开即用"的优化方式。

---

### 4.3 `Set DLSS-FG Mode`（帧生成）

![DLSS-FG 模式](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105824.png)

**功能：**

- **DLSSGMode**：设置 DLSS 帧生成（Frame Generation）模式，控制是否启用 AI 补帧功能。

**适用场景：**
通过 AI 算法生成额外帧，提升游戏流畅度和表现力。

---

### 4.4 DLSS-SR（Super Resolution — 超分辨率）

![DLSS-SR](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105838.png)

**功能：**
通过 AI 降低渲染分辨率（如从 1080p 升频到 4K），提升帧率（FPS）并保持画质清晰。

**适用场景：**
性能优先，需提高帧率时（如高分辨率或复杂场景）。

---

### 4.5 DLSS-RR（Ray Reconstruction — 光线重建）

![DLSS-RR](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260612105847.png)

**功能：**
DLSS 3.5 新增特性，专注于优化光线追踪（Ray Tracing）效果，通过 AI 重建光线路径，减少噪点并提升光线追踪的细节和效率。

**适用场景：**
光线追踪密集型场景（如全局光照、反射、阴影），需提升画质和性能。

---

> **版权声明**：本文为 CSDN 博主「弦月0125」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
> 原文链接：<https://blog.csdn.net/z1162562943/article/details/148069607>
收到，小金持续为你保驾护航！提到 DLSS（深度学习超采样），你绝对是摸到了超大分辨率优化的**核心法门**！在 15360x2880 这种“地狱级”分辨率下，DLSS 就是你全村的希望。

针对你的三个问题，我们逐一进行“技术美术级”的拆解。

---









# 关于与Gemini


### 1. 开启 DLSS 对于 15K 分辨率有优化吗？

**答案是：有，而且是质的飞跃！**

* **算力降维打击**：之前我们用 `r.ScreenPercentage` 或者 TSR，消耗的都是显卡通用计算单元（CUDA核心）的算力。而 DLSS 直接调用 NVIDIA 显卡里专门用于 AI 计算的**张量核心（Tensor Cores）**。它能在内部以极低的分辨率（比如 4K 甚至 2K）渲染画面，然后靠 AI 脑补成 15K 输出。
* **对抗摩尔纹的利器**：DLSS 的抗锯齿和高频细节重建能力远超 UE 原生的 TSR 和 TAA。开启后，你之前那个轨道闪烁、摩尔纹的问题大概率会被彻底抹平。
* **帧率暴涨**：在 15K 环境下，开启 DLSS（性能模式）通常能让你的帧率提升 2 倍到 4 倍不等。

### 2. 部署的主机显卡是 Pro 5000，需要额外驱动吗？

**“Pro 5000” 是一张好卡，但你需要避开一个常见的“硬件认知陷阱”。**

你指的大概率是 **NVIDIA RTX A5000**（或者老一代的 Quadro RTX 5000）。这两张都是专业的图形工作站显卡。

* **DLSS 支持情况**：完美支持 **DLSS 2（超分辨率）**。
* **⚠️ 避坑警告（小金划重点）**：RTX A5000 属于 Ampere 架构（相当于 RTX 30 系列），它**不支持 DLSS 3 的“帧生成（Frame Generation）”技术**（帧生成需要 RTX 40 系列或 RTX Ada 架构）。所以在使用插件时，不要去开启 Frame Generation，否则不仅没用，还可能报错。
* **驱动要求**：
* **必须安装**：去 NVIDIA 官网下载最新的 **NVIDIA RTX Enterprise Production Branch Driver**（企业级生产力驱动，以前叫 Quadro 驱动或 Studio 驱动）。**千万不要装 Game Ready 游戏驱动**，在现场大屏多屏拼接时，游戏驱动极易崩溃。
* **不需要额外程序**：不需要装 GeForce Experience，只要纯净的显卡驱动即可。DLSS 的运行库是打包在你的 UE 游戏程序里的。



### 3. 我该怎么做？（从集成到调用的全链路实操）

既然要用 DLSS，我们需要让它接管抗锯齿和屏幕百分比控制。

#### 第一步：安装并开启插件

1. **获取插件**：Epic 商城里搜不到官方的 DLSS，你需要去 **NVIDIA Developer 官网** 下载适用于你对应 UE 版本（如 5.3 或 5.4）的 DLSS 插件包。
2. **解压放入项目**：将解压后的 `DLSS` 文件夹丢进你项目根目录下的 `Plugins` 文件夹中（如果没有这个文件夹就新建一个）。
3. **重启引擎**：在 `Edit` -> `Plugins` 里搜索 DLSS，勾选 **NVIDIA DLSS Super Resolution**，重启引擎。

#### 第二步：在蓝图中动态控制 DLSS（推荐做法）

不要在编辑器里死调，我们需要在游戏启动时通过蓝图激活它。在你的 `GameInstance` 或 `GameMode` 的 `BeginPlay` 节点后，进行如下连线：

1. **检查硬件支持**：调用 `Is DLSS Supported` 节点。如果返回 True，再往下走（防止万一显卡不支持导致程序崩溃）。
2. **设置抗锯齿模式**：DLSS 会自动接管抗锯齿，但保险起见，用 `Execute Console Command` 执行 `r.AntiAliasingMethod 4`（4代表TSR/DLSS等时序方法）。
3. **设置 DLSS 模式（核心步骤）**：
* 调用 **`Set DLSS Mode`** 节点。
* 这里有个下拉菜单，包含：`Quality`（质量）、`Balanced`（平衡）、`Performance`（性能）、`Ultra Performance`（超级性能）。
* **小金建议**：在 15K 分辨率下，果断选择 **`Ultra Performance` (超级性能)**。这会让引擎内部以接近 5K 的分辨率渲染，再放大到 15K，这是 A5000 能抗住的最佳平衡点。



#### 第三步：C++ / CVar 备选方案

如果你习惯用控制台命令，也可以在初始化时执行：

* `r.NGX.DLSS.Enable 1` (开启 DLSS)
* `r.NGX.DLSS.Quality -1` (对应超级性能模式)

---

### 🎯 小金的课后延展（下一步探讨）

当你开启 DLSS Ultra Performance 后，帧率应该能有一个巨大的回升，但同时，极高倍率的 DLSS 可能会在场景中快速移动的物体边缘产生轻微的**拖影（Ghosting）**。

你可以先按上面的步骤在本地打包测试一下。**想问一下，你这个 15K 场景里，主要是静态的建筑/展厅漫游，还是有大量快速移动的车辆或特效（比如飞速运行的列车）？** 这决定了我们是否需要进一步去调整由于 DLSS 带来的时序拖影问题。