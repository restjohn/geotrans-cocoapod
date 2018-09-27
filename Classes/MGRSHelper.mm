//
//  MGRSHelper.m
//  GEOTRANS-CocoaPods
//
//  Created by Robert St. John on 9/24/18.
//  Copyright © 2018 GEOINT Services Mobile Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"
#import <math.h>
#import "MGRSHelper.h"
#import "UTM.h"
#import "UTMCoordinates.h"
#import "UPS.h"
#import "UPSCoordinates.h"
#import "MGRS.h"
#import "CoordinateType.h"
#import "GeodeticCoordinates.h"
#import "MGRSorUSNGCoordinates.h"

#define UTM_MIN_LAT (-80.0 * (M_PI / 180.0)) /* -80 deg in rad */
#define UTM_MAX_LAT (84.0 * (M_PI / 180.0)) /*  84 deg in rad */
#define UTM_LAT_EPSILON 1.75e-7   /* approx 1.0e-5 degrees (~1 meter) in radians */

@interface MGRSHelper () {
    MSP::CCS::MGRS *mgrsSystem;
    MSP::CCS::UTM *utmSystem;
    MSP::CCS::UPS *upsSystem;
}

@end

@implementation MGRSHelper

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    utmSystem = new MSP::CCS::UTM();
    double semiMajor = 0.0, flattening = 0.0;
    utmSystem->getEllipsoidParameters(&semiMajor, &flattening);
    upsSystem = new MSP::CCS::UPS(semiMajor, flattening);
    mgrsSystem = new MSP::CCS::MGRS(semiMajor, flattening, (char *) @"WE".UTF8String);
    return self;
}

- (void)dealloc
{
    delete utmSystem;
    delete upsSystem;
    delete mgrsSystem;
    utmSystem = NULL;
    upsSystem = NULL;
    mgrsSystem = NULL;
}

- (NSString *)mgrsFromWgs84Degrees:(CLLocationCoordinate2D)coord utmZone:(int32_t)zone
{
    using namespace MSP::CCS;
    double latRad = coord.latitude * M_PI / 180.0;
    double lonRad = coord.longitude * M_PI / 180.0;
    GeodeticCoordinates geoCoords(CoordinateType::geodetic, lonRad, latRad, 0.0);
    MGRSorUSNGCoordinates *mgrsCoords = NULL;
    if ([MGRSHelper utmContainsLatitudeInRadians:latRad]) {
        UTMCoordinates *utmCoords = utmSystem->convertFromGeodetic(&geoCoords, zone);
        mgrsCoords = mgrsSystem->convertFromUTM(utmCoords, 5);
        delete utmCoords;
    }
    else {
        UPSCoordinates *upsCoords = upsSystem->convertFromGeodetic(&geoCoords);
        mgrsCoords = mgrsSystem->convertFromUPS(upsCoords, 5);
        delete upsCoords;
    }
    NSString *result = [NSString stringWithUTF8String:mgrsCoords->MGRSString()];
    delete mgrsCoords;
    return result;
}

- (CLLocationCoordinate2D)wgs84DegreesFromMgrs:(NSString *)coord
{
    using namespace MSP::CCS;
    MGRSorUSNGCoordinates mgrs(CoordinateType::militaryGridReferenceSystem, coord.UTF8String);
    GeodeticCoordinates *wgs84 = mgrsSystem->convertToGeodetic(&mgrs);
    double latDeg = wgs84->latitude() * 180.0 / M_PI;
    double lonDeg = wgs84->longitude() * 180.0 / M_PI;
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latDeg, lonDeg);
    delete wgs84;
    return loc;
}

+ (BOOL) utmContainsLatitudeInRadians:(double)latitude
{
    return latitude >= UTM_MIN_LAT - UTM_LAT_EPSILON && latitude < UTM_MAX_LAT + UTM_LAT_EPSILON;
}

@end
