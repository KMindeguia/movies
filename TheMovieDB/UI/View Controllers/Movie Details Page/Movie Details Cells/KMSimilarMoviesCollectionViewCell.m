//
//  KMContributionCollectionViewCell.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMSimilarMoviesCollectionViewCell.h"

@implementation KMSimilarMoviesCollectionViewCell

#pragma mark -
#pragma mark Cell Init Methods

+ (KMSimilarMoviesCollectionViewCell*) similarMoviesCollectionViewCell
{
    KMSimilarMoviesCollectionViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"KMSimilarMoviesCollectionViewCell" owner:self options:nil] objectAtIndex:0];
    return cell;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)awakeFromNib
{
    self.cellImageView.layer.cornerRadius = self.cellImageView.frame.size.width/2;
    self.cellImageView.layer.masksToBounds = YES;
    self.cellBackgroundView.layer.cornerRadius = self.cellBackgroundView.frame.size.width/2;
    self.cellBackgroundView.layer.masksToBounds = YES;
    self.cellBackgroundView.layer.borderColor =  [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
    self.cellBackgroundView.layer.borderWidth = 1.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
