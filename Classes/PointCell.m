//
//  PointCell.m
//  Do It
//
//  Created by Vytautas on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PointCell.h"


@implementation PointCell

@synthesize idLabel, rangeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
//    [idLabel release];
//    [rangeLabel release];
}

@end
