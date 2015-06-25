//
//  KMPhotoTimelineDetailsCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "KMGillSansLabel.h"

@interface KMMovieDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *posterImageView;
@property (weak, nonatomic) IBOutlet KMGillSansLightLabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;


@property (weak, nonatomic) IBOutlet UIButton *watchTrailerButton;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;

+ (KMMovieDetailsCell*) movieDetailsCell;

@end
