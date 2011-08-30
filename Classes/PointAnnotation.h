//
//  PointAnnotation.h
//  Do It
//
//  Created by Vytautas on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PointAnnotation : NSObject <MKAnnotation>
{
	NSDictionary *pointData;
}

@property (nonatomic, retain) NSDictionary *pointData;

- (id)initWithPointData:(NSDictionary *)_pointData;

@end
