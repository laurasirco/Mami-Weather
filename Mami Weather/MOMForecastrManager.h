//
//  MOMForecastrManager.h
//  Mami Weather
//
//  Created by bakerydev004 on 22/7/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOMWeather;

@interface MOMForecastrManager : NSObject

+ (MOMForecastrManager *)sharedManager;

- (void) getCurrentWeatherAndDailyForecastForLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude completion:(void (^) (MOMWeather * current, NSArray<MOMWeather *> * daily, NSArray<MOMWeather *> * hourly))completion;

@end
