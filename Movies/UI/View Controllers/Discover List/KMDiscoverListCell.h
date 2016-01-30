//
//  KMDiscoverListCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMGillSansLabel.h"

@interface KMDiscoverListCell : UITableViewCell

/**
 *  The movie's backdrop image view
 */
@property (weak, nonatomic) IBOutlet UIImageView *timelineImageView;

/**
 *  The movie's title label.
 */
@property (weak, nonatomic) IBOutlet KMGillSansLightLabel *titleLabel;

@end
