//
//  KMPhotoTimelineContributionsCell.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMMovieDetailsSimilarMoviesCell.h"

@implementation KMMovieDetailsSimilarMoviesCell

#pragma mark -
#pragma mark Cell Init Methods

+ (KMMovieDetailsSimilarMoviesCell*) movieDetailsSimilarMoviesCell
{
    KMMovieDetailsSimilarMoviesCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"KMMovieDetailsSimilarMoviesCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

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

#pragma mark -
#pragma mark CollectionView Datasource Setup

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    UINib *nib = [UINib nibWithNibName:@"KMSimilarMoviesCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"KMSimilarMoviesCollectionViewCell"];
    
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.index = index;
    
    [self.collectionView reloadData];
}

@end
