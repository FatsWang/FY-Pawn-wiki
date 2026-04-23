# 🚀 UE5 数字孪生高级视角控制插件 (DT Camera Controller) 使用手册



## 一、引擎安装



在Epic Fab商城搜索 Wangpangpang 或 Advanced Digital Twin，就可以搜索到了，购买成功后







![img](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/c1f5c64f262246de87adcacb4773351e.png)



回到你的Epic启动器，在“库”里找到它，如果没有找到，你可以点击上方的刷新按钮就可以找到了



![image-20260421154034254](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/image-20260421154034254.png)



找到以后，点击安装到引擎，选择对应的引擎版本，点击安装就可以了。



![在这里插入图片描述](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/43d22a8200ac4c8fb5898c3b3e8eadf4.png)



这个时候，打开你的引擎-插件-fypwn 就可以看到插件已经安装上了。勾选启用，并重启工程，就算是正常把插件启用了。

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260421160756632.png)







## 3. 核心基础操作指南

本控制器提供最符合直觉的键鼠交互方案：

* **左键交互**：

* **按住拖拽**：射线实时计算差值，实现“抓手级”平移。

* **双击（Double Click）**：自动跳转至鼠标点击的物理位置（支持配置缓动时间、保留距离约束及是否自动朝向目标点）。

* **右键交互**：

* **按住旋转（360°）**：

* *模式A（默认中心点）*：以当前屏幕视野中心点进行射线检测，围绕碰撞点旋转。

* *模式B（鼠标锚点）*：以当前鼠标位置发射射线，围绕检测到的世界坐标点进行旋转。

* **Set Record Grab Anchor 用来设置抓手平移的锚点位置**：

* bUseMouseLocation 变量可以选择是以鼠标位置还是以当前视野中心点作为锚点。

* **Double Clicke Jump**

* *bCameraDistance 用来设置双击跳转时，镜头与目标点之间的距离。*

* *IsFacing? 用来设置双击跳转后，镜头是否自动朝向目标点。*

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-123038252418822176083rOQMV.png)





* **滚轮交互**：

* **滚动缩放**：平滑推进/拉远视角，支持自定义最近与最远极限距离。

* **Update Track Zoom**：

* 用于在蓝图中动态调整当前缩放距。

* **Update Track Move**：

* 用于在蓝图中动态调整当前平移位置。

* Update Track Rotation**；

* 用于在蓝图中动态调整当前旋转角度。



![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-16420077251820918760KAFlf0.png)





## 4. 核心系统与蓝图组件解析



### 4.1 核心控制器：BP_FlyPawn

这是玩家操控的实体，内部封装了所有输入响应与跳转逻辑。

* **全局视角跳转函数 (`SwitchCameraLocation`)**：通过传入 `GameplayTag`，在已注册的相机列表中筛选目标，并调用 `SwitchRoleState` 同步状态与数据，最后执行的Transform插值过渡。

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-16743967230350881990g6oF3m.png)



### 4.2 标签相机节点：BP_TargetCamera

用于在场景中布置预设的汇报视角。

* **快捷摆放技巧**：将相机拖入场景后，

* 右键选择 **“控制（Pilot） BP_TargetCamera”**，使用WASD像玩游戏一样找好完美视角，

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-703012229084915298xZjuhn.png)



* 随后点击左上角“停止控制”即可锁定机位。



* ![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-34197906418191339836t3xyR.png)





* **核心配置参数 (`BP_PawnState` 结构体)**：

* `CameraTag`：相机的唯一身份标识（GameplayTag）。

* `RotationMode`：旋转模式（中心旋转 vs 鼠标锚点旋转）。

* `PawnConfig` (嵌套结构体)：

* 权限开关：双击定位、鼠标平移、键盘移动、滚轮缩放。

* 约束限制：`ZoomLimits` (Vector2D，限制最大/最小缩放距离)、`PitchLimits` (仰俯角上下限)。

* `TargetTransform`：记录相机的空间信息（位置、旋转、缩放）。



![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-5502231140928476444LCUnHs.png)



* **初始化与扩展接口**：

* **主动注册机制**：在 `BeginPlay` 时，将自身的Tag与Actor引用传给Pawn，避免后期查找性能损耗。



![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-15976870905842129584xxxCV2.png)



* **事件接口 (`SwitchCameraTag`)**：触发跳转时同步调用，用于开发者编写进阶的自定义逻辑（如：镜头到位后自动播放特定的UI动画或Niagara粒子特效）。

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-1126486380267207981pxcSKp.png)



### 4.3 场景边界限制：BP_MapEdge

* **功能描述**：基于样条线（Spline）的区域限制工具。

* **使用方法**：拖入场景，绘制包围城市的样条线形状。
  ![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-10611110228415164918BUz6Xg.png)
* 选中玩家控制的 `BP_FlyPawn`，在细节面板中指定该样条线Actor，即可防止玩家视角飞出模型边界。
![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-18128528496197000136JLKJ3j.png)




## 5. UI交互与配置实战



### 5.1 快速部署跳转按钮 (WBP_Button)

* 可在任意UI（UMG）面板中搜索并拖入 `WBP_Button` 组件。

* **参数配置**：

* 在细节面板设置 `ButtonName`（显示文本）。

* 选择对应的 `CameraTarget`（对应的 GameplayTag）。

* 运行时点击该按钮，系统会自动触发 `BP_FlyPawn` 的全局跳转逻辑，镜头将平滑漫游至对应标签的相机位置。

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-89732756401469953888HCCkx.png)



![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-3579154040224097331CqkJte.png)



### 5.2 如何管理与新增 GameplayTags

* **复用分组**：在标签选择下拉框中，点击已有分组（如 `TargetCamera.`）后面的“+”号，修改后缀名（如改为 `.Camera06`）即可快速添加。

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-2621520859934981106issG0r.png)