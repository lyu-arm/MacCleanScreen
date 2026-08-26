# MacCleanScreen

[![Build](https://github.com/lyu-arm/MacCleanScreen/actions/workflows/build.yml/badge.svg)](https://github.com/lyu-arm/MacCleanScreen/actions/workflows/build.yml)

一个参考 State 工具交互思路、独立实现的极简 macOS 菜单栏清洁工具。它包含两个模式：

- **清洁屏幕**：在所有显示器上显示纯黑遮罩，并锁定输入，方便观察灰尘与指纹；
- **清洁键盘与触控板**：保留当前桌面可见，只显示提示卡片并锁定输入；
- 两种模式都会临时拦截键盘、鼠标和触控板输入；
- 隐藏菜单栏与程序坞；
- 长按 `Esc` 3 秒后安全退出清洁模式。

## 构建

需要 macOS 13 或更高版本以及 Xcode Command Line Tools。

```bash
chmod +x scripts/build-app.sh
./scripts/build-app.sh
open dist/MacCleanScreen.app
```

生成的应用位于 `dist/MacCleanScreen.app`。

## 首次使用

1. 点击菜单栏中的 MacCleanScreen 图标。
2. 选择“开始清洁屏幕”。
3. 按提示前往“系统设置 → 隐私与安全性 → 辅助功能”，允许 MacCleanScreen 控制电脑。
4. 回到菜单栏，再次选择“开始清洁屏幕”。

macOS 的辅助功能权限用于拦截全局输入。电源键、Touch ID，以及由系统安全机制保留的少数按键或组合键无法被普通应用拦截。

## 许可

MIT License

## 自动构建

每次推送到 `master` 分支或创建 Pull Request 时，GitHub Actions 会在 macOS 环境中编译并验证应用。也可以在仓库的 Actions 页面手动运行工作流。成功后可在对应运行记录的 Artifacts 区域下载 `MacCleanScreen.zip`，构建产物保留 14 天。
