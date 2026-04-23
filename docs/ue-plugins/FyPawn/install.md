<div style="text-align: center; padding: 40px 0 30px 0;">
  <h1 style="font-size: 2.2em; font-weight: 800; color: #1d1d1f; letter-spacing: -0.5px; border: none;">🚀 UE5 数字孪生高级视角控制插件</h1>
  <p style="font-size: 1.2em; color: #86868b; font-weight: 500;">(DT Camera Controller) 官方使用手册</p>
</div>
<div class="ios-card">
  <h2>⚙️ 引擎安装</h2>

  <div class="ios-step">第一步：购买下载</div>
  <p>在 Epic Fab 商城搜索 <span class="ios-highlight">Wangpangpang</span> 或 <span class="ios-highlight">Advanced Digital Twin</span>，购买成功后即可在库中查看。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/c1f5c64f262246de87adcacb4773351e.png" alt="商城搜索" />
  </div>

  <div class="ios-step">第二步：库中查找</div>
  <p>回到你的 Epic 启动器，在“库”里找到它。如果没有找到，可以点击上方的刷新按钮 🔄。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/image-20260421154034254.png" alt="库查找" />
  </div>

  <div class="ios-step">第三步：安装到引擎</div>
  <p>找到以后，点击安装到引擎，选择对应的引擎版本，点击安装即可。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/43d22a8200ac4c8fb5898c3b3e8eadf4.png" alt="安装到引擎" />
  </div>

  <div class="ios-step">第四步：在工程中启用</div>
  <p>打开引擎，在 <code>插件 -> fypwn</code> 即可看到已安装。勾选启用并重启工程。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/20260421160756632.png" alt="启用插件" />
  </div>

  <div class="ios-note">
    💡 <strong>关键提示：</strong> 勾选启用后，请务必 <span class="ios-danger">重启工程</span>，这样才是真正意义上启用了插件逻辑！
  </div>
</div>
<div class="ios-card">
  <h2>📂 插件位置与导入</h2>
  
  <div class="ios-step">方式 A：引擎内容浏览器</div>
  <p>打开内容浏览器，在 <span class="ios-highlight">引擎内容</span> 中找到 <code>FyPawn</code> 插件。里面内置了示例资源，可以直接拖入场景使用。</p>
  
  <div class="ios-note">
    💡 <strong>看不到插件内容？</strong><br>
    在内容浏览器的右上角点击 <strong>“视图选项 (Settings)”</strong>，勾选 <strong>“显示引擎内容 (Show Engine Content)”</strong> 即可。
  </div>

  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-11777993687110700047c673825c-cb11-4ec3-a6f9-8012f0b56215.png" alt="显示引擎内容" />
  </div>

  <div class="ios-step">方式 B：项目手动安装</div>
  <p>如果需要在自己的特定项目中使用，直接将插件文件夹复制到你项目的 <span class="ios-highlight">Plugins</span> 目录下。如果没有该目录，手动创建一个即可。复制完成后重启引擎。</p>

  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-9495137270829764222rqCwqJ.png" alt="插件安装路径" />
  </div>
</div>

<div class="ios-card">
  <h2>✨ 核心功能简述</h2>
  <p style="line-height: 1.8;">
    专为 <span class="ios-highlight">数字孪生、智慧园区与设计院汇报</span> 打造的 C++ 底层漫游 Pawn。
    彻底弃用弹簧臂，采用 <span class="ios-highlight">射线绝对物理打点</span>，提供极致丝滑的“抓手平移”与“定点旋转”手感。
    内置 <strong>GameplayTag 零代码</strong> 全局视角跳转系统。
  </p>
</div>

<div class="ios-card">
  <h2>📄 核心文件介绍</h2>
  <p>插件核心由以下三个蓝图构成：</p>
  <ul>
    <li><span class="ios-highlight">BP_FyPawn</span>：玩家当前操控的角色实体。</li>
    <li><span class="ios-highlight">BP_TargetCamera</span>：用于设计和预设各种视角机位。</li>
    <li><span class="ios-highlight">BP_MapBounds</span>：用于设计地图的物理边界，防止视角飞出场景。</li>
  </ul>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-2966504253209414232dE08NL.png" alt="核心蓝图文件" />
  </div>

  <div class="ios-note">
    🚩 <strong>快速测试指南：</strong><br>
    基础测试地图位于：<code>/FyPawn/Map/WppPawnMap</code>。你可以直接打开此地图进行体验，或将 <code>BP_FyPawn</code> 直接拖入你自己的场景。
  </div>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-3822356300480049202UR1tsC.png" alt="测试地图路径" />
  </div>
</div>

<div class="ios-card">
  <h2>📊 状态与配置说明</h2>
  
  <p><strong>核心模块说明：</strong></p>
  <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
    <tr style="background: #fbfbfd; border-bottom: 1px solid #eee;">
      <th style="text-align: left; padding: 12px;">模块名称</th>
      <th style="text-align: left; padding: 12px;">功能描述</th>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><strong>PawnState</strong></td>
      <td style="padding: 12px;">当前角色的操作状态枚举。</td>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><strong>CameraTags</strong></td>
      <td style="padding: 12px;">相机的 <code>GameplayTag</code>，用于全局视角精准跳转。</td>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><strong>RoleState</strong></td>
      <td style="padding: 12px;">相机操作模式选择（中心模式、固定点模式等）。</td>
    </tr>
  </table>

  <p><strong>PawnConfig 细项配置：</strong></p>
  <table style="width: 100%; border-collapse: collapse;">
    <tr style="background: #fbfbfd; border-bottom: 1px solid #eee;">
      <th style="text-align: left; padding: 12px;">配置项</th>
      <th style="text-align: left; padding: 12px;">功能说明</th>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><code>bDoubleClickToLocate</code></td>
      <td style="padding: 12px;">双击地面，角色平滑移动至目标位置。</td>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><code>bMouseDisplacement</code></td>
      <td style="padding: 12px;">按住右键拖动，根据鼠标位移移动角色。</td>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><code>bRollerZoom</code></td>
      <td style="padding: 12px;">滚动滚轮进行视角的推近与拉远。</td>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><code>ZoomRestrictions</code></td>
      <td style="padding: 12px;">设置缩放的最大与最小距离限制。</td>
    </tr>
    <tr style="border-bottom: 1px solid #eee;">
      <td style="padding: 12px;"><code>ElevationAngle</code></td>
      <td style="padding: 12px;">设置仰角的上下限，防止视角穿底。</td>
    </tr>
  </table>
</div>

<div class="ios-card">
  <h2>🎬 相机初始化与注册</h2>
  <div class="ios-step">自动注册机制</div>
  <p>为了保证跳转系统的性能，每一个 <span class="ios-highlight">BP_TargetCamera</span> 在 <code>BeginPlay</code> 时都需要将自身注册到全局列表中。</p>
  
  <div class="ios-note">
    💡 <strong>初始化要点：</strong><br>
    在场景中摆放好相机后，请确保为每个相机分配了唯一的 <code>CameraTag</code>，这样 <code>BP_FyPawn</code> 才能在汇报时准确找到它。
  </div>
</div>