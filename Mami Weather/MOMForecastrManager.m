//
//  MOMForecastrManager.m
//  Mami Weather
//
//  Created by bakerydev004 on 22/7/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import "MOMForecastrManager.h"
#import "Forecastr.h"
#import "MOMWeather.h"
#import <Mantle/Mantle.h>

@implementation MOMForecastrManager

+ (MOMForecastrManager *)sharedManager
{
    static MOMForecastrManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] initWithForecastrOptions];
    });
    
    return _sharedManager;
}

- (instancetype)initWithForecastrOptions
{
    self = [super init];
    
    if (self) {
        Forecastr * forecastr = [Forecastr sharedManager];
        forecastr.apiKey = @"de7d16091bef159796e176e83ef452dd";
        forecastr.units = @"si";
    }
    
    return self;
}


#pragma mark - Methods

- (void) getCurrentWeatherAndDailyForecastForLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude completion:(void (^)(MOMWeather * current, NSArray<MOMWeather *> * daily, NSArray<MOMWeather *> * hourly))completion {
    
    //TODO: HANDLE ERROR
    NSArray *tmpExclusions = @[kFCAlerts, kFCFlags, kFCMinutelyForecast];
    [[Forecastr sharedManager] getForecastForLatitude:latitude.floatValue longitude:longitude.floatValue time:nil exclusions:tmpExclusions extend:kFCExtendHourly language:@"es" success:^(id JSON) {
        
        NSDictionary * dictionary = (NSDictionary *)JSON;
        NSError * error;
        MOMWeather * currentWeather = [MTLJSONAdapter modelOfClass:MOMWeather.class fromJSONDictionary:[dictionary objectForKey:@"currently"] error:&error];
        NSArray<MOMWeather *> * dailyWeather = [MTLJSONAdapter modelsOfClass:MOMWeather.class fromJSONArray:[[dictionary objectForKey:@"daily"] objectForKey:@"data"] error:&error];
        NSArray<MOMWeather *> * hourlyWeather = [MTLJSONAdapter modelsOfClass:MOMWeather.class fromJSONArray:[[dictionary objectForKey:@"hourly"] objectForKey:@"data"] error:&error];
        completion(currentWeather, dailyWeather, hourlyWeather);
        
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [[Forecastr sharedManager] messageForError:error withResponse:response]);
        
    }];
}

@end
