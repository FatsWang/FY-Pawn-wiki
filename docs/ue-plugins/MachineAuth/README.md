# WPPMachineAuth 使用说明

> 版本：1.0  
> 引擎：Unreal Engine 5.6.0  
> 模块：Runtime  
> 平台：Win64  
> 更新日期：2026-07-08 16:52:07

WPPMachineAuth 是一款 Unreal Engine 5 机器授权插件，用于把 UE 项目、插件或数字孪生交付程序绑定到指定机器运行。它提供 RSA-2048 授权码验证、机器码绑定、本地 AES-256 加密缓存、影子文件防篡改、网络授时和使用次数统计。

本文以当前仓库中的 `Source/WPPMachineAuth/` 和 `Tools/LicenseGenerator/license_tool.html` 为准。

## 适用场景

- UE 项目离线交付后，需要按机器授权。
- 插件、工具或可视化程序需要试用期、正式授权或按客户设备绑定。
- 数字孪生、展厅可视化、工业仿真等项目需要保护交付程序。
- 不想搭建完整账号系统，但需要基础授权、防删除缓存和时间回拨检测。

它不是联网账号系统。它更适合单机授权、离线授权和小团队交付场景。

## 工作原理

```text
开发者端
  1. 创建本地 JSON 密钥库
  2. 生成 RSA-2048 私钥和公钥
  3. 私钥只留在开发者电脑
  4. 用私钥给客户机器码签发授权码

客户 UE 程序
  1. 只内置公钥 RSAPublicKey
  2. 生成本机机器码
  3. 用公钥解开授权码
  4. 校验机器码、有效期、使用次数和本地防篡改记录
```

核心安全边界很简单：私钥用于签发，公钥用于验证。公钥可以放进 UE 项目，私钥不能放进 UE 项目、打包目录或公开仓库。

## 文件组成

| 位置 | 说明 |
| --- | --- |
| `Source/WPPMachineAuth/` | Runtime 授权模块源码 |
| `Source/WPPMachineAuth/Public/WPPMachineAuthWidget.h` | 蓝图 Widget 接入接口 |
| `Source/WPPMachineAuth/Public/WPPMachineAuthService.h` | C++ 静态授权服务接口 |
| `Tools/LicenseGenerator/license_tool.html` | 离线授权码生成器 |
| `README.md` | 当前插件使用说明 |

## 快速开始

### 1. 安装插件

把整个 `WPPMachineAuth` 文件夹放入 UE 项目的 `Plugins` 目录：

```text
YourProject/
└── Plugins/
    └── WPPMachineAuth/
        ├── WPPMachineAuth.uplugin
        ├── Source/
        └── Tools/
```

![](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/%E6%8F%92%E4%BB%B6%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95.png)

### 2. 创建本地 JSON 密钥库


本地html文件和测试加密插件网盘链接： https://pan.baidu.com/s/53kEebDc1rPV4RSIHmHOsRA

--来自百度网盘超级会员v7的分享

双击打开：

```text
Tools/LicenseGenerator/license_tool.html
```
![授权插件目录](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/授权插件目录.png)

第一次打开时：

1. 点击“创建 JSON 密钥库”。
2. 选择保存位置，例如 `wpp-machine-auth-keys.json`。
3. 进入工具主界面。
4. 在“密钥管理”中新建项目密钥。
![授权码加载本地json界面](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/授权码加载本地json界面.png)

### 3. 新建项目密钥

1. 打开“密钥管理”。
  
2. 点击“新建密钥”。
  
3. 输入项目名称。
4. 工具生成固定 2048 位 RSA 密钥对。
5. 打开密钥详情，复制公钥。

JSON 密钥库会记录每个密钥的项目名、密钥长度、签发次数和最后签发时间。需要留档时，也可以用“备份导出”保存一份备份 JSON。
 ![新建密钥界面](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/新建密钥界面.png)

### 4. 在 UE Widget 中配置公钥

创建 Widget Blueprint，父类选择：

```text
WPPMachineAuthWidget
```

然后选择一种方式填写公钥：

- 在 Widget Blueprint 的 Class Defaults 中填写 `RSAPublicKey`。
- 在 `Create Widget` 节点上通过 `RSAPublicKey` 引脚传入。

`RSAPublicKey` 已设置 `ExposeOnSpawn = true`。常规接入只需要配置这个字段，不要把内部总配置 `AuthConfig` 当作普通蓝图创建参数使用。
![UE蓝图完整流程](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/UE蓝图完整流程.png)



### 5. 创建授权 UI 控件

如果要使用插件内置按钮流程，请在 Widget 中使用以下控件名：

| 控件类型 | 控件名 | 用途 |
| --- | --- | --- |
| `TextBlock` | `MachineCodeText` | 显示当前机器码 |
| `EditableTextBox` | `LicenseKeyInput` | 输入授权码 |
| `Button` | `ActivateButton` | 点击后执行激活 |
| `Button` | `CopyMachineCodeButton` | 点击后复制机器码 |
| `TextBlock` | `StatusText` | 显示验证、成功、失败信息 |

这些控件在 C++ 中都是 `OptionalWidget`，不放也能构造 Widget；但缺少对应控件时，内置 UI 行为不会执行。
![20260708163411](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260708163411.png)

### 6. 绑定授权结果

Widget 会在构造时自动验证本地缓存授权。激活、验证和配置错误都会通过下面事件返回：

```text
OnMachineAuthResult(bool bSuccess, FString Source, FString Message)
```

推荐蓝图逻辑：

```text
Create Widget (WBP_MachineAuth)
  RSAPublicKey = 完整公钥
Add to Viewport
Bind Event to OnMachineAuthResult

OnMachineAuthResult
  Branch bSuccess
    True  -> Remove from Parent -> 进入主流程
    False -> 显示 Message，等待客户输入授权码
```

首次运行没有本地授权缓存时，通常会收到类似 `[Validation] License cache not found` 的失败消息，这是正常状态，保留授权界面等待客户激活即可。
![UE蓝图完整流程](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/UE蓝图完整流程.png)


## 签发和激活授权码

### 客户侧复制机器码

客户打开你的 UE 程序后，点击 `CopyMachineCodeButton` 对应按钮，将机器码发给你。默认机器码是 16 位大写十六进制字符串。

机器码默认包含：

- 电脑名
- 当前用户名
- 操作系统版本
- 设备 ID 哈希

最终会计算 MD5，并截取 `MachineCodeLength` 指定长度，默认 `16`，可配置范围 `8` 到 `32`。
![UE授权界面](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/UE授权界面.png)

### 开发者侧签发授权码

在 `license_tool.html` 中：

1. 确认已经绑定 JSON 密钥库。
2. 在“生成授权码”页面选择项目密钥。
3. 输入客户机器码。
4. 设置授权天数。
5. 设置最大次数，`-1` 表示不限。
6. 点击“生成授权码”。
7. 把生成结果发给客户。
 ![生成授权码界面](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/生成授权码界面.png)



### 客户侧激活

客户把授权码粘贴到 `LicenseKeyInput`，点击 `ActivateButton`。插件会执行：

1. 获取网络时间，失败时按配置决定是否回退本地 UTC 时间。
2. 使用 `RSAPublicKey` 解开授权码。
3. 解析授权码 JSON。
4. 校验机器码是否匹配。
5. 校验 `ExpiryDate` 是否过期。
6. 校验 `MaxUsage` 和影子文件记录。
7. 加密保存本地授权缓存。
8. 触发 `OnMachineAuthResult`。

## 蓝图 API

### 事件

| 事件 | 说明 |
| --- | --- |
| `OnMachineAuthResult(bool bSuccess, FString Source, FString Message)` | 授权验证、激活、配置错误等最终结果 |

`Source` 常见值包括 `Validation`、`Activation`、`Network Time`、`License Config`、`Machine Code Config`、`Storage Config`、`Time Config`、`AntiCheat Config`。
![20260708163658](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260708163658.png)

### 常用函数

| 函数 | 说明 |
| --- | --- |
| `GetMachineCode()` | 获取当前配置下的机器码 |
| `ConfigureMachineAuth()` | 设置 RSA 公钥并刷新机器码显示 |
| `ConfigureMachineAuthStorage()` | 设置本地缓存和影子文件参数 |
| `ConfigureMachineAuthMachineCode()` | 设置机器码生成规则 |
| `ConfigureMachineAuthTime()` | 设置网络授时和时间回滚检测 |
| `ConfigureMachineAuthEncryption()` | 设置本地缓存和影子文件 AES 盐值 |
| `ConfigureMachineAuthUI()` | 设置状态文字颜色 |
| `ClearCachedLicense()` | 删除 `Project/Saved/<LocalLicenseFileName>` 授权缓存 |

`Configure...` 函数只更新配置，不主动重新验证授权。普通蓝图项目优先使用 `RSAPublicKey` 字段。


![78b68199-f69e-40cd-8c52-83e5c19b0430](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/78b68199-f69e-40cd-8c52-83e5c19b0430.png)

## 配置参考

### 授权配置

| 配置 | 默认值 | 说明 |
| --- | --- | --- |
| `RSAPublicKey` | 空 | 必填。完整 RSA 公钥 PEM |

`UWPPMachineAuthWidget` 对蓝图直接暴露顶层 `RSAPublicKey`，并支持 `Create Widget` 传入。内部 `AuthConfig` 继续存在，但不作为常规蓝图创建入口。

### 网络授时

| 配置 | 默认值 | 说明 |
| --- | --- | --- |
| `bUseNetworkTime` | `true` | 是否请求网络时间 |
| `NetworkTimeUrl` | `http://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp` | 网络授时地址 |
| `NetworkTimeoutSeconds` | `3.0` | HTTP 超时秒数，最低 `0.5` |
| `bAllowLocalTimeFallback` | `true` | 网络失败或 URL 为空时是否允许使用本地 UTC 时间 |



其中 `t` 是毫秒级 Unix 时间戳。如果替换成自己的授时服务，需要保持这个结构，或修改 `UWPPMachineAuthWidget::OnNetworkTimeResponseReceived()`。
![20260708164245](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260708164245.png)
### 本地缓存

| 配置 | 默认值 | 说明 |
| --- | --- | --- |
| `LocalLicenseFileName` | `License.dat` | 保存在 `Project/Saved/` 下的授权缓存文件名 |
| `LocalAesSalt` | `WPPKey` | 本地授权缓存 AES 密钥盐值 |
| `LocalAesIVSalt` | `WangPangpangmima` | 本地授权缓存 AES IV 盐值 |

实际本地 AES 密钥会组合项目名和盐值：

```text
<ProjectName>_<LocalAesSalt>
```

![20260708164622](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260708164622.png)
### 影子文件和防篡改


| 配置 | 默认值 | 说明 |
| --- | --- | --- |
| `bEnableShadowFiles` | `true` | 是否启用影子文件 |
| `ShadowLocalSubDir` | `Microsoft_Windows_Cache` | `%LOCALAPPDATA%` 下的子目录 |
| `ShadowLocalFileName` | `sys_config.bin` | 主影子文件 |
| `bEnableProgramDataShadowFile` | `true` | 是否写入第二份冗余影子文件 |
| `ShadowProgramDataFileName` | `sys_core_module.dll` | 冗余影子文件名 |
| `ShadowAesSalt` | `ShadowAntiCheatKey2026` | 影子文件 AES 密钥盐值 |
| `ShadowAesIVSalt` | `ShadowAntiCheatIV2026` | 影子文件 AES IV 盐值 |
| `bEnableParanoidTimeCheck` | `true` | 是否检查系统参考文件时间 |
| `TimeRollbackReferenceFile` | `C:/Windows/System32/kernel32.dll` | 时间回滚参考文件 |

当前代码中，主影子文件和冗余影子文件都会写入：

```text
%LOCALAPPDATA%/<ShadowLocalSubDir>/
```

默认路径为：

```text
%LOCALAPPDATA%/Microsoft_Windows_Cache/sys_config.bin
%LOCALAPPDATA%/Microsoft_Windows_Cache/sys_core_module.dll
```
![20260708164452](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260708164452.png)
### 机器码

| 配置 | 默认值 | 说明 |
| --- | --- | --- |
| `bUseComputerNameInMachineCode` | `true` | 包含电脑名 |
| `bUseUserNameInMachineCode` | `true` | 包含用户名 |
| `bUseDeviceIdInMachineCode` | `true` | 包含设备 ID 哈希 |
| `bUseOSVersionInMachineCode` | `true` | 包含系统版本 |
| `MachineCodeLength` | `16` | 输出长度，范围 `8` 到 `32` |

如果所有机器码参与因子都关闭，代码会自动回退到电脑名、用户名和系统版本，避免机器码为空。
![20260708164707](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260708164707.png)
### UI 和本地化

| 配置 | 默认值 | 说明 |
| --- | --- | --- |
| `SuccessStatusColor` | `(0, 0.83, 0.67, 1)` | 成功或普通提示颜色 |
| `FailureStatusColor` | `(1, 0, 0, 1)` | 失败提示颜色 |
| `StatusVerifyingText` | `Verifying license...` | 验证中 |
| `StatusSuccessText` | `License verified!` | 验证成功 |
| `StatusMachineCodeCopiedText` | `Machine code copied!` | 机器码复制成功 |
| `StatusEnterLicenseText` | `Please enter license key` | 授权码为空 |
| `StatusNetworkFailedText` | `Network time sync failed, check connection and retry` | 网络授时失败 |
| `StatusNetworkUrlEmptyText` | `Network time URL not configured` | 授时 URL 为空 |
| `StatusLimitReachedText` | `License usage limit reached, please obtain a new license` | 使用次数到达上限 |

![20260708163411](https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260708163411.png)


## 安全说明

### 可以公开

- `license_tool.html` 的源码。
- UE 项目里的 `RSAPublicKey`。
- 授权码生成器说明文档。

### 不能公开

- JSON 密钥库。
- RSA 私钥。
- 包含私钥的备份文件。
- 能访问私钥的服务器环境变量或后台接口。

### 关于网页发布

HTML 工具可以放到网页上，但不要把你的 JSON 密钥库和私钥一起发布。公开网页只是一套工具界面，真正危险的是私钥泄露。

如果只由你本人或可信签发人员使用，可以用本地 JSON 密钥库方案。若需要多人协作、权限控制、审计日志或避免私钥进入浏览器，建议后续升级为服务端签发：私钥只放服务器，网页只提交机器码、有效期和次数。

### 关于 MaxUsage

`MaxUsage` 不是“可激活多少台电脑”。当前代码中，激活成功和后续缓存验证成功都会计入使用次数。

建议：

- 正式授权使用 `-1`，表示不限次数。
- 试用授权优先用授权天数控制。
- 不建议把正式授权设置成 `1`，否则激活后再次启动可能就会到达次数上限。

## 测试和重置授权

`ClearCachedLicense()` 只删除：

```text
Project/Saved/<LocalLicenseFileName>
```

默认是：

```text
Project/Saved/License.dat
```

它不会删除影子文件。完整重置默认授权状态时，关闭程序后删除：

```text
Project/Saved/License.dat
%LOCALAPPDATA%/Microsoft_Windows_Cache/sys_config.bin
%LOCALAPPDATA%/Microsoft_Windows_Cache/sys_core_module.dll
```

如果你改过文件名或目录，请按自定义配置删除对应文件。

## 故障排查

| 消息或现象 | 原因 | 处理 |
| --- | --- | --- |
| `[License Config] RSA public key is not configured` | 没有配置公钥 | 在 Class Defaults 或 `Create Widget` 的 `RSAPublicKey` 填入完整公钥 |
| `[Validation] License cache not found` | 首次运行或本地缓存不存在 | 正常状态，让客户输入授权码激活 |
| `[Machine Code Config] Machine code mismatch` | 授权码不是为当前机器码签发 | 让客户重新复制机器码，重新签发 |
| `[License Config] RSA decrypt failed` | 公钥和私钥不配套、授权码损坏或复制不完整 | 核对密钥库和公钥，重新复制授权码 |
| `[Activation] License payload is invalid` | 授权码解开后不是合法 JSON | 重新签发授权码 |
| `[Validation] License expired` | 授权已过期 | 重新签发更长有效期授权 |
| `[Validation] License usage limit reached` | `MaxUsage` 到达上限 | 使用 `-1` 或提高次数后重新签发 |
| `[Network Time] Network time sync failed, check connection and retry` | 网络授时失败且不允许本地回退 | 检查网络，或允许本地时间回退 |
| `[Time Config] Time rollback reference file does not exist` | 参考文件不存在 | Win64 默认用 `kernel32.dll`，非默认平台需换参考文件 |
| `[Time Config] Security warning: invalid time rollback detected` | 检测到明显时间异常 | 检查系统时间和参考文件时间 |
| `[AntiCheat Config] Security warning: license cache tampering detected` | 影子文件检测到缓存删除、时间回拨或篡改 | 测试环境完整清理缓存；客户环境需重新核查授权 |

## 常见问题

### 私钥丢了怎么办？

私钥无法从公钥恢复。你需要新建密钥对，把新公钥更新到 UE 项目的 `RSAPublicKey`，并重新发布或重新配置项目。

### 公钥泄露有风险吗？

公钥可以公开。它只能验证授权码，不能签发授权码。真正要保护的是 JSON 密钥库里的私钥。

### 客户换电脑怎么办？

机器码通常会变化，需要客户复制新机器码，你用同一项目私钥重新签发授权码。

### 能不能不用内置 Widget？

可以。你可以直接调用 `FWPPMachineAuthService`，自己做 UI、网络授时和结果提示。

### 能不能支持非 Win64？

当前 `.uplugin` 的 `PlatformAllowList` 只有 `Win64`，默认路径和时间参考文件也按 Windows 设计。要支持其他平台，需要调整平台列表、路径策略和时间参考逻辑，并重新测试。

### 可以把授权生成器上传到 GitHub 或网页吗？

可以上传工具本身，但不要上传 JSON 密钥库、私钥或任何包含私钥的备份。公开 HTML 不等于公开授权能力，私钥泄露才会导致别人可以签发授权码。

## 作者与服务

作者：B站 **常胜将军王胖胖**  
方向：虚幻引擎数字孪生行业开发者  
服务：承接数字孪生外包、三维可视化制作、UE 项目开发、可视化交互系统定制。

| 渠道 | 信息 |
| --- | --- |
| 微信 | `17610986288`，备注 `WPPMachineAuth` |
| B站 | [常胜将军王胖胖](https://space.bilibili.com/354782208#/) |
| FAB 商城 | [WPPMachineAuth 插件主页](https://www.fab.com/listings/c498f463-107e-47d9-88b5-a4a2bce3c3d6) |
| 知乎 | [csjjwpp](https://www.zhihu.com/people/csjjwpp) |
| 在线文档 | [https://www.fywpp.top](https://www.fywpp.top/#/ue-plugins/MachineAuth/README) |

Copyright 2022-2026 WangPangPang. All Rights Reserved.
