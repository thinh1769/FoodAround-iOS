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

    @IBOutlet private weak var pinPointView: UIView!
    @IBOutlet private weak var currentLocationBtn: UIButton!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var pinNewLocationBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIButton!
    @IBOutlet private weak var addNewLocationBtn: UIButton!
    @IBOutlet private weak var pinNewLocationImage: UIImageView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var searchTableView: UITableView!
    @IBOutlet private weak var locationImage: UIImageView!
    @IBOutlet private weak var backToMapViewBtn: UIButton!
    
    private var viewModel = HomeViewModel()
    private var locationManager = CLLocationManager()
    private let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    
    override func viewWillAppear(_ animated: Bool) {
        hidePinNewLocation(true)
        
        viewModel.getAllLocation().subscribe { [weak self] locations in
            guard let self = self else { return }
            self.viewModel.location.accept(locations)
            self.pinLocation()
        }.disposed(by: viewModel.bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        removeAnnotation(isRemoveAll: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        isEnabledTouchDismissKeyboard = true
        mapView.delegate = self
        
        searchTextField.rx.controlEvent([.editingChanged]).subscribe { [weak self] _ in
            guard let self = self,
                  let text = self.searchTextField.text
            else { return }
            if text.count != 0 {
                self.showSearchView(isShow: true)
                self.viewModel.findLocation(searchString: text).subscribe { locations in
                    self.viewModel.searchedLocation.accept(locations)
                }.disposed(by: self.viewModel.bag)
            } else {
                self.showSearchView(isShow: false)
            }
        }.disposed(by: viewModel.bag)
        
        searchTextField.rx.controlEvent([.editingDidBegin]).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.dismissDetailPopupView()
        }.disposed(by: viewModel.bag)
        
        setupTableView()
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.mapView.addGestureRecognizer(tapGesture)
    }
    
    private func setupTableView() {
        backToMapViewBtn.isHidden = true
        searchTableView.isHidden = true
        searchTableView.separatorStyle = .none
        searchTableView.rowHeight = 80
        
        searchTableView.register(SearchTableViewCell.nib, forCellReuseIdentifier: SearchTableViewCell.reusableIdentifier)
        
        viewModel.searchedLocation.asObservable()
            .bind(to: searchTableView.rx
                .items(cellIdentifier: SearchTableViewCell.reusableIdentifier, cellType: SearchTableViewCell.self)) { (index, element, cell) in
                    cell.nameLabel.text = element.name
                    cell.addressLabel.text = "\(element.address), \(element.ward?.name ?? ""), \(element.district?.name ?? ""), \(element.city?.name ?? "")"
                }.disposed(by: viewModel.bag)
        
        searchTableView.rx
            .modelSelected(Location.self)
            .subscribe(onNext: { [weak self] element in
                guard let self = self else { return }
                self.showSearchView(isShow: false)
                self.moveCameraToLocation(element.lat, element.long)
                self.addDetailView(locationId: element.id ?? "")
            })
            .disposed(by: viewModel.bag)
    }
    
    @objc private func handleTapGesture() {
        view.window?.endEditing(true)
        dismissDetailPopupView()
    }
    
    private func dismissDetailPopupView() {
        for subview in view.subviews {
            if subview.tag == SubviewTag.detailView.rawValue {
                UIView.animateKeyframes(withDuration: 0.4, delay: 0) {
                    subview.transform = CGAffineTransform(translationX: 0, y: 260)
                } completion: { _ in
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    @IBAction func onClickedBackToMapViewBtn(_ sender: UIButton) {
        showSearchView(isShow: false)
    }
    
    @IBAction func onClickedUserInfoBtn(_ sender: UIButton) {
        navigateTo(UserInfoViewController())
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
        vc.config(formType: FormType.add.rawValue, location: nil, lat: center.latitude, long: center.longitude)
        navigateTo(vc)
    }
    
    @IBAction func onClickedCancelBtn(_ sender: UIButton) {
        hidePinNewLocation(true)
    }
    
    private func showSearchView(isShow: Bool) {
        mapView.isHidden = isShow
        pinNewLocationBtn.isHidden = isShow
        currentLocationBtn.isHidden = isShow
        searchTableView.isHidden = !isShow
        locationImage.isHidden = isShow
        backToMapViewBtn.isHidden = !isShow
    }
    
    private func hidePinNewLocation(_ isShow: Bool) {
        searchView.isHidden = !isShow
        pinNewLocationBtn.isHidden = !isShow
        pinNewLocationImage.isHidden = isShow
        pinPointView.isHidden = isShow
        addNewLocationBtn.isHidden = isShow
        cancelBtn.isHidden = isShow
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            moveCameraToLocation(location.coordinate.latitude, location.coordinate.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            pinUserLocation(coordinate)
        }
    }
    
    private func moveCameraToLocation(_ lat: Double, _ long: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    private func pinUserLocation(_ coordinate: CLLocationCoordinate2D) {
        removeAnnotation(isRemoveAll: false)
        let pin = MKPointAnnotation()
        pin.title = LocationTitle.userLocation.rawValue
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    private func removeAnnotation(isRemoveAll: Bool) {
        let annotations = mapView.annotations
        for annotation in annotations {
            if let annotation = annotation as? MKAnnotation {
                if !isRemoveAll {
                    guard let locationTitle = annotation.title else { return }
                    if locationTitle == LocationTitle.userLocation.rawValue {
                        mapView.removeAnnotation(annotation)
                    }
                } else {
                    mapView.removeAnnotation(annotation)
                }
            }
        }
    }
    
    private func pinLocation() {
        for location in viewModel.location.value {
            let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            let pin = MKPointAnnotation()
            pin.title = location.id
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
        }
    }
}

/// Custom Annotation View
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "location")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "location")
        } else {
            annotationView?.annotation = annotation
        }
        
        guard let locationTitle = annotation.title else { return nil }
        
        if locationTitle == LocationTitle.userLocation.rawValue {
            annotationView?.image = UIImage(named: "circle.inset.filled")
        } else {
            let image = UIImage(named: "pin-icon")
            let resizedSize = CGSize(width: 30, height: 30)

            UIGraphicsBeginImageContext(resizedSize)
            image?.draw(in: CGRect(origin: .zero, size: resizedSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            annotationView?.image = resizedImage
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        if annotation.title != LocationTitle.userLocation.rawValue {
            let coordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            guard let tempId = annotation.title,
                  let id = tempId
            else { return }
            addDetailView(locationId: id)
        }
    }
    
    private func addDetailView(locationId: String) {
        for subview in view.subviews{
            if subview.tag == SubviewTag.detailView.rawValue {
                subview.removeFromSuperview()
            }
        }
        let detailView = DetailPopupView()
        detailView.delegate = self
        detailView.fetchData(locationId)
        detailView.tag = SubviewTag.detailView.rawValue

        if detailView.superview == nil {
            self.view.addSubview(detailView)
            
            detailView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                detailView.heightAnchor.constraint(equalToConstant: 260)
            ])
        }
    }
}

extension HomeViewController: DetailPopupViewDelegate {
    func deselectedAnnotationWhenDismissDetailPopup() {
        let annotations = mapView.annotations
        for annotation in annotations {
            if let annotation = annotation as? MKAnnotation {
                mapView.deselectAnnotation(annotation, animated: false)
            }
        }
    }
    
    func onClickedEditLocationButton(_ location: Location) {
        let vc = LocationFormViewController()
        vc.delegate = self
        vc.config(formType: FormType.edit.rawValue, location: location, lat: location.lat, long: location.long)
        navigateTo(vc)
    }
}

extension HomeViewController: LocationFormViewControllerDelegate {
    func dismissDetailPopupViewAfterDeleteLocation() {
        dismissDetailPopupView()
        
        removeAnnotation(isRemoveAll: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func reloadDetailPopupViewAfterUpdateLocation(_ locationId: String) {
        self.addDetailView(locationId: locationId)
    }
}
