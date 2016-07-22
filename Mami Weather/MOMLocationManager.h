//
//  MOMLocationManager.h
//  Mami Weather
//
//  Created by bakerydev004 on 22/7/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h>

@protocol MOMLocationManagerDelegate <NSObject>
- (void)didAcquireLocation:(CLLocation *)location;
- (void)didFailToAcquireLocationWithErrorMessage:(NSString *)errorMsg;
@optional
- (void)didFindLocationName:(NSString *)locationName;
@end

@interface MOMLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id <MOMLocationManagerDelegate>delegate;

+ (id)sharedManager;
- (void)startUpdatingLocation;
- (void)findNameForLocation:(CLLocation *)location;

@end
