//
//  MGRSHelper.h
//  GEOTRANS-CocoaPods
//
//  Created by Robert St. John on 9/24/18.
//  Copyright © 2018 GEOINT Services Mobile Apps. All rights reserved.
//

#ifndef MGRSHelper_h
#define MGRSHelper_h
    

#import "CoreLocation/CoreLocation.h"


@interface MGRSHelper : NSObject

- (NSString *) mgrsFromWgs84Degrees:(CLLocationCoordinate2D)coord utmZone:(int32_t)zone;
- (CLLocationCoordinate2D) wgs84DegreesFromMgrs:(NSString *)coord;

@end


#endif /* MGRSHelper_h */
