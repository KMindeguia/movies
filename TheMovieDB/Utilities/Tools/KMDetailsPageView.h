//
//  KMDetailsPageViewController.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class KMDetailsPageView;

///-------------------------------
/// @name  KMDetailsPageDelegate Protocol
///-------------------------------
@protocol KMDetailsPageDelegate <NSObject>

@required
- (UIImageView*)detailsPage:(KMDetailsPageView*)detailsPageView imageDataForImageView:(UIImageView*)imageView;
- (UIViewContentMode)contentModeForImage:(UIImageView*)imageView;
- (CGPoint)detailsPage:(KMDetailsPageView *)detailsPageView tableViewWillBeginDragging:(UITableView *)tableView;
@optional
- (void)headerImageViewFinishedLoading:(UIImageView*)imageView;
- (void)detailsPage:(KMDetailsPageView *)detailsPageView tableViewDidLoad:(UITableView *)tableView;
- (void)detailsPage:(KMDetailsPageView *)detailsPageView headerViewDidLoad:(UIView *)headerView;
- (void)detailsPage:(KMDetailsPageView *)detailsPageView imageViewWasSelected:(UIImageView *)imageView;

@end

///-------------------------------
/// @name KMDetailsPageView Interface
///-------------------------------

@interface KMDetailsPageView : UIView

/**
 Image header height value will set the height of the image pager header. Default value is 375.0f.
 */
@property (nonatomic) CGFloat imageHeaderViewHeight;
///-------------------------------

/**
 Image scaling factor will add a zoom scaling animation when pulling the content down. Default value is 300.0f. Increasing the value will dicrease the scaling animation rendering. Decreasing the value will increase the scaling animation rendering.
 */
@property (nonatomic) CGFloat imageScalingFactor;
///-------------------------------

/**
 Fading offset for nav bar view. setting this property will change the scrolling offset needed to show or hide the navbar. eg: If value is image header height, user will have to scroll to the top of the screen to make the nav bar appear. Default value is nav bar's height.
 */
@property (nonatomic) CGFloat navBarFadingOffset;
///-------------------------------

/**
 Header fading alpha value. Default is 1.0.
 */
@property (nonatomic) CGFloat headerImageAlpha;
///-------------------------------

/**
 Details TableView.
 */
@property (nonatomic, strong) UITableView *tableView;
///-------------------------------

/**
 TableView Separator Color.
 */
@property (nonatomic, strong) UIColor *tableViewSeparatorColor;
///-------------------------------

/**
 Details view background color. Default value is clear color.
 */
@property (nonatomic, strong) UIColor *backgroundViewColor;
///-------------------------------

/**
 Nav Bar view. This view appears when tableview scrolling offset reaches navBarFadingOffset property value. This property is optional.
 */
@property (nonatomic, strong) UIView *navBarView;
///-------------------------------

/**
 Details TableView UITableViewDataSource.
 */
@property (nonatomic, weak) id<UITableViewDataSource> tableViewDataSource;
///-------------------------------

/**
 Details TableView UITableViewDelegate.
 */
@property (nonatomic, weak) id<UITableViewDelegate> tableViewDelegate;
///-------------------------------

/**
 KMDetailsPageDelegate.
 */
@property (nonatomic, weak) id<KMDetailsPageDelegate> delegate;
///-------------------------------

///-------------------------------
/// @name KMDetailsPageView Public Methods
///-------------------------------

/*
 Call this method to reload data. This will refresh the tableview and the header imageview.
 */
- (void)reloadData;

/*
 Use this method if you need to hide the header imageview.
 */
- (void)hideHeaderImageView:(BOOL)hidden;

@end
