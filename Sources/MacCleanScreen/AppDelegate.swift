import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private let cleaningController = CleaningController()
    private var statusItem: NSStatusItem?
    private var screenCleaningItem: NSMenuItem?
    private var keyboardCleaningItem: NSMenuItem?
    private var permissionItem: NSMenuItem?
    private var smokeTestRunner: AutomatedSmokeTestRunner?

    private let promotionURL = URL(string: "https://autopixel.qzz.io/blackcat")!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        configureStatusItem()
        cleaningController.onStateChange = { [weak self] isCleaning in
            self?.refreshMenu(isCleaning: isCleaning)
        }
        refreshMenu(isCleaning: false)
        if ProcessInfo.processInfo.environment["MACCLEANSCREEN_SMOKE_TEST"] == "1" {
            startAutomatedSmokeTest()
        }
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        cleaningController.stop()
        return .terminateNow
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        refreshMenu(isCleaning: cleaningController.isCleaning)
    }

    func menuWillOpen(_ menu: NSMenu) {
        refreshMenu(isCleaning: cleaningController.isCleaning)
    }

    private func configureStatusItem() {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "sparkles.rectangle.stack",
                accessibilityDescription: "MacCleanScreen"
            )
        }

        let menu = NSMenu()
        menu.delegate = self
        let screenCleaningItem = NSMenuItem(
            title: "清洁屏幕",
            action: #selector(startScreenCleaning),
            keyEquivalent: ""
        )
        screenCleaningItem.image = NSImage(systemSymbolName: "display", accessibilityDescription: nil)
        screenCleaningItem.target = self
        menu.addItem(screenCleaningItem)

        let keyboardCleaningItem = NSMenuItem(
            title: "清洁键盘与触控板",
            action: #selector(startKeyboardCleaning),
            keyEquivalent: ""
        )
        keyboardCleaningItem.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: nil)
        keyboardCleaningItem.target = self
        menu.addItem(keyboardCleaningItem)

        let permissionItem = NSMenuItem(
            title: "辅助功能权限",
            action: #selector(openAccessibilitySettings),
            keyEquivalent: ""
        )
        permissionItem.target = self
        menu.addItem(permissionItem)
        menu.addItem(.separator())

        let promotionItem = NSMenuItem(
            title: "推广 · ChatGPT源头批发网 ↗",
            action: #selector(openPromotionWebsite),
            keyEquivalent: ""
        )
        promotionItem.image = NSImage(systemSymbolName: "megaphone", accessibilityDescription: nil)
        promotionItem.target = self
        menu.addItem(promotionItem)
        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "退出 MacCleanScreen",
            action: #selector(quitApplication),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
        self.statusItem = statusItem
        self.screenCleaningItem = screenCleaningItem
        self.keyboardCleaningItem = keyboardCleaningItem
        self.permissionItem = permissionItem
    }

    private func refreshMenu(isCleaning: Bool) {
        screenCleaningItem?.isEnabled = !isCleaning
        keyboardCleaningItem?.isEnabled = !isCleaning
        permissionItem?.title = AccessibilityPermission.isGranted
            ? "辅助功能权限：已授权 ✓"
            : "辅助功能权限：授权尚未生效…"
    }

    @objc private func startScreenCleaning() {
        startCleaning(mode: .screen)
    }

    @objc private func startKeyboardCleaning() {
        startCleaning(mode: .keyboardAndTrackpad)
    }

    private func startCleaning(mode: CleaningMode) {
        guard AccessibilityPermission.isGranted else {
            AccessibilityPermission.request()
            showPermissionAlert()
            refreshMenu(isCleaning: false)
            return
        }

        do {
            try cleaningController.start(mode: mode)
        } catch {
            showErrorAlert(message: error.localizedDescription)
        }
    }

    @objc private func openAccessibilitySettings() {
        AccessibilityPermission.openSettings()
    }

    @objc private func quitApplication() {
        NSApp.terminate(nil)
    }

    @objc private func openPromotionWebsite() {
        NSWorkspace.shared.open(promotionURL)
    }

    private func showPermissionAlert() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "需要辅助功能权限"
        alert.informativeText = "请在系统设置中允许 MacCleanScreen 控制电脑。授权后回到菜单栏，再次选择清洁模式。"
        alert.addButton(withTitle: "打开系统设置")
        alert.addButton(withTitle: "稍后")
        if alert.runModal() == .alertFirstButtonReturn {
            AccessibilityPermission.openSettings()
        }
    }

    private func showErrorAlert(message: String) {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "无法启动清洁模式"
        alert.informativeText = message
        alert.runModal()
    }

    private func startAutomatedSmokeTest() {
        let runner = AutomatedSmokeTestRunner(cleaningController: cleaningController) { succeeded in
            Foundation.exit(succeeded ? EXIT_SUCCESS : EXIT_FAILURE)
        }
        smokeTestRunner = runner
        runner.start()
    }

}
