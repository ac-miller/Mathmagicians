//
//  MapExploreController.swift
//  Mathmagicians
//
//  Created by Jesse Chan on 10/26/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit
import MapKit

//locationManagerDelegate takes care of all of user location info
class MapExploreController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //variable to solve problem of having to update user location all the time, this can pose a strainage on the battery, we don't need to update the user location every second; setting to 0 initially
    var update = 0
    
    //everytime we create a delegate, we want to create a manager variable
    var manager = CLLocationManager()
    
    //method for when the compass icon is pressed to update user location
    @IBAction func userLocationUpdatedButtonPressed(_ sender: Any) {
        
        //updates map view automatically to show the user at the center within 400 latitudinal meters and 400 longitudinal meters
        let region = MKCoordinateRegion(center: self.manager.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        //showing user on map with animation
        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up user location
        self.manager.delegate = self
        
        //setting up location authorization status
        //if the authorization status has been set, then we are clear to show user location on the map
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            self.mapView.delegate = self
            
            self.mapView.showsUserLocation = true
            
            //to update user location as they move
            self.manager.startUpdatingLocation()
            
            
            //randomly placing annotation on the map (annotation represents monsters)
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                
                if let coordinate = self.manager.location?.coordinate {
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = coordinate
                    
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    
                    self.mapView.addAnnotation(annotation)
                }
            
            })
            //if we do not have authorization, then request access from user
        } else {
            //only asks the user for location request when the app is in use
            self.manager.requestWhenInUseAuthorization()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        //random number used to randomize spawning of different monsters
        let number = Int.random(in: 1 ..< 4)
        
        if annotation is MKUserLocation {
                
            annotationView.image = UIImage(named: "wizard")
        } else if number == 1 {
            annotationView.image = UIImage(named: "easyGreenMonster")
        } else if number == 2 {
            annotationView.image = UIImage(named: "mediumBlueMonster")
        } else {
            annotationView.image = UIImage(named: "hardRedMonster")
        }
        
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
    
        return annotationView
    }
    
    
    
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        //update user location 4 times
        if update < 4 {
            
            //updates map view automatically to show the user at the center within 400 latitudinal meters and 400 longitudinal meters
            let region = MKCoordinateRegion(center: self.manager.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
            
            //showing user on map with animation
            self.mapView.setRegion(region, animated: true)
            
            update += 1
            
            //if it has updated 4 times already, then stop
        } else {
            
            self.manager.stopUpdatingLocation()
            
        }
        

    }
}
