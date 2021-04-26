
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let runCycle = Logger(subsystem: subsystem, category: "runcycle")
}
