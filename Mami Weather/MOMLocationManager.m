//
//  MOMLocationManager.m
//  Mami Weather
//
//  Created by bakerydev004 on 22/7/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import "MOMLocationManager.h"

static NSString *kFCErrorDeniedErrorMsg = @"This app does not have permission to access your location. Please enable location access in device settings.";
static NSString *kFCErrorHeadingFailureErrorMsg = @"We were unable to retrieve your current location.  Please ensure you are in an area with good network reception.";
static NSString *kFCErrorNetworkErrorMsg = @"The network was unavailable or a network error occurred. Please ensure you have an internet connection.";
static NSString *kFCTimeoutError = @"There was a timeout while attempting to determine your current location.  Please ensure you are in an area with good network reception.";

@interface MOMLocationManager (){
    CLLocationManager *locationManager;
    CLLocation *bestEffortAtLocation;
}

@end

@implementation MOMLocationManager

@synthesize delegate = _delegate;

+ (id)sharedManager
{
    static MOMLocationManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        // Init code here
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

# pragma mark - Location Polling

- (void)startUpdatingLocation
{
    NSLog(@"Started updating location.");
    
    // Reset the last best effort (otherwise it might hang the next time it tries to find a GPS location)
    bestEffortAtLocation = nil;
    
    // Create the manager object
    if (!locationManager) locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        // Request permission if necessary
        [locationManager requestWhenInUseAuthorization];
    }

    // Set accuracy (i.e battery power consumption) and start updating
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
    
    // Timeout after 10 seconds of trying to get location
    [self performSelector:@selector(handleFatalError:) withObject:kFCTimeoutError afterDelay:10.0f];
}

// Stops the location manager from updating the location (to preserve power consumption)
- (void)stopUpdatingLocation
{
    NSLog(@"Stopped updating location.");
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    
    // If called from something other than the timeout selector, cancel any previous
    // performSelector:withObject:afterDelay: since it's no longer necessary
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleFatalError:) object:kFCTimeoutError];
}

// Stop updating the location and notify the delegate after a fatal error
- (void)handleFatalError:(NSString *)errorMsg
{
    // Stop updating location to save power consumption
    [self stopUpdatingLocation];
    
    // Notify the delegate that it had a fatal error
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailToAcquireLocationWithErrorMessage:)]) {
        [self.delegate didFailToAcquireLocationWithErrorMessage:errorMsg];
    }
}

// Handle all location errors (some are fatal, some you should ignore)
- (void)handleLocationError:(NSError *)error
{
    switch ([error code])
    {
        case kCLErrorDenied:
            [self handleFatalError:kFCErrorDeniedErrorMsg];
            break;
            
        case kCLErrorHeadingFailure:
            [self handleFatalError:kFCErrorHeadingFailureErrorMsg];
            break;
            
        case kCLErrorNetwork:
            [self handleFatalError:kFCErrorNetworkErrorMsg];
            break;
            
        case kCLErrorLocationUnknown:
            NSLog(@"Error retrieving location.  Retrying...");
            break;
            
        default:
            NSLog(@"We had an unknown error while trying to retrieve the user location: %@", error.localizedDescription);
            break;
    }
}

# pragma mark - Reverse Geocode

// Reverse geocode the location name based on the coordinates
- (void)findNameForLocation:(CLLocation *)location
{
    __block NSString *locationName;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error) {
             locationName = [self localizedCoordinateStringForLocation:location];
         } else if (placemarks && placemarks.count > 0) {
             CLPlacemark *topResult = [placemarks objectAtIndex:0];
             locationName = [topResult locality];
             
             // Check that the returned locality wasn't null
             // If it is, just return the localized coordinates instead
             if (!locationName.length)
                 locationName = [self localizedCoordinateStringForLocation:location];
         }
         
         // Notify the delegate
         if (self.delegate && [self.delegate respondsToSelector:@selector(didFindLocationName:)]) {
             [self.delegate didFindLocationName:locationName];
         }
     }];
}

// Returns a localized string containing the location coordinates
- (NSString *)localizedCoordinateStringForLocation:(CLLocation *)location
{
    NSString *latString = (location.coordinate.latitude < 0) ? @"South" : @"North";
    NSString *lonString = (location.coordinate.longitude < 0) ? @"West" : @"East";
    return [NSString stringWithFormat:@"%.3f %@, %.3f %@", fabs(location.coordinate.latitude), latString, fabs(location.coordinate.longitude), lonString];
}

# pragma mark - Location Services Delegate

// Find and store a location measurement that meets the desired horizontal accuracy
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    // Test the age of the location measurement to determine if the measurement is cached (in which case, we don't want it)
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    // Test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    // Test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        
        // Store the location as the "best effort"
        bestEffortAtLocation = newLocation;
        
        // Test the measurement to see if it meets the desired accuracy
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // Minimize power usage by stopping the location manager as soon as possible.
            [self stopUpdatingLocation];
            
            // Let the delegate know that we acquired a location
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAcquireLocation:)]) {
                [self.delegate didAcquireLocation:bestEffortAtLocation];
            }
        }
    }
}

// Delegate callback for location services authorization
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // The user has not authorized us to access their location
    if (status == kCLAuthorizationStatusDenied)
        [self handleFatalError:kFCErrorDeniedErrorMsg];
}

// Delegate callback to handle errors from location manager
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self handleLocationError:error];
}

@end
