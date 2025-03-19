//
// NetworkManager.swift
// Shaadi.com

import Network
import Foundation

/// Responsible for checking network availability
class NetworkManager {
    static let shared = NetworkManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    /// Track network status
    private(set) var isConnected: Bool = false {
        didSet {
            if oldValue != isConnected {
                NotificationCenter.default.post(name: .networkStatusChanged, object: isConnected)
            }
        }
    }
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    /// Check if internet is available
    func isInternetAvailable() -> Bool {
        return isConnected
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
}
