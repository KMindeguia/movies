//
//  KMMovieDetailsPopularityCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMMovieDetailsPopularityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteAverageLabel;

+ (KMMovieDetailsPopularityCell*) movieDetailsPopularityCell;

@end
