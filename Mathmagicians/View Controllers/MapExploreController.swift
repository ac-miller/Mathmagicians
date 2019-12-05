//
//  MapExploreController.swift
//  Description: Setup for rendering map per user location, &
//               setup of difficulty level for selection by the user
//               so that the math questions and beasties can be displayed accordingly
//
//  Copyright © 2019 Mathmagicians. All rights reserved.
//

import UIKit
import MapKit

extension String: Error{}

//locationManagerDelegate takes care of all of user location info
class MapExploreController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //variable to solve problem of having to update user location all the time, this can pose a strainage on the battery, we don't need to update the user location every second; setting to 0 initially
    var update = 0
    var beasties = [Beastie]()
    var beastie : Beastie?  //to be determined when user selects a beastie
    let beastiesJsonPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Model/beasties.json")
    
    //everytime we create a delegate, we want to create a manager variable
    var manager = CLLocationManager()
    
    //method for when the compass icon is pressed to update user location
    @IBAction func userLocationUpdatedButtonPressed(_ sender: Any) {
        
        //updates map view automatically to show the user at the center within 400 latitudinal meters and 400 longitudinal meters
        let region = MKCoordinateRegion(center: self.manager.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        //showing user on map with animation
        self.mapView.setRegion(region, animated: true)
    }
    // segue to backpack page so that the updated scoreboard of beasties collected is displayed
    @IBAction func backpackButtonPressed(_ sender: UIButton) {
        //sends the user to the backpack screen through segue
        performSegue(withIdentifier: "backpackSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EncounterController
        {
            let vc = segue.destination as? EncounterController
            vc?.beastie = beastie
        }
    }
    // to link the correlated file of beasties with the color selected by the user
    func readBeasties() throws -> [Beastie] {
        guard
            let fileUrl = Bundle.main.url(forResource: "beasties", withExtension: "json"),
            let jsonData =
                try? Data(contentsOf: fileUrl)
                else {
                    throw "Error loading file"
                }
        return try! JSONDecoder().decode([Beastie].self, from: jsonData)
    }
    
    func gameSetup(){
        beasties = try! readBeasties()
        
        self.mapView.delegate = self
        
        self.mapView.showsUserLocation = true
        
        //to update user location as they move
        self.manager.startUpdatingLocation()
        
        
        //randomly placing annotation on the map (annotation represents monsters)
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            
            if let coordinate = self.manager.location?.coordinate {
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coordinate
                
                annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                
                self.mapView.addAnnotation(annotation)
            }
        
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up user location
        self.manager.delegate = self
        
        //setting up location authorization status
        //if the authorization status has been set, then we are clear to show user location on the map
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            //only asks the user for location request when the app is in use
            self.manager.requestWhenInUseAuthorization()
        }
        
        
        //set dark mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
            //Do nothing because old iOS doesn't support dark mode
        }

        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        //random number used to randomize spawning of different monsters
       let difficulty = Int.random(in: 0 ..< 3)
        
        
        
        
        //setting images for user and monsters
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "wizard")
        } else {
            beastie = beasties[difficulty]
            annotationView.image = UIImage(named: beastie!.imageOnMap!)
        }

        
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
    
        return annotationView
    }
    
    //to capture monsters that are close enough to user
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //deselect current annotation so we can click on multiple annotations (monsters)
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        //if it's the user annotation, then we do nothing
        if view.annotation! is MKUserLocation {
            return
        }
        
        //setting distance and if user is close enough to capture
        let region = MKCoordinateRegion(center: view.annotation!.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        
        //showing user on map with animation
        self.mapView.setRegion(region, animated: false)
        
        //get user current location to see if user is within the new region of monster to be captured
        if let coordinate = self.manager.location?.coordinate {

            if mapView.visibleMapRect.contains(MKMapPoint(coordinate)) {
                //shows encounter page tapping on a monster close enough
                performSegue(withIdentifier: "initiateEncounter", sender: nil)
                
                //removes monster from map after engaging in the encounter page
                self.mapView.removeAnnotation(view.annotation!)
                
            } else {
                print("Monster is too far to capture!")
            }
        }

    }
    
    
    
    //setting user map view
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
    
    //implement method to allow location tracking right after permission granted
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            gameSetup()
            manager.startUpdatingLocation()
            break
        }
    }
}
