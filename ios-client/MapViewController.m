//
//  MapViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "MapViewController.h"
#import "Station.h"
#import "Configuration.h"
#import "StationService.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) StationService* stationService;

@end

@implementation MapViewController
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barButton.title = mapViewControllerTitle;
    
    [self setMapRegion];
    self.stationService = [StationService getInstance];
    
    //adding observator to the notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:StationsArrivalNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:StationsErrorNotification
                                               object:nil];
    
    [self updateStations:[self.stationService getStationsArray]];
}
- (void) receivedNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:StationsArrivalNotification]) {
        [self updateStations:[self.stationService getStationsArray]];
    } else if([[notification name] isEqualToString:StationsErrorNotification]) {
        [self showErrorMessage:[self.stationService getErrorMessage] forViewController:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) updateStations:(NSArray*) stations {
    if(stations) {
        NSMutableArray* annotationsArray = [[NSMutableArray alloc]initWithCapacity:[stations count]];
        for(Station* station in stations) {
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D locationPoint;
            locationPoint.latitude = [station.latitude doubleValue];
            locationPoint.longitude = [station.longitude doubleValue];
            
            [point setCoordinate:locationPoint];
            point.title = station.stationName;
            point.subtitle = [station bikesAvailabilityString];
            
            [annotationsArray addObject:point];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:annotationsArray];
            [self.mapView updateConstraints];
        });
    }
}

-(void) setMapRegion {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    CLLocationCoordinate2D locationPoint;
    locationPoint.latitude = [wroclawLat doubleValue];
    locationPoint.longitude = [wroclawLng doubleValue];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5f,0.5f);
    MKCoordinateRegion region = {locationPoint, span};
    [self.mapView setRegion:region];
}


-(void) dealloc {
    //Removing observer - we need to do it otherwise there will be exception when property would be changed and this instance would not exist
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
