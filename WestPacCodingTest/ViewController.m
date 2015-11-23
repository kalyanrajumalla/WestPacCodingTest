//
//  ViewController.m
//  WestPacCodingTest
//
//  Created by kalyanraju on 09/11/15.
//  Copyright © 2015 WestPac. All rights reserved.
//

#import "ViewController.h"
#import "WeatherForecastConstants.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperaturreLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ozoneLabel;
@property (nonatomic,strong) NSDictionary *backgroundImageKeysDict;
@property (nonatomic,strong) CLLocationManager *clLocationManager;
@property (nonatomic,strong) NSString* currentLocationCoordinates;
@property (nonatomic,strong) WeatherForecastServiceHandler *serviceHandler;
@property (nonatomic,strong) WeatherForecastModel* weatherForeCastModel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)refreshWeatherForecastView:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *ozoneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureTitleLabel;

@end

@implementation ViewController

#pragma mark -- View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.serviceHandler = [WeatherForecastServiceHandler WFSHsharedInstance];
    [self initializeAllWFAttributes];
    [self initializeBackGroundImagesDict];
    [self hideAllTitleLabels];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if ([self.clLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.clLocationManager requestAlwaysAuthorization];
    }
//    self.clLocationManager.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.clLocationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.clLocationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- Initializers
/*
 
 Method Name  : cLLocationManager
 Description  : getter for weathesummaryDictionary
 
 */

-(CLLocationManager*)clLocationManager{
    
    if(!_clLocationManager)
    {
        _clLocationManager = [[CLLocationManager alloc] init];
        _clLocationManager.delegate = self;
        _clLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _clLocationManager;
    
}

/*
 
 Method Name  : showAllTitleLabels
 Description  : to displays the titles
 
 */

-(void)showAllTitleLabels
{
    self.temperatureTitleLabel.hidden = NO;
    self.humidityTitleLabel.hidden = NO;
    self.ozoneTitleLabel.hidden = NO;
}
/*
 
 Method Name  : hideAllTitleLabels
 Description  : to hide the titles
 
 */

-(void)hideAllTitleLabels
{
    self.temperatureTitleLabel.hidden = YES;
    self.humidityTitleLabel.hidden = YES;
    self.ozoneTitleLabel.hidden = YES;
}


/*
 
 Method Name  : initializeAllWFAttributes
 Description  : to initialize view attribtes
 
 */

-(void)initializeAllWFAttributes
{
    self.timeZoneLabel.text     = @"";
    self.summaryLabel.text      = @"";
    self.temperaturreLabel.text = @"";
    self.humidityLabel.text     = @"";
    self.ozoneLabel.text        = @"";
}

/*
 
 Method Name  : initializeBackGroundImagesDict
 Description  : to initialize view background images dictionary
 
 */

-(void)initializeBackGroundImagesDict
{
    _backgroundImageKeysDict = [NSDictionary dictionaryWithObjectsAndKeys:kCloudImageName,kPartlyCloudyNight,kCloudImageName,kPartlyCloudyDay,kRainImageName,kRain,kDefaultImage,kClearNight,kSunnyImageName,kClearDay, nil];
}


#pragma mark -- CLLocationManager Delegate Methods

/*
 
 Method Name  : locationManager didUpdateLocations
 Parameters   : CLLocationManager instance and locations array
 Description  : to initialize view attribtes
 
 */

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *curLocation = [locations lastObject];
    
    NSLog(@"%@ response",curLocation);
    
    self.currentLocationCoordinates = [NSString stringWithFormat:@"%f,%f", curLocation.coordinate.latitude, curLocation.coordinate.longitude];
    if(self.currentLocationCoordinates.length>1)
    {
        [self getCurrentWeatherForecastDetails];
    }
    [self.clLocationManager stopUpdatingLocation];
}

/*
 
 Method Name  : locationManager didChangeAuthorizationStatus
 Parameters   : CLLocationManager instance and status
 Description  : to access location coordinayes
 
 */

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
        } break;
        case kCLAuthorizationStatusDenied: {
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.clLocationManager startUpdatingLocation];
        } break;
        default:
            break;
    }
}

#pragma mark -- Custom Methods
/*
 
 Method Name  : getCurrentWeatherForecastDetails
 Description  : to get weather forecast details for specified location coordinates
 
 */

-(void)getCurrentWeatherForecastDetails
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWeatherForecast_URL,self.currentLocationCoordinates]];
    self.serviceHandler.connectionDelegate = self;
    [self.serviceHandler sendRequestToServerWithURL:url];
}

/*
 
 Method Name  : parseResponse
 Parameters   : NSDictionary from reponse to websservice
 return parameter : WeatherForecastModel
 Description  : to parse response and convert to model
 
 */

-(WeatherForecastModel*)parseResponse:(NSDictionary*)responseDict
{
    WeatherForecastModel *currWeatherModel = [[WeatherForecastModel alloc]init];
    currWeatherModel.timeZone = responseDict[kTimeZone];
    NSDictionary*currentValuesDict = responseDict[kCurrently];
    currWeatherModel.summary = currentValuesDict[kSummary];
    currWeatherModel.temperature = currentValuesDict[kTemperature];
    currWeatherModel.humidity = currentValuesDict[kHumidity];
    currWeatherModel.ozone = currentValuesDict[kOzone];
    currWeatherModel.icon = currentValuesDict[kIcon];
    return currWeatherModel;
}

/*
 
 Method Name  : setViewAttributes
 Parameters   : WeatherForecastModel
 Description  : to set view attributes from webservice response
 
 */

-(void)setViewAttributes:(WeatherForecastModel*)weatherForecastModel
{
    self.timeZoneLabel.text = weatherForecastModel.timeZone;
    self.summaryLabel.text = weatherForecastModel.summary;
    self.temperaturreLabel.attributedText= [self attributedStringforFirstname:[NSString stringWithFormat:@"%@",weatherForecastModel.temperature] lastName:@"F"];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@",weatherForecastModel.humidity];
    self.ozoneLabel.text = [NSString stringWithFormat:@"%@",weatherForecastModel.ozone];
    if ([[_backgroundImageKeysDict allKeys] containsObject:weatherForecastModel.icon])
    {
        self.backgroundImageView.image = [UIImage imageNamed:[_backgroundImageKeysDict valueForKey:weatherForecastModel.icon]];
    } else
    {
        self.backgroundImageView.image = [UIImage imageNamed:kDefaultImage];
    }

}

/*
 
 Method Name  : attributedStringforFirstname
 Parameters   : header and value
 Description  : to display the temperature in appropriate manner.
 
 */


-(NSMutableAttributedString *)attributedStringforFirstname:(NSString *)header lastName:(NSString *)value{
    NSMutableAttributedString *attributedName;
    NSRange boldedRange;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",header,value];
    attributedName = [[NSMutableAttributedString alloc] initWithString:str];
    boldedRange = NSMakeRange([header length], [value length]);
    [attributedName addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Helvetica Neue" size:16] range:boldedRange];
    UIFont *fnt = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [attributedName setAttributes:@{NSFontAttributeName : [fnt fontWithSize:20]
                                      , NSBaselineOffsetAttributeName : @60} range:NSMakeRange([header length], [value length])];
    return attributedName;
}


#pragma mark -- Webservice Delegate Methods
/*
 
 Method Name  : didFailDownloadWithError
 Parameters   : NSError
 Description  : webservice error response
 
 */

- (void) didFailDownloadWithError:(NSError*)error
{
    self.activityIndicator.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to connect to server." message:@"Please check your network connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

}
/*
 
 Method Name  : didFinishDownloadWithResponse
 Parameters   : response dictionary
 Description  : webservice success response
 
 */

- (void) didFinishDownloadWithResponse:(NSDictionary *)responseObj
{
    self.activityIndicator.hidden = YES;
    [self showAllTitleLabels];
    [self setViewAttributes:[self parseResponse:responseObj]];
}

/*
 
 Method Name  : refreshWeatherForecastView
 Parameters   : sender
 Description  : refresh weatherforecast details
 
 */
#pragma mark -- Actions

- (IBAction)refreshWeatherForecastView:(id)sender
{
    self.activityIndicator.hidden = NO;
    [self initializeAllWFAttributes];
    [self hideAllTitleLabels];
    [self.clLocationManager startUpdatingLocation];
}
@end
