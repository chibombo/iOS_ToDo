//
//  MapViewController.swift
//  iOS_ToDo
//
//  Created by Genaro Arvizu on 24/08/20.
//  Copyright © 2020 Genaro Arvizu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnSaveLocation: UIButton!
    
    var coreLocationWorker: CoreLocationWorker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coreLocationWorker = CoreLocationWorker()
        self.coreLocationWorker.delegate = self
        
        self.mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coreLocationWorker.requestLocation()
    }

    @IBAction func userTappedSave(_ sender: Any) {
        
    }

    @IBAction func userLongTappedAction(_ sender: UILongPressGestureRecognizer) {
        
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    
}


extension MapViewController: CoreLocationWorkerDelegate {
    
    func locationWorker(_ manager: CLLocationManager, location: CLLocation) {
        let camera = MKMapCamera(lookingAtCenter: location.coordinate,
                                 fromDistance: 2000,
                                 pitch: 45,
                                 heading: 0)
        mapView.setCamera(camera, animated: true)
    }
    
    func locationWorker(_ manager: CLLocationManager, authorization status: CLAuthorizationStatus) {
        print(#function)
    }
    
}
