//
//  MOMWeather.m
//  Mami Weather
//
//  Created by bakerydev004 on 22/7/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import "MOMWeather.h"

@implementation MOMWeather

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"apparentTemperature":@"apparentTemperature",
             @"cloudCover":@"cloudCover",
             @"precipIntensity":@"precipIntensity",
             @"precipProbability":@"precipProbability",
             @"precipType":@"precipType",
             @"summary":@"summary",
             @"temperature":@"temperature",
             @"time":@"time",
             @"windBearing":@"windBearing",
             @"windSpeed":@"windSpeed",
             @"visibility":@"visibility",
             @"apparentTemperatureMax":@"apparentTemperatureMax",
             @"apparentTemperatureMin":@"apparentTemperatureMin",
             @"apparentTemperatureMaxTime":@"apparentTemperatureMaxTime",
             @"apparentTemperatureMinTime":@"apparentTemperatureMinTime",
             @"moonPhase":@"moonPhase",
             @"precipIntensityMax":@"precipIntensityMax",
             @"precipIntensityTime":@"precipIntensityTime",
             @"temperatureMax":@"temperatureMax",
             @"temperatureMin":@"temperatureMin",
             @"temperatureMaxTime":@"temperatureMaxTime",
             @"temperatureMinTime":@"temperatureMinTime",
             @"sunriseTime":@"sunriseTime",
             @"sunsetTime":@"sunsetTime"
             };
}

+ (NSValueTransformer *)timeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)apparentTemperatureMaxTimeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)apparentTemperatureMinTimeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)precipIntensityTimeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)temperatureMaxTimeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)temperatureMinTimeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)sunriseTimeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)sunsetTimeJSONTransformer {
    
    return [MOMWeather dateValueTransformer];
}

+ (NSValueTransformer *)dateValueTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateNumber, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:dateNumber.doubleValue];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSinceNow]];
    }];
}

@end
