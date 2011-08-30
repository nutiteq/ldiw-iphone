//
//  CoordinateAnnotation.h
//  Let's Do It
//
//  Created by Jaak Laineste on 08.06.11.
//  Copyright 2011 Nutiteq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CoordinateAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
    NSString * _title;
    NSString * _subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (CoordinateAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
+ (CoordinateAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
+ (CoordinateAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;

- (CoordinateAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
- (CoordinateAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
- (CoordinateAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;

@end
