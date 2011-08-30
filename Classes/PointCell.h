//
//  PointCell.h
//  Do It
//
//  Created by Vytautas on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PointCell : UITableViewCell 
{
    UILabel *idLabel;
    UILabel *rangeLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *idLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabel;

@end
