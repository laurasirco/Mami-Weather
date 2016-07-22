//
//  MOMWeather.h
//  Mami Weather
//
//  Created by bakerydev004 on 22/7/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MOMWeather : MTLModel <MTLJSONSerializing>

//CURRENT VALUES
@property (nonatomic, strong) NSNumber * apparentTemperature;
@property (nonatomic, strong) NSNumber * cloudCover;
@property (nonatomic, strong) NSNumber * precipIntensity;
@property (nonatomic, strong) NSNumber * precipProbability;
@property (nonatomic, strong) NSString * precipType;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSNumber * temperature;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSNumber * windBearing;
@property (nonatomic, strong) NSNumber * windSpeed;
@property (nonatomic, strong) NSNumber * visibility;

//FORECAST VALUES
@property (nonatomic, strong) NSNumber * apparentTemperatureMax;
@property (nonatomic, strong) NSNumber * apparentTemperatureMin;
@property (nonatomic, strong) NSDate * apparentTemperatureMaxTime;
@property (nonatomic, strong) NSDate * apparentTemperatureMinTime;
@property (nonatomic, strong) NSNumber * moonPhase;
@property (nonatomic, strong) NSNumber * precipIntensityMax;
@property (nonatomic, strong) NSDate * precipIntensityTime;
@property (nonatomic, strong) NSNumber * temperatureMax;
@property (nonatomic, strong) NSNumber * temperatureMin;
@property (nonatomic, strong) NSDate * temperatureMaxTime;
@property (nonatomic, strong) NSDate * temperatureMinTime;
@property (nonatomic, strong) NSDate * sunriseTime;
@property (nonatomic, strong) NSDate * sunsetTime;

+ (MOMWeather *)currentWeather;
+ (void)setCurrentWeather:(MOMWeather *)weather;

@end
