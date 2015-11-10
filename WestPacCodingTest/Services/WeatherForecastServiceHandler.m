//
//  WeatherForecastServiceHandler.m
//  WestPacCodingTest
//
//  Created by kalyanraju on 09/11/15.
//  Copyright © 2015 WestPac. All rights reserved.
//

#import "WeatherForecastServiceHandler.h"

@implementation WeatherForecastServiceHandler
static WeatherForecastServiceHandler *sharedInstance = nil;
/*
 
 Method Name  : WFSHsharedInstance
 Description  : to get shared instance for WeatherForecastServiceHandler
 
 */

+(WeatherForecastServiceHandler*)WFSHsharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[WeatherForecastServiceHandler alloc]init];
    }
    return sharedInstance;
}

/*
 
 Method Name  : sendRequestToServerWithURL
 Parameters   : NSURL
 Description  : to get weatherforecast information  URL specified
 
 */


-(void)sendRequestToServerWithURL:(NSURL*)url
{
    NSURLSession * urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * sessionDataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                       {
                                           NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                           if(!response||statusCode >= 400)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self.connectionDelegate didFailDownloadWithError:error];
                                               });
                                           }
                                           else
                                           {
                                               if(data.length>1)
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       NSDictionary * responseDict = nil;
                                                       responseDict  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                       [self.connectionDelegate didFinishDownloadWithResponse:responseDict];
                                                   });
                                               }
                                                else
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [self.connectionDelegate didFailDownloadWithError:error];
                                                   });
                                               }
                                           }
                                       }];
    [sessionDataTask resume] ;
}



@end
