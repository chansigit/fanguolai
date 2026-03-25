import CoreGraphics
import Foundation

class ScrollEventTap {
    fileprivate var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    fileprivate var config: ScrollConfig

    init(config: ScrollConfig) {
        self.config = config
    }

    func start() -> Bool {
        let eventMask: CGEventMask = 1 << CGEventType.scrollWheel.rawValue

        guard let tap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: scrollCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print(L10n.eventTapError)
            return false
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)

        print(L10n.started)
        print(L10n.verticalHorizontal(config.vertical.rawValue, config.horizontal.rawValue))
        print(L10n.pressCtrlC)

        signal(SIGTERM) { _ in
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        signal(SIGINT) { _ in
            CFRunLoopStop(CFRunLoopGetCurrent())
        }

        CFRunLoopRun()

        stop()
        print(L10n.stopped)
        return true
    }

    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
    }

    func reloadConfig() {
        config = ConfigManager.load()
        print(L10n.configReloaded(config.vertical.rawValue, config.horizontal.rawValue))
    }
}

private func scrollCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let userInfo = userInfo else {
        return Unmanaged.passUnretained(event)
    }

    let tap = Unmanaged<ScrollEventTap>.fromOpaque(userInfo).takeUnretainedValue()

    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let eventTap = tap.eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
        return Unmanaged.passUnretained(event)
    }

    guard type == .scrollWheel else {
        return Unmanaged.passUnretained(event)
    }

    let isContinuous = event.getIntegerValueField(.scrollWheelEventIsContinuous)
    if isContinuous != 0 {
        return Unmanaged.passUnretained(event)
    }

    if tap.config.vertical == .reverse {
        let delta1 = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
        event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: -delta1)

        let pointDelta1 = event.getIntegerValueField(.scrollWheelEventPointDeltaAxis1)
        event.setIntegerValueField(.scrollWheelEventPointDeltaAxis1, value: -pointDelta1)

        let fixedDelta1 = event.getDoubleValueField(.scrollWheelEventFixedPtDeltaAxis1)
        event.setDoubleValueField(.scrollWheelEventFixedPtDeltaAxis1, value: -fixedDelta1)
    }

    if tap.config.horizontal == .reverse {
        let delta2 = event.getIntegerValueField(.scrollWheelEventDeltaAxis2)
        event.setIntegerValueField(.scrollWheelEventDeltaAxis2, value: -delta2)

        let pointDelta2 = event.getIntegerValueField(.scrollWheelEventPointDeltaAxis2)
        event.setIntegerValueField(.scrollWheelEventPointDeltaAxis2, value: -pointDelta2)

        let fixedDelta2 = event.getDoubleValueField(.scrollWheelEventFixedPtDeltaAxis2)
        event.setDoubleValueField(.scrollWheelEventFixedPtDeltaAxis2, value: -fixedDelta2)
    }

    return Unmanaged.passUnretained(event)
}
