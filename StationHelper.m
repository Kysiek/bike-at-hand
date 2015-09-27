//
//  StationHelper.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationHelper.h"
#import "Configuration.h"
#import "ConnectionHelper.h"
#import "Station.h"

@interface StationHelper()
@property (nonatomic, strong) NSMutableArray* stationArray;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *element;

@property (nonatomic, strong) NSDictionary* currentStationDictionary;
@end
@implementation StationHelper

@synthesize currentStationDictionary = _currentStationDictionary;

static NSString* stationNameKey = @"name";
static NSString* stationNumberKey = @"number";
static NSString* bikesAvailableKey = @"bikes";
static NSString* bikesRacksKey = @"bike_racks";
static NSString* bikesKey = @"bike_numbers";
static NSString* latitudeKey = @"lat";
static NSString* longitudeKey = @"lng";
static NSString* stationTags = @"place";

- (void) parseXMLData:(NSData*)xmlData {
    self.parser = [[NSXMLParser alloc] initWithData:xmlData];
    self.parser.delegate = self;
    self.stationArray = [[NSMutableArray alloc] init];
    [self.parser parse];
}

- (void)getStationsByCityId:(NSString *)cityId {
    NSString* url = [NSString stringWithFormat:stationURL, cityId];
    ConnectionHelper* connectionHelper = [ConnectionHelper mainConnectionHelper];
    __weak StationHelper* weakSelf = self;
    [connectionHelper getDataASync:url completion:^(NSData* data, NSError *error) {
        [weakSelf parseXMLData:data];
    }];
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.delegate stationsLoaded:self.stationArray];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary<NSString *,
                NSString *> *)attributeDict {
    if([elementName isEqualToString:stationTags]) {
        self.currentStationDictionary = attributeDict;
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:stationTags ]) {
        Station* newStation = [Station stationFromDictionary:self.currentStationDictionary];
        [self.stationArray addObject:newStation];
    }
    self.element = nil;
}

- (NSDictionary*) currentStationDictionary {
    if(_currentStationDictionary == nil) {
        _currentStationDictionary = [[NSDictionary alloc] init];
    }
    return _currentStationDictionary;
}
@end
