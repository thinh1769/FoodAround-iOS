//
//  HomeViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 21/12/2022.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: BaseController {

    @IBOutlet private weak var pinNewLocationBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIButton!
    @IBOutlet private weak var addNewLocationBtn: UIButton!
    @IBOutlet private weak var pinNewLocationImage: UIImageView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var currentLocationBtnBottomAnchor: NSLayoutConstraint!
    private var locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        pinNewLocationImage.isHidden = true
        addNewLocationBtn.isHidden = true
        cancelBtn.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
        mapView.delegate = self
    }

    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onClickedUserLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func onClickedPinNewLocation(_ sender: UIButton) {
        hidePinNewLocation(false)
    }
    
    @IBAction func onClickedAddNewLocation(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickedCancelBtn(_ sender: UIButton) {
        hidePinNewLocation(true)
    }
    
    private func hidePinNewLocation(_ isShow: Bool) {
        searchView.isHidden = !isShow
        pinNewLocationBtn.isHidden = !isShow
        pinNewLocationImage.isHidden = isShow
        addNewLocationBtn.isHidden = isShow
        cancelBtn.isHidden = isShow
        if isShow {
            currentLocationBtnBottomAnchor.constant -= 50
        } else {
            currentLocationBtnBottomAnchor.constant += 50
        }
        
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            moveCameraToLocation(location)
        }
    }
    
    private func moveCameraToLocation(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
        pinLocation(coordinate)
    }
    
    private func pinLocation(_ coordinate: CLLocationCoordinate2D) {
        removeAllAnnotation()
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    private func removeAllAnnotation() {
        let annotations = mapView.annotations
        for _annotation in annotations {
            if let annotation = _annotation as? MKAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
}

/// Custom Annotation View
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "currentLocation")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "currentLocation")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(systemName: "circle.inset.filled")
        return annotationView
    }
}
