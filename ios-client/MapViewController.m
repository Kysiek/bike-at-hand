//
//  MapViewController.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 18/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "MapViewController.h"
#import "Station.h"
#import "Configuration.h"
#import "StationService.h"
#import "StationDetailsViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) StationService* stationService;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) dealloc {
    //Removing observer - we need to do it otherwise there will be exception when property would be changed and this instance would not exist
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"ann.title = %@", view.annotation.title);
    [self performSegueWithIdentifier:@"showDetailsFromMapSegue" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showDetailsFromMapSegue"]) {
        MKAnnotationView *tappedAnnotation = (MKAnnotationView*) sender;
        Station *tappedStation = [self.stationService getStationForName:tappedAnnotation.annotation.title];
        StationDetailsViewController *stationDetailsVC = (StationDetailsViewController*)segue.destinationViewController;
        stationDetailsVC.hidesBottomBarWhenPushed = YES;
        stationDetailsVC.station = tappedStation;
    }
}
#pragma mark - Notifications
- (void) receivedNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:StationsArrivalNotification]) {
        [self updateStations:[self.stationService getStationsArray]];
    } else if([[notification name] isEqualToString:StationsErrorNotification]) {
        //TODO: On error
    }
}
#pragma mark - Private helpers
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

    MKCoordinateSpan span = MKCoordinateSpanMake(0.05f,0.05f);
    MKCoordinateRegion region = {locationPoint, span};
    [self.mapView setRegion:region];
 }

@end
