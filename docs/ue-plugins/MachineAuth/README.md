# WPPMachineAuth 授权码生成器使用说明

> 版本：v1.0.0 | 引擎：Unreal Engine 5.x | 更新日期：2026-06-18

WPPMachineAuth 授权码生成器是给插件开发者使用的发卡端工具。你用它创建 RSA 密钥对、保存私钥、导出公钥，并根据客户机器码签发授权码。UE 项目里只放公钥，客户应用只负责验证授权码，不能反向伪造授权码。



## 1. 工作原理

WPPMachineAuth 使用 RSA-2048 非对称加密完成授权验证：

- 私钥必须只由开发者保管。谁拿到私钥，谁就能签发授权码。
- 公钥可以放进 UE 项目。公钥只能验证授权码，不能生成授权码。
- HTML 工具源码公开不是核心风险，私钥泄露才是核心风险。

工具页面默认把密钥对保存在当前浏览器的 `localStorage` 中。清理浏览器数据、换浏览器或换电脑都会导致页面里的密钥列表消失，所以私钥一定要导出 `.pem` 文件并离线备份。

## 2. 快速开始

### 2.1 打开工具



页面包含 4 个区域：

| 区域 | 用途 |
| --- | --- |
| 生成授权码 | 根据客户机器码签发授权码 |
| 密钥管理 | 新建、导入、导出和删除 RSA 密钥对 |
| 使用说明 | 查看页面内快速流程 |
| 关于作者 | 查看作者与售后联系方式 |

### 2.2 创建第一个密钥对

1. 打开「密钥管理」。
2. 点击「+ 新建密钥对」。
3. 输入项目名称，例如 `MyGame`。
4. 点击「生成」。
5. 在弹出的密钥详情中导出私钥 `.pem`，并保存到安全位置。
6. 复制公钥，准备填入 UE 项目的 `RSAPublicKey`。

> 私钥不要提交到 GitHub，不要放进 UE 项目，也不要发给客户。

### 2.3 把公钥配置到 UE

在你的授权 Widget 蓝图中设置父类为 `WPPMachineAuthWidget`，然后选择其中一种方式填写公钥：

- 在 Widget Blueprint 的 Class Defaults 中填写 `RSAPublicKey`。
- 在蓝图 `Create Widget` 节点中，通过 `RSAPublicKey` 引脚传入公钥。

公钥必须保留完整 PEM 头尾：

```text
-----BEGIN PUBLIC KEY-----
...
...
-----END PUBLIC KEY-----
```

## 3. 密钥管理

### 新建密钥对

推荐每个 UE 项目使用独立密钥对：

```text
项目 A -> 密钥对 A -> 项目 A 的 RSAPublicKey
项目 B -> 密钥对 B -> 项目 B 的 RSAPublicKey
```

这样即使某个项目的私钥泄露，也只影响这个项目。

### 切换当前密钥

你可以在「生成授权码」顶部下拉框选择当前密钥，也可以在「密钥管理」中点击某个密钥条目。当前选中的密钥会用于下一次签发。

### 导入已有私钥

如果浏览器里的密钥记录丢失，但你还保留 `.pem` 私钥文件：

1. 打开「密钥管理」。
2. 点击「导入已有私钥」。
3. 输入项目名称。
4. 粘贴完整私钥内容。
5. 确认导入。

工具会根据私钥重新解析出公钥。

### 删除密钥对

删除只会移除当前浏览器 `localStorage` 中保存的密钥记录，不会让已经发给客户的授权码失效。

> 删除前请确认你已经离线备份私钥。私钥丢失后无法恢复，只能生成新密钥对并更新 UE 项目的 `RSAPublicKey`。

## 4. 签发授权码

### 操作步骤

1. 打开「生成授权码」。
2. 选择正确的密钥对。
3. 输入客户提供的机器码。
4. 设置授权天数。
5. 设置最大次数，`-1` 表示不限次数。
6. 点击「生成授权码」。
7. 复制授权码并发送给客户。

### 客户激活流程

1. 客户打开你的 UE 应用授权界面。
2. 客户点击 `CopyMachineCodeButton` 对应按钮，把机器码发给你。
3. 你在工具中签发授权码。
4. 客户把授权码粘贴到 `LicenseKeyInput` 对应输入框。
5. 客户点击 `ActivateButton` 对应按钮。
6. 插件验证授权码，并通过 `OnMachineAuthResult` 广播结果。

## 5. UE Widget 接入

### 创建 Widget 蓝图

1. 在 Content Browser 中创建 Widget Blueprint。
2. 父类选择 `WPPMachineAuthWidget`。
3. 建议命名为 `WBP_MachineAuth`。
4. 在 Class Defaults 中填写 `RSAPublicKey`，或在创建 Widget 时传入。
  ![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/16e026bdade4c0777788ef364c1f8a88.png)

### 必要 UMG 控件名

如果你想使用插件内置按钮流程，请在 Widget 中使用以下控件名称：

| 控件类型 | 控件名 | 用途 |
| --- | --- | --- |
| `TextBlock` | `MachineCodeText` | 显示当前机器码 |
| `EditableTextBox` | `LicenseKeyInput` | 输入客户授权码 |
| `Button` | `ActivateButton` | 点击后执行激活 |
| `Button` | `CopyMachineCodeButton` | 点击后复制机器码 |
| `TextBlock` | `StatusText` | 显示验证状态 |

这些控件都是可选绑定。缺少某个控件时，对应 UI 行为不会执行，但 Widget 仍可构造。
![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260618172955141.png)

### 创建时传入公钥

`RSAPublicKey` 已设置 `ExposeOnSpawn`，所以可以在 `Create Widget` 节点上直接传入：

```text
Create Widget (Class = WBP_MachineAuth)
  RSAPublicKey = -----BEGIN PUBLIC KEY-----...-----END PUBLIC KEY-----
Add to Viewport
```

不要把内部总配置 `AuthConfig` 暴露给蓝图创建流程。常规接入只需要配置 `RSAPublicKey`。

## 6. 蓝图接口参考

### 结果事件

`OnMachineAuthResult(bool bSuccess, FString Source, FString Message)`

| 参数 | 说明 |
| --- | --- |
| `bSuccess` | 是否成功 |
| `Source` | 结果来源，例如 `Activation`、`Validation` 或配置检查来源 |
| `Message` | 成功提示或失败原因 |

典型蓝图逻辑：

```text
OnMachineAuthResult
  Branch (bSuccess)
    True  -> Remove from Parent -> Open Level
    False -> 显示 Message，停留在授权界面
```

### 常用函数

| 函数 | 说明 |
| --- | --- |
| `GetMachineCode()` | 获取当前配置生成的机器码 |
| `ClearCachedLicense()` | 清理 `Project/Saved/<LocalLicenseFileName>` 下的本地授权缓存 |
| `ConfigureMachineAuth()` | 运行时设置 RSA 公钥 |
| `ConfigureMachineAuthStorage()` | 运行时设置本地缓存和影子文件参数 |
| `ConfigureMachineAuthMachineCode()` | 运行时设置机器码规则 |
| `ConfigureMachineAuthTime()` | 运行时设置网络授时和时间回滚检测 |
| `ConfigureMachineAuthEncryption()` | 运行时设置本地缓存和影子文件 AES 盐值 |
| `ConfigureMachineAuthUI()` | 运行时设置状态文字颜色 |

`Configure...` 函数只更新配置，不会主动重新验证。普通蓝图接入优先使用 `RSAPublicKey`，只有高级定制时再调用这些函数。

## 7. 安全与公开发布建议

### 可以公开的内容

- `license_tool.html` 的页面源码。
- UE 项目中的 `RSAPublicKey`。
- 生成器的使用说明。

### 不能公开的内容

- RSA 私钥。
- 包含私钥的 `.pem` 文件。
- 浏览器导出的密钥备份。
- 任何能访问私钥的后台环境变量或接口密钥。

### 上传到 GitHub 或部署网页时

如果你把 `license_tool.html` 上传到 GitHub Pages、静态网页或公开文档站：

- 不要把自己的私钥写进 HTML。
- 不要把私钥 `.pem` 放进仓库。
- 只让可信的签发者在自己的浏览器中导入私钥并签发授权码。
- 私钥仍会保存在签发者浏览器的 `localStorage` 中，请使用可信电脑和浏览器。

如果需要多人协作、审计、权限控制或防止私钥落到浏览器里，建议后续改成服务端签发模型：私钥只放服务器，网页只提交机器码和授权参数。

### 本地授权缓存

插件会把授权状态加密保存到本地，并配合影子文件记录使用次数和时间信息。默认关键路径包括：

| 项 | 默认值 |
| --- | --- |
| 本地授权缓存 | `Project/Saved/License.dat` |
| 影子文件目录 | `%LOCALAPPDATA%/Microsoft_Windows_Cache/` |
| 主影子文件 | `sys_config.bin` |
| 冗余影子文件 | `sys_core_module.dll` |
| 时间回滚参考文件 | `C:/Windows/System32/kernel32.dll` |

`ClearCachedLicense()` 只清理本地授权缓存，不会清理影子文件。

## 8. 常见问题

### 私钥丢了怎么办？

无法恢复。你需要创建新密钥对，并把新公钥更新到 UE 项目的 `RSAPublicKey`。旧版本中已经配置旧公钥的应用，只能验证旧私钥签发的授权码。

### 公钥泄露会有风险吗？

公钥可以公开。它只能验证授权码，不能签发授权码。真正需要保护的是私钥。

### 客户换电脑后还能继续用吗？

通常需要重新签发。机器码会跟客户机器环境绑定，换电脑或硬件环境变化后，机器码可能改变。

### 可以把这个 HTML 发给客户吗？

不建议。这个工具是开发者发卡端，客户只需要 UE 应用里的授权界面。即使 HTML 本身可以公开，也不要把包含私钥的浏览器环境或私钥文件交给客户。

### 授权码生成后没有保存记录怎么办？

当前工具不再提供页面内记录列表。需要留档时，建议你在自己的订单系统、表格或售后记录中保存客户、机器码、授权天数和签发时间。

## 9. 技术支持

| 渠道 | 信息 |
| --- | --- |
| 微信 | **17610986288**（备注 `WPPMachineAuth`） |
| B站 | [常胜将军王胖胖](https://space.bilibili.com/354782208#/) |
| FAB 商城 | [WPPMachineAuth 插件主页](https://www.fab.com/listings/c498f463-107e-47d9-88b5-a4a2bce3c3d6) |
| 知乎 | [csjjwpp](https://www.zhihu.com/people/csjjwpp) |
| 在线文档 | [https://www.fywpp.top](https://www.fywpp.top/#/ue-plugins/MachineAuth/README) |

---

<div align="center">

**WPPMachineAuth - 让每一份 UE 资产都受保护**

© 2022-2026 常胜将军王胖胖 (WangPangPang). All Rights Reserved.

</div>
