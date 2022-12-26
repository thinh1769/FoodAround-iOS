//
//  HomeViewController.swift
//  Food Around
//
//  Created by Nguyễn Thịnh on 21/12/2022.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

class HomeViewController: BaseController {

    @IBOutlet private weak var currentLocationBtn: UIButton!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var pinNewLocationBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIButton!
    @IBOutlet private weak var addNewLocationBtn: UIButton!
    @IBOutlet private weak var pinNewLocationImage: UIImageView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    
    private var viewModel = HomeViewModel()
    private var locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        hidePinNewLocation(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        isEnabledTouchDismissKeyboard = true
        mapView.delegate = self
        searchTextField.rx.controlEvent([.editingChanged]).subscribe { [weak self] _ in
            guard let self = self else { return }
            if self.searchTextField.text?.count != 0 {
                self.mapView.isHidden = true
                self.pinNewLocationBtn.isHidden = true
                self.currentLocationBtn.isHidden = true
            } else {
                self.mapView.isHidden = false
                self.pinNewLocationBtn.isHidden = false
                self.currentLocationBtn.isHidden = false
            }
        }.disposed(by: viewModel.bag)
        
        searchView.layer.masksToBounds = false
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
        searchView.layer.cornerRadius = 25
        
        currentLocationBtn.layer.masksToBounds = false
        currentLocationBtn.layer.borderColor = UIColor.lightGray.cgColor
        currentLocationBtn.layer.borderWidth = 1
        currentLocationBtn.layer.cornerRadius = 25
        
        cancelBtn.layer.masksToBounds = false
        cancelBtn.layer.borderColor = UIColor.lightGray.cgColor
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 25
        
        pinNewLocationBtn.layer.masksToBounds = false
        pinNewLocationBtn.layer.borderColor = UIColor.lightGray.cgColor
        pinNewLocationBtn.layer.borderWidth = 1
        pinNewLocationBtn.layer.cornerRadius = 25
        
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
        let center = mapView.centerCoordinate
        let vc = LocationFormViewController()
        vc.config(formType: FormType.ADD_NEW_LOCATION_TYPE, lat: center.latitude, long: center.longitude)
        navigateTo(vc)
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
        annotationView?.image = UIImage(named: "circle.inset.filled")
        return annotationView
    }
}
