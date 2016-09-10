//
//  PlacesTableViewCell.h
//  Qwickd
//
//  Created by Jay on 5/22/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesTableViewCell : UITableViewCell
{
    UIView *containerView;
    UIImageView *imageView;
}

@property (nonatomic) UILabel *addressLabel;
@property (nonatomic) UILabel *placeNameLabel;

@end
