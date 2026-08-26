import AppKit

@MainActor
final class AutomatedSmokeTestRunner {
    private let cleaningController: CleaningController
    private let completion: (Bool) -> Void
    private let modes: [CleaningMode] = [
        .screen,
        .keyboardAndTrackpad,
        .screen,
        .keyboardAndTrackpad,
        .screen,
        .keyboardAndTrackpad
    ]
    private var currentIndex = 0

    init(
        cleaningController: CleaningController,
        completion: @escaping (Bool) -> Void
    ) {
        self.cleaningController = cleaningController
        self.completion = completion
    }

    func start() {
        report("Starting automated cleaning-session smoke test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.runNextSession()
        }
    }

    private func runNextSession() {
        guard currentIndex < modes.count else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                self?.runEscapeUnlockTest()
            }
            return
        }

        let mode = modes[currentIndex]
        currentIndex += 1
        report("Starting session \(currentIndex)/\(modes.count): \(mode.testName)")

        do {
            try cleaningController.start(mode: mode)
        } catch {
            report("Smoke test failed: \(error.localizedDescription)")
            completion(false)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.cleaningController.stop()
            self.report("Stopped session \(self.currentIndex)/\(self.modes.count)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                self?.runNextSession()
            }
        }
    }

    private func runEscapeUnlockTest() {
        report("Starting emergency Escape unlock test")

        do {
            try cleaningController.start(mode: .screen)
        } catch {
            report("Escape unlock test failed to start: \(error.localizedDescription)")
            completion(false)
            return
        }

        guard let source = CGEventSource(stateID: .hidSystemState),
              let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 53, keyDown: true),
              let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 53, keyDown: false) else {
            report("Escape unlock test failed to create keyboard events")
            cleaningController.stop()
            completion(false)
            return
        }

        keyDown.post(tap: .cghidEventTap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
            guard let self else { return }
            keyUp.post(tap: .cghidEventTap)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                guard !self.cleaningController.isCleaning else {
                    self.report("Escape unlock test failed: cleaning session remained active")
                    self.cleaningController.stop()
                    self.completion(false)
                    return
                }

                self.report("Emergency Escape unlock test passed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                    self?.report("Automated cleaning-session smoke test passed")
                    self?.completion(true)
                }
            }
        }
    }

    private func report(_ message: String) {
        print("[MacCleanScreen Smoke Test] \(message)")
        fflush(stdout)
    }
}

private extension CleaningMode {
    var testName: String {
        switch self {
        case .screen:
            return "screen"
        case .keyboardAndTrackpad:
            return "keyboard-and-trackpad"
        }
    }
}
