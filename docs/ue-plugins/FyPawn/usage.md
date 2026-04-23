<div style="text-align: center; padding: 40px 0 30px 0;">
  <h1 style="font-size: 2.2em; font-weight: 800; color: #1d1d1f; letter-spacing: -0.5px; border: none;">🚀 UE5 数字孪生高级视角控制插件</h1>
  <p style="font-size: 1.2em; color: #86868b; font-weight: 500;">(DT Camera Controller) 官方使用手册</p>
</div>



<div class="ios-card">
  <h2>1. 插件概述与核心优势</h2>
  <ul>
    <li><strong>设计初衷</strong>：专为数字孪生、智慧城市汇报打造的极简、丝滑角色控制器。</li>
    <li><strong>核心技术</strong>：
      <ul>
        <li>彻底废弃传统弹簧臂组件，采用 <span class="ios-highlight">射线物理打点 (Raycast)</span> 进行锚点计算。</li>
        <li>基于 <code>GameplayTags</code> 的全局视角管理与无缝跳转。</li>
        <li><strong>性能友好</strong>：采用事件驱动与“主动注册”机制，拒绝高昂的每帧遍历 (Tick/GetAllActors) 开销。</li>
      </ul>
    </li>
  </ul>
</div>

<div class="ios-card">
  <h2>2. 目录结构与快速体验</h2>
  <p>📂 <strong>资源目录</strong>：包含蓝图、枚举、地图、材质、模型及结构体。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-8073295541906045671ouY8dE.png" alt="目录结构" />
  </div>
  
  <p>🚩 <strong>测试关卡</strong>：打开 <code>WPP_Pawn_Map</code> 即可快速体验所有核心控制与跳转功能。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-675202582372364499802uYHv.png" alt="测试关卡" />
  </div>
</div>

<div class="ios-card">
  <h2>3. 核心基础操作指南</h2>
  <p>本控制器提供最符合直觉的键鼠交互方案：</p>
  
  <h3>🖱️ 左键交互</h3>
  <ul>
    <li><strong>按住拖拽</strong>：射线实时计算差值，实现“抓手级”平移。</li>
    <li><strong>双击 (Double Click)</strong>：自动跳转至鼠标点击位置。</li>
  </ul>
  
  <h3>🖱️ 右键交互</h3>
  <ul>
    <li><strong>按住旋转 (360°)</strong>：
      <ul>
        <li>模式A：围绕屏幕视野中心点旋转。</li>
        <li>模式B：围绕当前鼠标位置锚点旋转。</li>
      </ul>
    </li>
  </ul>

  <h3>⚙️ 细节配置</h3>
  <p>• <span class="ios-highlight">Set Record Grab Anchor</span>：设置抓手平移锚点。可通过 <code>bUseMouseLocation</code> 切换锚点模式。</p>
  <p>• <span class="ios-highlight">Double Click Jump</span>：
    <br>- <code>bCameraDistance</code>：设置跳转后的镜头间距。
    <br>- <code>IsFacing?</code>：设置是否自动朝向目标。
  </p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-123038252418822176083rOQMV.png" alt="操作参数" />
  </div>

  <h3>🎡 滚轮交互</h3>
  <p>• <strong>平滑缩放</strong>：支持自定义最近与最远极限距离。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-16420077251820918760KAFlf0.png" alt="动态调整接口" />
  </div>
</div>

<div class="ios-card">
  <h2>4. 核心系统与蓝图组件解析</h2>
  
  <h3>4.1 核心控制器：BP_FlyPawn</h3>
  <p>这是玩家操控的实体。核心函数 <span class="ios-highlight">SwitchCameraLocation</span> 通过传入 <code>GameplayTag</code> 实现相机的无缝插值过渡。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-16743967230350881990g6oF3m.png" alt="跳转函数" />
  </div>

  <hr style="opacity: 0.1; margin: 30px 0;">

  <h3>4.2 标签相机节点：BP_TargetCamera</h3>
  <p><strong>✨ 快捷摆放技巧</strong>：将相机拖入场景后，右键选择 <span class="ios-highlight">“控制 (Pilot) BP_TargetCamera”</span>，像玩游戏一样找好视角后停止控制即可锁定机位。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-703012229084915298xZjuhn.png" alt="控制机位" />
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-34197906418191339836t3xyR.png" alt="锁定机位" />
  </div>

  <p><strong>⚙️ 核心配置参数</strong>：包含标签标识、旋转模式、缩放限制 (ZoomLimits) 及空间信息。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-5502231140928476444LCUnHs.png" alt="配置结构体" />
  </div>

  <p><strong>🔗 扩展接口</strong>：包含主动注册机制与 <span class="ios-highlight">SwitchCameraTag</span> 事件接口，方便对接 UI 动画或粒子特效。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-15976870905842129584xxxCV2.png" alt="注册机制" />
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-1126486380267207981pxcSKp.png" alt="事件接口" />
  </div>
</div>

<div class="ios-card">
  <h2>4.3 场景边界限制：BP_MapEdge</h2>
  <p>基于样条线 (Spline) 的区域限制工具，专门防止“跑酷飞出地图”。</p>
  <div class="ios-step">使用方法</div>
  <ol>
    <li>拖入场景，绘制包围城市的样条线形状。</li>
 <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-10611110228415164918BUz6Xg.png" alt="边界工具" />
  </div>
    <li>在玩家控制器的细节面板中指定该样条线 Actor，即可彻底锁定边界。</li>
 <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-18128528496197000136JLKJ3j.png" alt="边界工具" />
  </div>
  </ol>
 
</div>

<div class="ios-card">
  <h2>5. UI 交互与配置实战</h2>
  
  <h3>🖱️ 快速部署跳转按钮</h3>
  <p>在 UMG 中拖入 <span class="ios-highlight">WBP_Button</span>，设置文本名称与对应的 CameraTarget 标签。点击即可触发平滑漫游。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-89732756401469953888HCCkx.png" alt="按钮配置" />
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-3579154040224097331CqkJte.png" alt="按钮运行效果" />
  </div>

  <hr style="opacity: 0.1; margin: 30px 0;">

  <h3>🏷️ 如何管理 GameplayTags</h3>
  <p>在标签选择框中点击已有的“+”号，通过修改后缀名（如 <code>.Camera06</code>）即可快速完成新视角注册。</p>
  <div class="ios-img-box">
    <img src="https://cdn.jsdelivr.net/gh/FatsWang/FY-Pawn-wiki/docs/images/piclist-upload-2621520859934981106issG0r.png" alt="管理标签" />
  </div>
</div>