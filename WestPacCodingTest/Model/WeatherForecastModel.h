//
//  WeatherForecastModel.h
//  WestPacCodingTest
//
//  Created by kalyanraju on 09/11/15.
//  Copyright © 2015 WestPac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecastModel : NSObject
@property (nonatomic, strong) NSString* timeZone;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSString* temperature;
@property (nonatomic, strong) NSString* humidity;
@property (nonatomic, strong) NSString* ozone;

@end
