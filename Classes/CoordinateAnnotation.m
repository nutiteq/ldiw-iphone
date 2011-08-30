//
//  CoordinateAnnotation.m
//  Let's Do It
//
//  Created by Jaak Laineste on 08.06.11.
//  Copyright 2011 Nutiteq. All rights reserved.
//

#import "CoordinateAnnotation.h"


@implementation CoordinateAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

#pragma mark -
#pragma mark Class Methods

+ (CoordinateAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	return [self mapAnnotationWithCoordinate:aCoordinate title:nil subtitle:nil];
}


+ (CoordinateAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle {
	return [self mapAnnotationWithCoordinate:aCoordinate title:aTitle subtitle:nil];
}


+ (CoordinateAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle {
	CoordinateAnnotation *annotation = [[[self alloc] init] autorelease];
	annotation.coordinate = aCoordinate;
	annotation.title = aTitle;
	annotation.subtitle = aSubtitle;
	return annotation;
}


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[_title release];
	[_subtitle release];
	[super dealloc];
}


#pragma mark -
#pragma mark Initializers

- (CoordinateAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	return [self initWithCoordinate:aCoordinate title:nil subtitle:nil];
}


- (CoordinateAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle {
	return [self initWithCoordinate:aCoordinate title:aTitle subtitle:nil];
}


- (CoordinateAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle {
	if ((self = [super init])) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
	}
	return self;
}


@end
