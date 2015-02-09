//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Parse/Parse.h>
#import <AddressBookUI/AddressBookUI.h>




//Gets users geoLocation
//PFGeoPoint.geoPointForCurrentLocationInBackground {
//    (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
//    if error == nil {
//        // do something with the new geoPoint
//    }
//        }




/*testing*/
//    func displayLocationInfo(placemark: CLPlacemark){
//
//        self.locationManager.stopUpdatingLocation()
//
//        println(placemark.locality);
//        println(placemark.postalCode);
//        println(placemark.administrativeArea);
//        println(placemark.country);
//    }



/*This code will personalize the app with the users username*/

//        var currentUser = PFUser.currentUser()
//        if currentUser != nil {
//            // Do stuff with the user
//        } else {
//            // Show the signup or login screen
//        }







/*This is to search for users*/

//        var query = PFUser.query()
//        query.whereKey("gender", equalTo:"female")
//        var girls = query.findObjects()

/*This will collect data to parse*/

//PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)








/*NEVER LOSE THIS */
//            var userVal:CLLocationCoordinate2D = self.locationManager.location.coordinate;
//
//            theMapView.delegate = self;
//            theMapView.showsUserLocation = true;
//
//            var baseURL = "https://api.foursquare.com/v2/venues/explore?ll=\(userVal.latitude),\(userVal.longitude)&client_id=QNC1U3HQMW5OH55LR2T0VL15JD034DLSPCEGZ4X1KJBTLW1S&client_secret=RGMHRCOJXUX2GEI2RQ3COEZE0UZ4LYRCT5XAQISQ3D055FD1&v=\(getDate())&categoryId=4d4b7105d754a06376d81259&radius=8047"
//
//
//            NSURLConnection(request: NSURLRequest(URL: NSURL(string: baseURL)!), delegate: self);
//
//            println(baseURL);