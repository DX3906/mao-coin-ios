# 毛二壮毛妹妹硬币 · iOS App

原生 SwiftUI 抛硬币 App，和网页版同款的交互与画面：
黑猫毛二壮喊 YES、浅色猫毛妹妹说 NO，3D 翻转 + 跳跃动画、YES/NO 计数清零。

## 目录结构

```
mao-coin-ios/
├── project.yml              # XcodeGen 工程描述（生成 .xcodeproj 用）
└── CoinFlip/
    ├── CoinFlipApp.swift    # App 入口
    ├── ContentView.swift    # 抛硬币主界面
    └── Assets.xcassets/     # App 图标 + 两面硬币图
```

## 三条使用路线（按推荐顺序）

### 路线 A：有 Mac 或能借到 Mac —— 直接装到自己手机（免费）

1. Mac 上安装 Xcode（App Store 免费）和 XcodeGen：`brew install xcodegen`
2. 把整个 `mao-coin-ios` 文件夹拷到 Mac
3. 终端进入文件夹执行 `xcodegen`，生成 `CoinFlip.xcodeproj`
4. 双击打开工程，iPhone 用数据线连 Mac，点运行（▶）即安装到手机
5. 用免费 Apple ID 即可（设置 → Signing & Capabilities → Team 选个人账号），**7 天有效期**，到期重新 Run 一次即可续

### 路线 B：TestFlight（长期有效，需付费账号）

TestFlight 分发必须有 Apple Developer Program 会员（99 美元/年）：

1. 在 [developer.apple.com](https://developer.apple.com) 注册付费账号
2. 用路线 A 的 Xcode 工程，Product → Archive → Distribute App → App Store Connect
3. 上传后在 App Store Connect 里把构建版本加进 TestFlight，添加自己为测试员
4. 手机装 TestFlight App，接受邀请即可长期使用（不用 7 天一续）

### 路线 C：没有 Mac —— 云编译 + AltStore（免费，需要 Windows 电脑配合一次）

1. 把本文件夹推到 GitHub 仓库
2. 仓库的 Actions  workflow 会在 macOS 云端编译出 App（见 `.github/workflows/build.yml`）
3. 在 Windows 电脑上安装 AltServer（altstore.io）+ iTunes（Microsoft Store 版）
4. iPhone 连电脑装 AltStore，再用它安装云编译出的 IPA
5. 免费 Apple ID 签名，同样是 7 天有效期，AltStore 可以自动续签（同一 Wi-Fi 时）

## 桌面小组件（iOS 17+）

App 装好后，长按桌面 → 左上角「+」→ 搜索「毛二壮毛妹妹硬币」→ 添加小组件。

- **点一下小组件里的硬币**：直接翻面出结果（YES/NO 瞬间切换，不打开 App）
- 注意：受苹果系统限制，小组件上**不能有翻转动画**，结果是即时切换的
- 想要完整翻转动画：点桌面 **App 图标**打开，打开后硬币会**自动开始抛**

## 常见问题

- **工程打不开？** 本项目用 `project.yml` 描述工程，必须先跑 `xcodegen` 生成 `.xcodeproj`
- **想改名/换图？** 改 `project.yml` 里的 `INFOPLIST_KEY_CFBundleDisplayName`；换硬币图替换 `Assets.xcassets` 里两个 imageset 的 PNG
- **iOS 版本要求**：iOS 16 及以上
