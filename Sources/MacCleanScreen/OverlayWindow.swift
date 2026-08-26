import AppKit

@MainActor
final class OverlayWindow: NSWindow {
    private let progressLabel = NSTextField(labelWithString: "继续按住…")
    private var messageStack: NSStackView?

    init(screen: NSScreen, mode: CleaningMode) {
        super.init(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        level = .screenSaver
        backgroundColor = mode == .screen ? .black : .clear
        isOpaque = mode == .screen
        isReleasedWhenClosed = false
        hasShadow = false
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        contentView = makeContentView(mode: mode)
        setFrame(screen.frame, display: true)

        if mode == .screen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.5
                    self?.messageStack?.animator().alphaValue = 0
                }
            }
        }
    }

    override var canBecomeKey: Bool { true }

    func setExitProgressVisible(_ visible: Bool) {
        progressLabel.isHidden = !visible
        if visible {
            messageStack?.alphaValue = 1
        }
    }

    private func makeContentView(mode: CleaningMode) -> NSView {
        let root = NSView()
        root.wantsLayer = true
        root.layer?.backgroundColor = mode == .screen
            ? NSColor.black.cgColor
            : NSColor.clear.cgColor

        let icon = NSImageView()
        icon.image = NSImage(
            systemSymbolName: "sparkles",
            accessibilityDescription: "Cleaning mode"
        )
        icon.contentTintColor = NSColor.white.withAlphaComponent(0.7)
        icon.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 34, weight: .light)

        let title = NSTextField(labelWithString: mode == .screen ? "屏幕清洁模式" : "键盘清洁模式")
        title.font = .systemFont(ofSize: 24, weight: .medium)
        title.textColor = NSColor.white.withAlphaComponent(0.78)
        title.alignment = .center

        let subtitleText = mode == .screen
            ? "屏幕、键盘与触控板已暂时停用\n长按 Esc 3 秒退出"
            : "键盘与触控板已暂时停用，可以开始清洁\n长按 Esc 3 秒退出"
        let subtitle = NSTextField(labelWithString: subtitleText)
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = NSColor.white.withAlphaComponent(0.45)
        subtitle.alignment = .center
        subtitle.maximumNumberOfLines = 2

        progressLabel.font = .systemFont(ofSize: 13, weight: .medium)
        progressLabel.textColor = NSColor.systemGreen.withAlphaComponent(0.9)
        progressLabel.alignment = .center
        progressLabel.isHidden = true

        let stack = NSStackView(views: [icon, title, subtitle, progressLabel])
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 12
        stack.setCustomSpacing(18, after: icon)
        stack.translatesAutoresizingMaskIntoConstraints = false
        messageStack = stack

        let container: NSView
        if mode == .keyboardAndTrackpad {
            let material = NSVisualEffectView()
            material.material = .hudWindow
            material.blendingMode = .withinWindow
            material.state = .active
            material.wantsLayer = true
            material.layer?.cornerRadius = 18
            material.translatesAutoresizingMaskIntoConstraints = false
            material.addSubview(stack)
            root.addSubview(material)
            container = material

            NSLayoutConstraint.activate([
                material.centerXAnchor.constraint(equalTo: root.centerXAnchor),
                material.centerYAnchor.constraint(equalTo: root.centerYAnchor),
                material.widthAnchor.constraint(equalToConstant: 390),
                material.heightAnchor.constraint(equalToConstant: 230)
            ])
        } else {
            root.addSubview(stack)
            container = root
        }

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: 360)
        ])

        return root
    }
}
