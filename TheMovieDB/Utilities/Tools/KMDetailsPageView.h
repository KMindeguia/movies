//
//  KMDetailsPageViewController.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@class KMDetailsPageView;

@protocol KMDetailsPageDelegate <NSObject>

@optional
    - (void)detailsPage:(KMDetailsPageView *)detailsPageView imagePagerDidLoad:(KIImagePager *)imagePager;
    - (void)detailsPage:(KMDetailsPageView *)detailsPageView tableViewDidLoad:(UITableView *)tableView;
    - (void)detailsPage:(KMDetailsPageView *)detailsPageView headerViewDidLoad:(UIView *)headerView;

@end

@interface KMDetailsPageView : UIView

@property (nonatomic) CGFloat defaultimagePagerHeight;
@property (nonatomic) CGFloat parallaxScrollFactor;
@property (nonatomic) CGFloat headerFade;
@property (nonatomic) CGRect defaultimagePagerFrame;

@property (nonatomic, strong) KIImagePager *imagePager;
@property (nonatomic) NSUInteger nbImages;
@property (nonatomic) int currentImage;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIColor *backgroundViewColor;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, weak) id<UITableViewDataSource> tableViewDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, weak) id<KMDetailsPageDelegate> delegate;

@end
