//
//  Reachability.swift
//  News Connected Network
//
//  Created by ram-16138 on 13/01/23.
//

import Foundation
import Network
import SystemConfiguration

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    private var isReachable: Bool { status == .satisfied }

    internal func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status

            if path.status == .satisfied {
                UserDefaults.standard.set(true, forKey: "hasInternetConnection")
                NotificationCenter.default
                            .post(name:           NSNotification.Name("com.user.hasConnection"),
                             object: nil)
            } else {
                UserDefaults.standard.set(false, forKey: "hasInternetConnection")
                NotificationCenter.default
                            .post(name: NSNotification.Name("com.user.hasNoConnection"),
                             object: nil)
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    internal func stopMonitoring() {
        monitor.cancel()
    }
    
}

internal func hasNetworkConnection()->Bool{
    return UserDefaults.standard.bool(forKey: "hasInternetConnection")
}
