//
//  KMDiscoverListCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "KMGillSansLabel.h"

@interface KMDiscoverListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *timelineImageView;
@property (weak, nonatomic) IBOutlet KMGillSansLightLabel *titleLabel;

@end
