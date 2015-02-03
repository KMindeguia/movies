//
//  KMPhotoTimelineCommentsCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface KMMovieDetailsCommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *cellImageView;

+ (KMMovieDetailsCommentsCell*) movieDetailsCommentsCell;

@end
