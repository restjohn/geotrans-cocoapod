//
//  MGRSHelperSpec.m
//  GEOTRANS
//
//  Created by Robert St. John on 9/25/18.
//  Copyright 2018 restjohn. All rights reserved.
//

#import "MGRSHelper.h"
#import "YLFileReader.h"

#define COL_TEST_ID 0
#define COL_GEO_MGRS_LAT 7
#define COL_GEO_MGRS_LON 8
#define COL_GEO_MGRS_EXPECTED_MGRS 13
#define COL_MGRS_GEO_MGRS 7
#define COL_MGRS_GEO_EXPECTED_LAT 13
#define COL_MGRS_GEO_EXPECTED_LON 14

@interface MGRSHelperTestUtil : NSObject

- (void)loadGeoToMgrsTestRecords:(void (^)(NSString *testId, CLLocationCoordinate2D wgs84Coord, NSString *expectedMgrs))consumer;
- (void)loadMgrsToGeoTestRecords:(void (^)(NSString *testId, NSString *mgrsCoord, CLLocationCoordinate2D expectedLocation))consumer;

@end

@implementation MGRSHelperTestUtil

- (void)loadGeoToMgrsTestRecords:(void (^)(NSString *testId, CLLocationCoordinate2D wgs84Coord, NSString *expectedMgrs))consumer
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *testDataPath = [bundle pathForResource:@"geoToMgrs_WE" ofType:@"txt"];
    YLFileReader *testDataReader = [[YLFileReader alloc] initWithFilePath:testDataPath encoding:NSUTF8StringEncoding];
    // skip header
    [testDataReader readLine];
    [testDataReader readLine];
    while (!testDataReader.lastError) {
        NSString *testLine = [testDataReader readLine];
        NSArray *testValues = [testLine componentsSeparatedByString:@"\t"];
        if (testValues.count < COL_GEO_MGRS_EXPECTED_MGRS) {
            continue;
        }
        NSString *testId = testValues[COL_TEST_ID];
        NSString *lat = testValues[COL_GEO_MGRS_LAT];
        NSString *lon = testValues[COL_GEO_MGRS_LON];
        NSString *expectedMgrs = testValues[COL_GEO_MGRS_EXPECTED_MGRS];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
        consumer(testId, loc, expectedMgrs);
    }
}

- (void)loadMgrsToGeoTestRecords:(void (^)(NSString *testId, NSString *mgrsCoord, CLLocationCoordinate2D expectedLocation))consumer
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *testDataPath = [bundle pathForResource:@"mgrsToGeo_WE" ofType:@"txt"];
    YLFileReader *testDataReader = [[YLFileReader alloc] initWithFilePath:testDataPath encoding:NSUTF8StringEncoding];
    // skip header
    [testDataReader readLine];
    [testDataReader readLine];
    while (!testDataReader.lastError) {
        NSString *testLine = [testDataReader readLine];
        NSArray *testValues = [testLine componentsSeparatedByString:@"\t"];
        if (testValues.count < COL_MGRS_GEO_EXPECTED_LON) {
            continue;
        }
        NSString *testId = testValues[COL_TEST_ID];
        NSString *mgrs = testValues[COL_MGRS_GEO_MGRS];
        NSString *lat = testValues[COL_MGRS_GEO_EXPECTED_LAT];
        NSString *lon = testValues[COL_MGRS_GEO_EXPECTED_LON];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
        consumer(testId, mgrs, loc);
    }
}

@end

SpecBegin(MGRSHelper)

describe(@"MGRSHelper", ^{

    MGRSHelperTestUtil *util = [[MGRSHelperTestUtil alloc] init];

    beforeAll(^{

    });
    
    beforeEach(^{

    });

    it(@"converts wgs84 to mgrs", ^{

        MGRSHelper *helper = [[MGRSHelper alloc] init];
        NSMutableArray<NSString *> *failures = [NSMutableArray array];
        [util loadGeoToMgrsTestRecords:^(NSString *testId, CLLocationCoordinate2D wgs84Coord, NSString *expectedMgrs) {
            NSString *mgrs = [helper mgrsFromWgs84Degrees:wgs84Coord utmZone:0];
            if (![mgrs isEqualToString:expectedMgrs]) {
                [failures addObject:[NSString stringWithFormat:@"%@ %f %f expected %@ but was %@", testId, wgs84Coord.longitude, wgs84Coord.latitude, expectedMgrs, mgrs]];
            }
        }];
        if (failures.count > 0) {
            [failures insertObject:[NSString stringWithFormat:@"%ld test cases failed:", failures.count] atIndex:0];
            failure([failures componentsJoinedByString:@"\n  "]);
        }
    });

    it(@"converts mgrs to wgs84", ^{

        MGRSHelper *helper = [[MGRSHelper alloc] init];
        NSMutableArray<NSString *> *failures = [NSMutableArray array];
        [util loadMgrsToGeoTestRecords:^(NSString *testId, NSString *mgrs, CLLocationCoordinate2D expectedLoc) {
            CLLocationCoordinate2D loc = [helper wgs84DegreesFromMgrs:mgrs];
            double latDiff = fabs(loc.latitude - expectedLoc.latitude);
            double lonDiff = fabs(loc.longitude - expectedLoc.longitude);
            if (latDiff > 1.0e-6 || lonDiff > 1.0e-6) {
                [failures addObject:[NSString stringWithFormat:@"%@ %@ expected %f %f but was %f %f", testId, mgrs,
                    expectedLoc.longitude, expectedLoc.latitude, loc.longitude, loc.latitude]];
            }
        }];
        if (failures.count > 0) {
            [failures insertObject:[NSString stringWithFormat:@"%ld test cases failed:", failures.count] atIndex:0];
            failure([failures componentsJoinedByString:@"\n  "]);
        }
    });
    
    afterEach(^{

    });
    
    afterAll(^{

    });
});

SpecEnd
