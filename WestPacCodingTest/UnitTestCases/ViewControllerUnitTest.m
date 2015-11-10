//
//  ViewControllerUnitTest.m
//  WestPacCodingTest
//
//  Created by kalyanraju on 10/11/15.
//  Copyright © 2015 WestPac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "WeatherForecastModel.h"
#import "WeatherForecastConstants.h"

@interface ViewController(Test)

-(WeatherForecastModel*)parseResponse:(NSDictionary*)responseDict;

@end


@interface ViewControllerUnitTest : XCTestCase
@property (nonatomic,strong) ViewController* viewControllerTest;
@end

@implementation ViewControllerUnitTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    self.viewControllerTest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.viewControllerTest = nil;
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

/*
 
 Method Name  : testParseResonse
 Description  : to TEST parseResponse method in ViewController
 
 */

-(void)testParseResonse
{
    WeatherForecastModel* weatherModel = [self.viewControllerTest parseResponse:@{kTimeZone:@"India",kCurrently:@{@"summary":@"cloudy"}}];
    XCTAssertEqual(weatherModel.timeZone, @"India",@"ParseResponse method is Successfully Tested");
    XCTAssertEqual(weatherModel.summary, @"cloudy",@"Pass");
    
}



@end
