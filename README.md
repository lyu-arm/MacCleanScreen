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
- 首次使用时授予“辅助功能”权限
- 从源码构建时需要 Xcode Command Line Tools

## 使用本地应用

当前已经构建好的应用位于：

```text
/Users/lyu/MacCleanScreen/dist/MacCleanScreen.app
```

可以在终端中直接打开：

```bash
open /Users/lyu/MacCleanScreen/dist/MacCleanScreen.app
```

也可以在 Finder 中按 `Command + Shift + G`，输入：

```text
/Users/lyu/MacCleanScreen/dist
```

然后双击 `MacCleanScreen.app`。如果希望长期使用，可以将它拖到“应用程序”文件夹。

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

如果将应用从 `dist` 移动到“应用程序”文件夹，macOS 可能会将其视为新的应用位置。建议先移动应用，再授予辅助功能权限。

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

## 从源码构建

```bash
git clone https://github.com/lyu-arm/MacCleanScreen.git
cd MacCleanScreen
./scripts/build-app.sh
open dist/MacCleanScreen.app
```

生成的应用位于 `dist/MacCleanScreen.app`，构建脚本会为本地应用添加临时签名。

## GitHub Actions 自动构建

以下情况会自动生成 GitHub Actions 构建记录：

- 推送代码到 `master` 分支；
- 创建或更新 Pull Request；
- 在 Actions 页面手动运行工作流。

工作流会在 GitHub 的 macOS 环境中编译应用、检查 `Info.plist`、验证应用签名并生成 `MacCleanScreen.zip`。成功后可在对应运行记录的 Artifacts 区域下载构建产物，文件保留 14 天。

- [查看所有构建记录](https://github.com/lyu-arm/MacCleanScreen/actions)
- [查看构建工作流](https://github.com/lyu-arm/MacCleanScreen/actions/workflows/build.yml)

## 使用限制

- 电源键、Touch ID 和部分由 macOS 安全机制保留的操作无法被普通应用拦截。
- 本工具用于防止清洁过程中的意外输入，不是登录锁、家长控制或安全防护软件。
- 如果辅助功能权限被关闭，应用将无法启动清洁模式。

## 隐私

MacCleanScreen 不收集数据，不包含遥测，不需要账户，也不会发送网络请求。辅助功能权限只用于在清洁模式期间拦截输入事件。

## 许可

[MIT License](LICENSE)
