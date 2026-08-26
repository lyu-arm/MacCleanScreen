# MacCleanScreen

[![Build](https://github.com/lyu-arm/MacCleanScreen/actions/workflows/build.yml/badge.svg)](https://github.com/lyu-arm/MacCleanScreen/actions/workflows/build.yml)

MacCleanScreen 是一个轻量、原生的 macOS 菜单栏清洁工具。它可以在擦拭 Mac 屏幕、键盘和触控板时临时拦截输入，避免误触快捷键、移动窗口或唤醒其他操作。

## 功能

- **清洁屏幕**：为所有显示器显示纯黑遮罩，同时锁定键盘、鼠标和触控板，方便观察灰尘与指纹。
- **清洁键盘与触控板**：保留当前桌面可见，显示清洁提示卡片并锁定输入。
- **多显示器支持**：自动覆盖当前连接的所有显示器。
- **安全退出**：在任一清洁模式中长按 `Esc` 3 秒即可恢复输入。
- **原生轻量**：使用 Swift、AppKit 和 Core Graphics 实现，无第三方依赖、账户或网络请求。

## 系统要求

- macOS 13 Ventura 或更高版本
- 配备 Apple 芯片的 Mac（arm64）
- 首次使用时授予“辅助功能”权限
- 从源码构建时需要 Xcode Command Line Tools

## 安装

### 下载 ARM64 安装包

从 [GitHub Releases](https://github.com/lyu-arm/MacCleanScreen/releases/latest) 下载名称包含 `arm64` 的 DMG，打开后将 MacCleanScreen 拖入“应用程序”文件夹。

当前版本仅支持配备 Apple 芯片的 Mac。发布包使用临时签名，尚未经过 Apple Developer ID 公证；如果 macOS 阻止首次打开，请优先选择从源码自行构建并审查代码。

### 从源码构建

```bash
git clone https://github.com/lyu-arm/MacCleanScreen.git
cd MacCleanScreen
./scripts/build-app.sh
open dist/MacCleanScreen.app
```

构建完成后，可以将 `dist/MacCleanScreen.app` 拖入“应用程序”文件夹。建议先移动应用，再授予辅助功能权限。

MacCleanScreen 是菜单栏应用，启动后不会显示普通窗口，也不会出现在程序坞中。请在屏幕顶部菜单栏寻找带有闪光效果的矩形图标。

## 首次授权

为了真正阻止全局按键、快捷键和触控板操作，MacCleanScreen 需要 macOS 的辅助功能权限。

1. 启动 MacCleanScreen。
2. 点击菜单栏中的 MacCleanScreen 图标。
3. 选择“清洁屏幕”或“清洁键盘与触控板”。
4. 在权限提示中点击“打开系统设置”。
5. 前往“隐私与安全性 → 辅助功能”。
6. 打开 MacCleanScreen 旁边的开关。
7. 如果系统要求重新打开应用，请退出并重新启动 MacCleanScreen。
8. 再次从菜单栏选择需要的清洁模式。

## 清洁屏幕

1. 点击菜单栏中的 MacCleanScreen 图标。
2. 选择“清洁屏幕”。
3. 所有显示器变为黑色后开始擦拭屏幕。
4. 完成后长按 `Esc` 3 秒。
5. 黑色遮罩消失，键盘、鼠标和触控板恢复使用。

纯黑背景可以让灰尘、油渍和指纹更加明显。请勿将清洁液直接喷到屏幕或键盘上。

## 清洁键盘与触控板

1. 点击菜单栏中的 MacCleanScreen 图标。
2. 选择“清洁键盘与触控板”。
3. 出现提示卡片后开始擦拭键盘、触控板和机身表面。
4. 完成后长按 `Esc` 3 秒恢复输入。

## 退出应用

在未进入清洁模式时，点击菜单栏图标并选择“退出 MacCleanScreen”。

如果正在清洁模式中，请先长按 `Esc` 3 秒退出清洁模式，再从菜单栏退出应用。

## 使用限制

- 电源键、Touch ID 和部分由 macOS 安全机制保留的操作无法被普通应用拦截。
- 本工具用于防止清洁过程中的意外输入，不是登录锁、家长控制或安全防护软件。
- 如果辅助功能权限被关闭，应用将无法启动清洁模式。

## 隐私

MacCleanScreen 不收集数据，不包含遥测，不需要账户，也不会发送网络请求。辅助功能权限只用于在清洁模式期间拦截输入事件。

应用菜单包含一个明确标注的作者推广入口。MacCleanScreen 不会自动加载推广网站或向其传输数据，只有用户主动点击推广入口时才会调用默认浏览器。推广网站由 MacCleanScreen 作者运营，推广业务与本应用的清洁功能相互独立，不代表 OpenAI 官方或授权关系。

## 许可

[MIT License](LICENSE)
