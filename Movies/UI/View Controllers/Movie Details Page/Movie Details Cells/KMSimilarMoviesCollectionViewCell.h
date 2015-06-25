//
//  KMSimilarMoviesCollectionViewCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface KMSimilarMoviesCollectionViewCell : UICollectionViewCell

+ (KMSimilarMoviesCollectionViewCell*) similarMoviesCollectionViewCell;

@property (weak, nonatomic) IBOutlet EGOImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;

@end
