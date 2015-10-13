//
//  MapStationViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 05/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "MapStationViewController.h"

#import "Configuration.h"
#import "Station.h"


@interface MapStationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barButton.title = mapViewControllerTitle;
    [self setMapRegion];
    [self updateStations];
    // Do any additional setup after loading the view.
}
-(void) updateStations {
    if(self.stations) {
        NSMutableArray* annotationsArray = [[NSMutableArray alloc]initWithCapacity:[self.stations count]];
        for(Station* station in self.stations) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
