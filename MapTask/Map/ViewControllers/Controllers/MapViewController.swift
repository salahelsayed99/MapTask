//
//  ViewController.swift
//  MapTask
//
//  Created by Salah  on 4/11/21.
//

import UIKit
import GoogleMaps
import SideMenu


class MapViewController: UIViewController{
    
    //Top View
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sideMenuView: UIView!
    
    @IBOutlet weak var destinationTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Map
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // RD Button
    @IBOutlet weak var requestRDButton: UIButton!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var copyOfCities = [City]()
    var filteredCities = [City]()
    var menu:SideMenuNavigationController?
    var locationManager = CLLocationManager()
    var userLocation:CLLocation?
    var mapViewModel = MapViewModel()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewModel.delegate = self
        activityIndicator.startAnimating()
        mapViewModel.requestData()
        setUpTextFields()
        setUpTableView()
        locationManagerSetUp()
        mapViewSetUp()
        setUpUI()
        setUPSideMenu()
    }
    
    
    func setUpTextFields(){
        destinationTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        destinationTextField.addTarget(self, action: #selector(textFieldDidchange), for: .editingChanged)
        locationTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        locationTextField.addTarget(self, action: #selector(textFieldDidchange), for: .editingChanged)
    }
    
    func setUpTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cityCellIdentifier)
        tableView.backgroundColor = .white
    }
    
    func setUPSideMenu(){
        menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu?.setNavigationBarHidden(true, animated: true)
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    
    func setUpUI(){
        tableView.isHidden = true
        requestRDButton.addShadow()
        UIUtilities.createCircularViewforView(requestRDButton, withRadius: 6)
        UIUtilities.createCircularViewforView(topView, withRadius: 10)
        UIUtilities.createCircularView(sideMenuView)
        sideMenuView.addShadow()
        UIUtilities.addTapGestureToView(sideMenuView, withTarget: self, andSelector: #selector(sideMenuTapped), andCanCancelTouchesInTheView: false)
        UIUtilities.addTapGestureToView(self.topView, withTarget: self, andSelector: #selector(hideTableView), andCanCancelTouchesInTheView: false)
        UIUtilities.createCircularViewforView(activityIndicator, withRadius: 5)
    }
    
    
    private func locationManagerSetUp(){
        locationManager.delegate=self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func mapViewSetUp(){
        // set camera initial position to Cairo
        mapView.camera = GMSCameraPosition.camera(withLatitude: 30.0444, longitude: 31.2357, zoom: 19.0)
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
    }
    
    
    
    
    @objc func hideTableView(){
        tableView.isHidden = true
    }
    
    @objc func sideMenuTapped(){
        present(menu!, animated: true, completion: nil)
    }
    
    
    @objc func myTargetFunction(textField: UITextField) {
        AnimationsUtility.showAnimatedWithTransition(tableView, duration: 0.5)
    }
    
    
    @objc func textFieldDidchange(textField: UITextField) {
        if textField.text?.count == 0 {
            filteredCities = copyOfCities
        } else {
            filteredCities = self.filteredCities.filter { (city) -> Bool in
                return (city.name.lowercased().contains(textField.text?.lowercased() ?? ""))
            }
        }
        tableView.reloadData()
        tableView.tableFooterView = UIView()
    }
    
    
    
    @IBAction func requestRdAction(_ sender: Any) {
        self.showToast(message: "The closest driver to you is \(mapViewModel.findClosestDriver(userLocation: userLocation))")
    }
    
        
}

extension MapViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  let location=locations.last{
            locationManager.stopUpdatingLocation()
            userLocation = location
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 12);
            self.mapView.camera = camera
            let marker = GMSMarker(position: center)
            marker.map = self.mapView
            marker.title = "Your Current Location"
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}


extension MapViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cityCellIdentifier, for: indexPath)
        cell.textLabel?.text = filteredCities[indexPath.row].name
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if destinationTextField.isFirstResponder{
            destinationTextField.text = filteredCities[indexPath.row].name
        }else if locationTextField.isFirstResponder{
            locationTextField.text = filteredCities[indexPath.row].name
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension MapViewController:MapViewModelDelegate{
    func onError(error: String) {
        self.allertError(title: "Error", message: error)
    }
    
    func onCities(_ data: [City]) {
        copyOfCities = data
        filteredCities = data
        tableView.reloadData()
        activityIndicator.isHidden = true
    }
    
        
    
}
