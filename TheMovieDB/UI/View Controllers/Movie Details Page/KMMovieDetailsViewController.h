//
//  KMMovieDetailsViewController.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDetailsPageView.h"
#import "KMMovie.h"
#import "KMNetworkLoadingViewController.h"

@interface KMMovieDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, KMNetworkLoadingViewDelegate, KMDetailsPageDelegate, KIImagePagerDelegate, KIImagePagerDataSource>

@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIView *detailsContainerView;
@property (weak, nonatomic) IBOutlet UIView *networkLoadingContainerView;

@property (strong, nonatomic) KMMovie* movieDetails;

- (IBAction)popViewController:(id)sender;

@end
