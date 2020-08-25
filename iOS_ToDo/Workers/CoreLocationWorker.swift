//
//  CoreLocationWorker.swift
//  iOS_ToDo
//
//  Created by Genaro Arvizu on 24/08/20.
//  Copyright © 2020 Genaro Arvizu. All rights reserved.
//

import Foundation
import CoreLocation

protocol CoreLocationWorkerDelegate: class {
    
    /// This function return the last user location.
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - location: CLLocation Object
    func locationWorker(_ manager: CLLocationManager, location: CLLocation) -> Void
    
    func locationWorker(_ manager: CLLocationManager, finishedWith error: Error) -> Void
            
    func locationWorker(_ manager: CLLocationManager, authorization status: CLAuthorizationStatus) -> Void
    
}

extension CoreLocationWorkerDelegate {
    
    func locationWorker(_ manager: CLLocationManager, finishedWith error: Error) {
        print(error.localizedDescription)
    }
    
    func locationWorker(_ manager: CLLocationManager, authorization status: CLAuthorizationStatus) {
        print(status)
    }
}


class CoreLocationWorker: NSObject {
    
    var manager: CLLocationManager?
    weak var delegate: CoreLocationWorkerDelegate?
    
    override init() {
        super.init()
        manager = CLLocationManager()
        manager?.delegate = self
    }
    
    func isLocationEneable() -> CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }
    
    func requestLocation() {
        
        switch isLocationEneable() {
        case .authorizedAlways, .authorizedWhenInUse: manager?.requestLocation()
        case .notDetermined: manager?.requestAlwaysAuthorization()
        case .denied: delegate?.locationWorker(manager!, authorization: .denied)
        default: break
        }
        
        
    }
    
}

extension CoreLocationWorker: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        delegate?.locationWorker(manager,
                                 finishedWith: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation: CLLocation = locations.first {
            delegate?.locationWorker(manager,
                                     location: lastLocation)
        } else {
            let error: NSError = NSError(domain: "Location Fail", code: 666, userInfo: nil)
            delegate?.locationWorker(manager,
                                     finishedWith: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: self.manager?.requestLocation()
        case .denied: delegate?.locationWorker(manager,
                                               authorization: .denied)
        default: break
        }
    }
    
}
