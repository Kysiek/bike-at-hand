//
//  StationParser.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationParser.h"
#import "Station.h"

@interface StationParser()
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *element;

//Station properties
@property (nonatomic, strong) NSDictionary* currentStationDictionary;



@end
@implementation StationParser

@synthesize currentStationDictionary = _currentStationDictionary;

static NSString* stationNameKey = @"name";
static NSString* stationNumberKey = @"number";
static NSString* bikesAvailableKey = @"bikes";
static NSString* bikesRacksKey = @"bike_racks";
static NSString* bikesKey = @"bike_numbers";
static NSString* latitudeKey = @"lat";
static NSString* longitudeKey = @"lng";
static NSString* stationTags = @"place";

- (id)initWithArray:(NSMutableArray *)stationArray {
    self = [super init];
    if(self) {
        self.stationArray = stationArray;
    }
    return self;
}

- (void)parseXMLFile:(NSData*) xmlData {
    self.parser = [[NSXMLParser alloc] initWithData:xmlData];
    self.parser.delegate = self;
    [self.parser parse];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
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
