//
//  PointAnnotation.m
//  Do It
//
//  Created by Vytautas on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PointAnnotation.h"


@implementation PointAnnotation

@synthesize pointData;
@synthesize coordinate=_coordinate;

- (id)initWithPointData:(NSDictionary *)_pointData
{
    self = [super init];
	if (self != nil) {
		CLLocationCoordinate2D location;
		location.latitude = [[_pointData objectForKey:@"lat"] floatValue];	
		location.longitude = [[_pointData objectForKey:@"lon"] floatValue];
		_coordinate = location;
        self.pointData = _pointData;
	}
	return self;
}

- (NSString *) title 
{
	return [NSString stringWithFormat:@"ID: %@", [pointData objectForKey:@"id"]];
}

- (NSString *)subtitle 
{
    NSString *string = [[[pointData objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
	return string;
}

@end
