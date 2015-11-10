//
//  WeatherForecastServiceHandler.h
//  WestPacCodingTest
//
//  Created by kalyanraju on 09/11/15.
//  Copyright © 2015 WestPac. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ConnectionDelegate <NSObject>

- (void) didFailDownloadWithError:(NSError*)error;

- (void) didFinishDownloadWithResponse:(NSDictionary *)responseObj;

@end


@interface WeatherForecastServiceHandler : NSObject
@property id<ConnectionDelegate> connectionDelegate;
+(WeatherForecastServiceHandler*)WFSHsharedInstance;
-(void)sendRequestToServerWithURL:(NSURL*)url;
@end
