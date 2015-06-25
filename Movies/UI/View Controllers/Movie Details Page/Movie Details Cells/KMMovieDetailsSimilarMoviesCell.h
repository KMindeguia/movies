//
//  KMPhotoTimelineContributionsCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMGillSansLabel.h"
#import "KMIndexedCollectionView.h"

@interface KMMovieDetailsSimilarMoviesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet KMIndexedCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *viewAllSimilarMoviesButton;

+ (KMMovieDetailsSimilarMoviesCell*) movieDetailsSimilarMoviesCell;
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;

@end
