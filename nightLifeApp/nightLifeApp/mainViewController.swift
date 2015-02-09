//
//  mainViewController.swift
//  nightLifeApp
//
//  Created by Jordan Weaver on 1/13/15.
//  Copyright (c) 2015 Jordan Weaver. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UICollisionBehaviorDelegate, UITableViewDelegate  {
    
    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var nightLifeButton: UIButton!
    
    @IBOutlet weak var checkedInLabel: UILabel!
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    var myLocations: [CLLocation] = []
    
    //This counter is to enable and disable the background image of the "NightLife" button drink on main view. consider refactoring.
    var counter:Int = 0;
    
    /*The navBar Stuff*/
    var navBar: navigationTableViewController = navigationTableViewController()
    
    
    
    /*API Stuff*/
    var lat:CLLocationDegrees?;
    var lng:CLLocationDegrees?;
    
    var myData:NSMutableData = NSMutableData();
    
    
    /*Map Stuff*/
    var zoom:Bool = true
    
    var theRegion:MKCoordinateRegion!
    
    var usersCurrentBar:String!
    
    var userStatus:CLAuthorizationStatus = CLAuthorizationStatus.NotDetermined;
    
    var ranLocation:Bool = false;
    var firstSave: Bool = true;
    
    var userObjectID = "";
    
    var barCountDic = Dictionary<String, Int>()
    
    var userFriendsArray: [String] = []
    
    /*Dictionary to hold location of bars*/
    var barDictionary = Dictionary<String, [AnyObject]>()
    var barCounter = 0;
    
    /*Check In Bool*/
    var checkedIn:Bool = false;
    
    /*Table view for navigation*/
    //    var animator: UIDynamicAnimator!
    //    var gravity: UIGravityBehavior!
    //    var collision: UICollisionBehavior!
    //
    //    var behindView:UIView!
    //    var navTableView:UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //runs function
        getBarCount()
        
        //runs function
        getFriendsLocation()
        
        //Checks if the user has allowed loction services
        if userStatus == CLAuthorizationStatus.NotDetermined {
            
            locationManager(locationManager, didChangeAuthorizationStatus: CLAuthorizationStatus.NotDetermined)
        }
        
    }
    
    
    func getFriendsLocation(){
        
        //Grabs current user
        var setCurrentUser:PFUser = PFUser.currentUser()
        //Checks if the user has friends added
        if setCurrentUser["friends"] != nil {
            //Sets the users friends as [String] from AnyObject
            var friendsArray: [String] = setCurrentUser["friends"] as [String]
            /*Loops through the friends*/
            for index in friendsArray {
                //Appends them to an outside array
                self.userFriendsArray.append(index)
                //querys through parse
                var friendsParse = PFUser.query()
                //searches parse for those friends(index)
                friendsParse.whereKey("username", equalTo: index)
                //Finds friends(objects)
                friendsParse.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        //Gets inside the object arrary
                        var insideLocation:PFUser = objects[0] as PFUser
                        //Grabs the friends location
                        if var location: PFGeoPoint = insideLocation["location"] as? PFGeoPoint{
                            
                            //Console log check
                            //println("\(index) = \(location) ")
                            
                            //Converts friends geoPoint to CLLocationDegrees
                            var friendsLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude as CLLocationDegrees, location.longitude as CLLocationDegrees)
                            
                            
                            
                            
                            /*RUN ANNOTATION DELEGATE METHOD */
                            let annotation = MKPointAnnotation()
                            annotation.setCoordinate(friendsLocation);
                            annotation.title = index;
                            var userLocations = true
                            self.theMapView.addAnnotation(annotation);
                        }
                    } else {
                        
                    }
                }
                
                
                
            }
        }
    }
    
    
    
    
    
    
    
    func getBarCount(){
        
        //Looks for bar Table in parse
        var query = PFQuery(className:"bars")
        //Looks for the barNames in the bars table
        query.whereKeyExists("barName")
        //Finds it
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println(objects.count)
                //Loops through those barName objects
                for parseCount in objects {
                    //Gets inside the objects array
                    var bars = objects[0] as PFObject
                    //Casts that PFObject as a String
                    var nameOfBar: String = parseCount["barName"] as String
                    
                    //Add int for the same bar names
                    //Adds a count for each barName that's already in the Dictionary
                    if self.barCountDic["\(nameOfBar)"] != nil {
                        var newCount = self.barCountDic["\(nameOfBar)"]! + 1
                        println(newCount)
                        self.barCountDic.updateValue(newCount, forKey: nameOfBar)
                    } else {
                        //Adds barName and first count to the dictionary
                        self.barCountDic["\(nameOfBar)"] = 1
                    }
                    
                }
                //Console log checks dictionary
                println("Dictionary - \(self.barCountDic)")
                // May work more with annotations for here. Think it's running fine. May need update when refresh is completely implemented
                var allAnnotations = self.theMapView.annotations;
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
            
        }
        
    }
    
    
    /*Grab Date*/
    //This function grabs the date for the API request. This is its only function
    func getDate()->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = NSDate()
        let dateString = dateFormatter.stringFromDate(date)
        
        println(dateString)
        
        return dateString
        
    }
    
    
    // Determines whether user has changed the apps use of users location
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.NotDetermined {
            
            self.locationManager.delegate = self;
            self.locationManager.requestAlwaysAuthorization()
            
            
        } else if status == CLAuthorizationStatus.AuthorizedAlways {
            
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            ranLocation = true;
            
        } else if status == CLAuthorizationStatus.Denied {
            println("Need pop-up Error for user");
        }
        
    }
    
    
    // API connection
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        println("RECEIVING DATA!!!")
        
        
        //MutableData
        myData.appendData(data);
        
        
    }
    
    //Here's where the API runs
    func connectionDidFinishLoading(connection: NSURLConnection) {
        println("Finished Loading")
        
        
        
        /*Checks if MutableData is not emptyu*/
        if myData.length != 0 {
            
            //json Object
            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(myData, options: NSJSONReadingOptions.AllowFragments, error: nil)  as? NSDictionary
            
            
            //println(json)
            
            /*THIS WORKS ALL THE WAY THROUGH THE API TO GRAB INFORMATION NEEDED FOR APPLICATION. SEE URL FOR API JSON */
            if let item: AnyObject = json{
                if let response: AnyObject = item["response"] {
                    //println(response);
                    if let groups: AnyObject = response["groups"]{
                        //println("Groups = \(groups.count)");
                        if let items: AnyObject = groups[0]["items"] as? [AnyObject]{
                            println(items.count);
                            // for item in items {
                            
                            
                            //loop through items array
                            var someCount = 0;
                            for item in items as [AnyObject]
                            {
                                
                                if someCount == 20 {
                                    //println(barDictionary);
                                    someCount = 0;
                                    break
                                    
                                } else {
                                    someCount++
                                    
                                    
                                    /*parsing to individual venues*/
                                    if let venue: AnyObject = item["venue"]{
                                        //var item: AnyObject = items
                                        //println(venue)
                                        
                                        
                                        /*Getting individual names*/
                                        
                                        if let name: AnyObject = venue["name"] {
                                            //println(name);
                                            
                                            if let locations: AnyObject = venue["location"]{
                                                //println(locations)
                                                
                                                
                                                var city: AnyObject = locations["city"] as String
                                                var state: AnyObject = locations["state"] as String
                                                
                                                /* Setting location for Annotation */
                                                
                                                var lat:CLLocationDegrees = locations["lat"] as CLLocationDegrees
                                                var lng:CLLocationDegrees = locations["lng"] as CLLocationDegrees
                                                
                                                
                                                var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
                                                
                                                
                                                /*Adding venue name and location to dictionary*/
                                                
                                                barDictionary["\(name)"] = [lat, lng];
                                                let APIannotation = MKPointAnnotation();
                                                APIannotation.setCoordinate(location);
                                                APIannotation.title = name as String;
                                                
                                                if barCountDic["\(name)"] != nil {
                                                    println(barCountDic)
                                                    
                                                    APIannotation.subtitle = "\(barCountDic[name as String]!) People Checked In";
                                                    
                                                } else {
                                                    APIannotation.subtitle = "0 People Checked In";
                                                }
                                                
                                                theMapView.addAnnotation(APIannotation);
                                            }
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Failed with Error")
    }
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        println("Auth Challenge")
    }
    
    
    var x2:Double = 0.0;
    var y2:Double = 0.0;
    
    //Called everytime location changes
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        
        //This checks if the update ran the for the first time
        if ranLocation == true {
            
            //The URL needed user location before running, this is why the connection runs in here
            var userVal:CLLocationCoordinate2D = self.locationManager.location.coordinate;
            
            //Sets user location for the first time this runs. This is used for the distance formula to check how far the user has moved
            x2 = userVal.latitude
            y2 = userVal.longitude
            
            theMapView.delegate = self;
            theMapView.showsUserLocation = true;
            
            var baseURL = "https://api.foursquare.com/v2/venues/explore?ll=\(userVal.latitude),\(userVal.longitude)&client_id=QNC1U3HQMW5OH55LR2T0VL15JD034DLSPCEGZ4X1KJBTLW1S&client_secret=RGMHRCOJXUX2GEI2RQ3COEZE0UZ4LYRCT5XAQISQ3D055FD1&v=\(getDate())&categoryId=4d4b7105d754a06376d81259&radius=8047"
            
            
            NSURLConnection(request: NSURLRequest(URL: NSURL(string: baseURL)!), delegate: self);
            
            println(baseURL);
            
            
            //setting back to false so connection only runs One time
            
        }
        
        //Grabs userLocation
        var locValue:CLLocationCoordinate2D = locationManager.location.coordinate
        
        //Sets up user location for Distance formula
        var x1: Double = locValue.latitude as Double
        var y1: Double = locValue.longitude as Double
        
        //runs distance formula, checking how far the user has moved
        var distance: Double = sqrt(((x2-x1) * (x2-x1)) + ((y2-y1) * (y2-y1))) * 69
        
        
        //checks if the user has moved more than 1/4 mile than this code will run, or if its the first run(Bool) than this block will run
        if distance >= 0.125 || ranLocation == true{
            //Changes Bool to false
            ranLocation = false
            
            //Updates users location so it may be checked in distance formula again.
            x2 = locValue.latitude;
            y2 = locValue.longitude;
            
            //sets users lat and long here for their PRIVATE location to be used by friends
            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude);
            
            
            /*THIS UPDATES THE USERS GEOLOCATION SO THEIR FRIENDS CAN VIEW THEIR LOCATION*/
            
            if counter == 1 {
                var user = PFUser.currentUser()
                var point = PFGeoPoint(latitude: x2 as Double, longitude: y2 as Double)
                user.setObject(point, forKey: "location")
                user.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError!) -> Void in
                    println("success")
                });
            } else {
                /*THIS DELETES THE USERS LOCATION SO THEIR FRIENDS CAN NO LONGER SEE IT IF THE USE CHOOSES*/
                var users = PFUser.currentUser()
                users.removeObjectForKey("location")
            }
            
            
            
            //This loops through the barDictionary which contains Key: barNames, Value: [Location Lat, Lng]
            //These Key/Values were added in the API request
            for barLocation in barDictionary {
                //Grabs value
                var preCoordinate: AnyObject = barLocation.1
                //Sets up CLLocationCoordinate, not sure if this is used REFACTOR!!!!
                var barCoordinate:CLLocationCoordinate2D;
                
                //Splits the value array and casts as CLLocationDegrees
                if let barLat:CLLocationDegrees = preCoordinate[0] as? CLLocationDegrees {
                    if let barLng:CLLocationDegrees = preCoordinate[1] as? CLLocationDegrees {
                        
                        //Sets as CLLocationCoordinate2D
                        var locationCheckIn:CLLocationCoordinate2D = CLLocationCoordinate2DMake(barLat, barLng);
                        
                        
                        //Runs distance formula to check the distance from users location(x2, y2) from The Bars location
                        var distanceFromBar: Double = sqrt(((x2-barLat) * (x2-barLat)) + ((y2-barLng) * (y2-barLng))) * 69
                        
                        
                        //If the user is less than 1/4 mile and barCounter(0 = no check in, 1 = checked in)
                        //Than this block of code will run
                        if distanceFromBar <= 0.125 && barCounter == 0{
                            //Changes checked in Bool
                            checkedIn = true;
                            //Console Log check
                            println(checkedIn)
                            //barCounter == 1
                            ++barCounter
                            
                            //This was used to set on screen label. This will be implemented later
                            usersCurrentBar = barLocation.0 as String
                            //checkedInLabel.text = "Checked In At \(barLocation.0)"
                            
                            //This saves users Current Bar to a PUBLIC parse table for all uses to pull data
                            var user = PFUser.currentUser()
                            //finds class object
                            var bars = PFObject(className:"bars")
                            //sets object(barName) in class to the bar user checked into
                            bars["barName"] = barLocation.0
                            //Sets the username for the checkin
                            bars["username"] = user
                            bars.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError!) -> Void in
                                println("BAR ID = \(bars.objectId)")
                                //Grabs Object ID so this can be deleted when user leaves(checks out)
                                self.userObjectID = bars.objectId;
                                
                                
                            });
                            println(barLocation.0)
                            
                            println("checked in")
                            
                            break
                            
                            /*THIS CHECKS THE USER OUT if they are further that 1/4 from the bar AND if they are checked in (barCounter = 1)*/
                        } else if checkedIn == true && distanceFromBar >= 0.125 && barCounter == 1{
                            
                            
                            println("checked out")
                            
                            //Changes BOOl
                            checkedIn = false;
                            //Bar counter changed back to 0
                            --barCounter
                            
                            /*DELETES USERS CHECK IN FROM TABLE*/
                            var barsByID = PFObject(withoutDataWithClassName: "bars", objectId: userObjectID)
                            println(userObjectID)
                            barsByID.deleteEventually()
                            
                            break
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation.isEqual(theMapView.userLocation)){
            return nil
        }
        
        /*THIS SETS ANNOTATIONS FOR MAP, CHANGING FRIENDS TO GREEN, API TO RED*/
        var reuse: String = "annotation"
        
        var pin = theMapView.dequeueReusableAnnotationViewWithIdentifier(reuse) as? MKPinAnnotationView
        
        
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuse)
            pin!.animatesDrop = true
            pin!.canShowCallout = true
        } else {
            pin!.annotation = annotation
        }
        
        
        //        if annotation.isEqual("true") == true {
        //            pin!.pinColor = .Green
        //        } else {
        //            pin!.pinColor = .Red
        //        }
        
        
        /*CHECKS IF ANNOTATIONS TITLE IS IN THE FRIENDS ARRAY (added in getFriendsLoction Function) */
        for var i = 0; i < self.userFriendsArray.count; i++ {
            if annotation.title == self.userFriendsArray[i] {
                pin!.pinColor = .Green
                break
            } else {
                pin!.pinColor = .Red
            }
        }
        
        
        
        
        
        
        return pin
    }
    
    //calls zoom
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        /*THIS SETS INITIAL MAP VIEW TO FIND USER, ZOOM AND SET SPAN*/
        var locValue:CLLocationCoordinate2D = userLocation.location.coordinate
        
        var latDelta:CLLocationDegrees  = 0.05
        var longDelta:CLLocationDegrees = 0.05
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
        
        //sets users lat and long here
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude);
        
        theRegion = MKCoordinateRegionMake(location, span);
        
        
        if zoom == true {
            self.theMapView.setRegion(theRegion, animated: true);
            zoom = false
        } else {
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription);
    }
    
    //NightLife button is enabled and disabled here
    @IBAction func nightLifeButtonAction(sender: AnyObject) {
        
        //TOGGLES GLASS BUTTON IMAGE FROM FULL TO EMPTY
        if counter == 0 {
            counter++
            nightLifeButton.setImage(UIImage(named: "glass.png"), forState: nil);
        } else {
            nightLifeButton.setImage(UIImage(named: "emptyglass.png"), forState: nil);
            counter--
        }
        
    }
    
    
    /*This controls the navigation 'Hamburger' menu*/
    @IBAction func hamburgerMenu(sender: AnyObject) {
        
        
        /*THIS IS WHERE THE NAVIGATION MENU WILL OPEN*/
        
        
    }
    
    @IBAction func refreshMapView(sender: AnyObject) {
        
        //var allAnnotations:MKAnnotation = self.theMapView.annotations
        
        /*remove annotations*/
        
        /*THIS ALL REFRESHES THE MAP. I NEED TO REMOVE ANNOTATIONS, HAVENT FIGURE THIS OUT YET*/
        
        getFriendsLocation()
        
        var userVal:CLLocationCoordinate2D = self.locationManager.location.coordinate;
        
        var baseURL = "https://api.foursquare.com/v2/venues/explore?ll=\(userVal.latitude),\(userVal.longitude)&client_id=QNC1U3HQMW5OH55LR2T0VL15JD034DLSPCEGZ4X1KJBTLW1S&client_secret=RGMHRCOJXUX2GEI2RQ3COEZE0UZ4LYRCT5XAQISQ3D055FD1&v=\(getDate())&categoryId=4d4b7105d754a06376d81259&radius=8047"
        
        NSURLConnection(request: NSURLRequest(URL: NSURL(string: baseURL)!), delegate: self);
    }
    
    @IBAction func findMe(sender: AnyObject) {
        /*THIS IS THE 'FIND ME' BUTTON, TAKES MAP BACK TO USERS LOCATION*/
        
        zoom = true
        
        if zoom == true {
            self.theMapView.setRegion(theRegion, animated: true);
            zoom = false
        } else {
            
        }
        
    }
    
    
    /*This displays the add friends view*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindLogoutSegue(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
}
