import CoreGraphics
import Foundation

class ScrollEventTap {
    fileprivate var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    fileprivate var config: ScrollConfig
    fileprivate var debug: Bool

    init(config: ScrollConfig, debug: Bool = false) {
        self.config = config
        self.debug = debug
    }

    func start() -> Bool {
        let eventMask: CGEventMask = 1 << CGEventType.scrollWheel.rawValue

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
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
    let delta1 = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
    let pointDelta1 = event.getIntegerValueField(.scrollWheelEventPointDeltaAxis1)
    let fixedDelta1 = event.getDoubleValueField(.scrollWheelEventFixedPtDeltaAxis1)

    if tap.debug {
        let source = event.getIntegerValueField(.eventSourceUnixProcessID)
        print("[debug] isContinuous=\(isContinuous) delta1=\(delta1) pointDelta1=\(pointDelta1) fixedDelta1=\(fixedDelta1) srcPID=\(source)")
    }

    if isContinuous != 0 {
        return Unmanaged.passUnretained(event)
    }

    // Copy the event so modifications definitely take effect
    guard let newEvent = event.copy() else {
        return Unmanaged.passUnretained(event)
    }

    if tap.config.vertical == .reverse {
        let d1 = event.getIntegerValueField(CGEventField.scrollWheelEventDeltaAxis1)
        newEvent.setIntegerValueField(CGEventField.scrollWheelEventDeltaAxis1, value: -d1)

        let pd1 = event.getIntegerValueField(CGEventField.scrollWheelEventPointDeltaAxis1)
        newEvent.setIntegerValueField(CGEventField.scrollWheelEventPointDeltaAxis1, value: -pd1)

        let fd1 = event.getDoubleValueField(CGEventField.scrollWheelEventFixedPtDeltaAxis1)
        newEvent.setDoubleValueField(CGEventField.scrollWheelEventFixedPtDeltaAxis1, value: -fd1)
    }

    if tap.config.horizontal == .reverse {
        let d2 = event.getIntegerValueField(CGEventField.scrollWheelEventDeltaAxis2)
        newEvent.setIntegerValueField(CGEventField.scrollWheelEventDeltaAxis2, value: -d2)

        let pd2 = event.getIntegerValueField(CGEventField.scrollWheelEventPointDeltaAxis2)
        newEvent.setIntegerValueField(CGEventField.scrollWheelEventPointDeltaAxis2, value: -pd2)

        let fd2 = event.getDoubleValueField(CGEventField.scrollWheelEventFixedPtDeltaAxis2)
        newEvent.setDoubleValueField(CGEventField.scrollWheelEventFixedPtDeltaAxis2, value: -fd2)
    }

    if tap.debug {
        let nd1 = newEvent.getIntegerValueField(CGEventField.scrollWheelEventDeltaAxis1)
        let npd1 = newEvent.getIntegerValueField(CGEventField.scrollWheelEventPointDeltaAxis1)
        print("[debug] AFTER: delta1=\(nd1) pointDelta1=\(npd1)")
    }

    return Unmanaged.passRetained(newEvent)
}
