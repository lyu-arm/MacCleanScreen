import AppKit

@MainActor
final class CleaningController {
    private(set) var isCleaning = false
    var onStateChange: ((Bool) -> Void)?

    private var overlayWindows: [OverlayWindow] = []
    private var eventBlocker: EventBlocker?
    private var escapeHoldWorkItem: DispatchWorkItem?
    private var previousPresentationOptions: NSApplication.PresentationOptions = []

    func start(mode: CleaningMode) throws {
        guard !isCleaning else { return }

        let blocker = EventBlocker()
        blocker.onEscapeHoldChanged = { [weak self] isHolding in
            self?.handleEscapeHold(isHolding)
        }

        guard blocker.start() else {
            throw CleaningError.eventTapUnavailable
        }

        eventBlocker = blocker
        previousPresentationOptions = NSApp.presentationOptions
        NSApp.presentationOptions = [.hideDock, .hideMenuBar]
        overlayWindows = NSScreen.screens.map { screen in
            let window = OverlayWindow(screen: screen, mode: mode)
            window.orderFrontRegardless()
            return window
        }
        NSCursor.hide()

        isCleaning = true
        onStateChange?(true)
    }

    func stop() {
        guard isCleaning || eventBlocker != nil else { return }

        escapeHoldWorkItem?.cancel()
        escapeHoldWorkItem = nil
        eventBlocker?.stop()
        eventBlocker = nil
        overlayWindows.forEach { $0.close() }
        overlayWindows.removeAll()
        NSCursor.unhide()
        NSApp.presentationOptions = previousPresentationOptions

        isCleaning = false
        onStateChange?(false)
    }

    private func handleEscapeHold(_ isHolding: Bool) {
        escapeHoldWorkItem?.cancel()
        escapeHoldWorkItem = nil

        guard isHolding else {
            overlayWindows.forEach { $0.setExitProgressVisible(false) }
            return
        }

        overlayWindows.forEach { $0.setExitProgressVisible(true) }
        let workItem = DispatchWorkItem { [weak self] in
            self?.stop()
        }
        escapeHoldWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }
}

enum CleaningMode {
    case screen
    case keyboardAndTrackpad
}

enum CleaningError: LocalizedError {
    case eventTapUnavailable

    var errorDescription: String? {
        switch self {
        case .eventTapUnavailable:
            return "无法拦截输入事件。请确认已在“系统设置 → 隐私与安全性 → 辅助功能”中授权，然后重新启动应用。"
        }
    }
}
