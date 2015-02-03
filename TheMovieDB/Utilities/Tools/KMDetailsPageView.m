//
//  KMDetailsPageViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMDetailsPageView.h"

@interface KMDetailsPageView ()

@end

@implementation KMDetailsPageView

#pragma mark -
#pragma mark Init Methods

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _defaultimagePagerHeight        = 195.0f;
    _parallaxScrollFactor           = 0.6f;
    _headerFade                     = _defaultimagePagerHeight;
    self.autoresizesSubviews        = YES;
    self.autoresizingMask           = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundViewColor        = [UIColor clearColor];
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark -
#pragma mark View layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (!self.tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self.tableViewDelegate;
        self.tableView.dataSource = self.tableViewDataSource;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        
        // Add scroll view KVO
        void *context = (__bridge void *)self;
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
        
        [self addSubview:self.tableView];
        
        if([self.delegate respondsToSelector:@selector(detailsPage:tableViewDidLoad:)])
        {
            [self.delegate detailsPage:self tableViewDidLoad:self.tableView];
        }
        
    }
    
    if (!self.tableView.tableHeaderView)
    {
        CGRect tableHeaderViewFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, self.defaultimagePagerHeight);
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:tableHeaderViewFrame];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = tableHeaderView;
        
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(catchHeaderGestureRight:)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight ;
        swipeGestureRight.cancelsTouchesInView = YES;
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(catchHeaderGestureLeft:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft ;
        swipeGestureLeft.cancelsTouchesInView = YES;
        
        [self.tableView.tableHeaderView  addGestureRecognizer:swipeGestureRight];
        [self.tableView.tableHeaderView  addGestureRecognizer:swipeGestureLeft];
    }
    
    if(!self.imagePager)
    {
        self.defaultimagePagerFrame = CGRectMake(0.0f, -50 * self.parallaxScrollFactor, self.tableView.frame.size.width, self.defaultimagePagerHeight * self.parallaxScrollFactor * 4);
        _imagePager = [[KIImagePager alloc] initWithFrame:self.defaultimagePagerFrame];
        self.imagePager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        self.imagePager.indicatorDisabled = YES;
        
        [self insertSubview:self.imagePager belowSubview:self.tableView];
        
        if([self.delegate respondsToSelector:@selector(detailsPage:imagePagerDidLoad:)])
        {
            [self.delegate detailsPage:self imagePagerDidLoad:self.imagePager];
        }
    }
    
    // Add the background tableView
    if (!self.backgroundView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.defaultimagePagerHeight,
                                                                self.tableView.frame.size.width,
                                                                self.tableView.frame.size.height - self.defaultimagePagerHeight)];
        view.backgroundColor = self.backgroundViewColor;
        self.backgroundView = view;
		self.backgroundView.userInteractionEnabled=NO;
        [self.tableView insertSubview:self.backgroundView atIndex:0];
    }
    
}

#pragma mark -
#pragma mark Gesture Recognizer Methods

-(void)catchHeaderGestureRight:(UISwipeGestureRecognizer*)sender
{
    //[self.imagePager setCurrentPage:2 animated:YES];
    
    NSLog(@"header gesture right");
    
    if(self.currentImage > 0)
    {
        self.currentImage --;
        [self.imagePager setCurrentPage:self.currentImage animated:YES];
    }
}

-(void)catchHeaderGestureLeft:(UISwipeGestureRecognizer*)sender
{
    //[self.imagePager setCurrentPage:2 animated:YES];
    
    NSLog(@"header gesture Left");
    
    if(self.currentImage < [[self.imagePager.dataSource arrayWithImages] count] -1)
    {
        self.currentImage ++;
        [self.imagePager setCurrentPage:self.currentImage animated:YES];
    }
}

#pragma mark -
#pragma mark Tableview Delegate and DataSource setters

- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource
{
    _tableViewDataSource = tableViewDataSource;
    self.tableView.dataSource = _tableViewDataSource;
    
    if (_tableViewDelegate)
    {
        [self.tableView reloadData];
    }
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
    _tableViewDelegate = tableViewDelegate;
    self.tableView.delegate = _tableViewDelegate;
    
    if (_tableViewDataSource)
    {
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark HeaderView Setter

- (void)setHeaderView:(UIView *)headerView
{
    _headerView = headerView;
    
    if([self.delegate respondsToSelector:@selector(detailsPage:headerViewDidLoad:)])
    {
        [self.delegate detailsPage:self headerViewDidLoad:self.headerView];
    }
}

#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	// Make sure we are observing this value.
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    
    if ((object == self.tableView) && ([keyPath isEqualToString:@"contentOffset"] == YES))
    {
        [self scrollViewDidScrollWithOffset:self.tableView.contentOffset.y];
        return;
    }
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    CGFloat junkViewFrameYAdjustment = 0.0;
    
    // If the user is pulling down
    if (scrollOffset < 0)
    {
        junkViewFrameYAdjustment = self.defaultimagePagerFrame.origin.y - (scrollOffset * self.parallaxScrollFactor);
    }
    
    // If the user is scrolling normally,
    else {
        junkViewFrameYAdjustment = self.defaultimagePagerFrame.origin.y - (scrollOffset * self.parallaxScrollFactor);
        
        // Don't move the map way off-screen
        if (junkViewFrameYAdjustment <= -(self.defaultimagePagerFrame.size.height))
        {
            junkViewFrameYAdjustment = -(self.defaultimagePagerFrame.size.height);
        }
        
    }
    
    //NSLog(@"scrollOffset: %f",scrollOffset);
    
    if(scrollOffset > _headerFade && _headerView.alpha == 0.0){ //make the header appear
        _headerView.alpha = 0;
        _headerView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _headerView.alpha = 1;
        }];
    }
    else if(scrollOffset < _headerFade && _headerView.alpha == 1.0){ //make the header disappear
        [UIView animateWithDuration:0.3 animations:^{
            _headerView.alpha = 0;
        } completion: ^(BOOL finished) {
            _headerView.hidden = YES;
        }];
    }
    
    if (junkViewFrameYAdjustment)
    {
        CGRect newJunkViewFrame = self.imagePager.frame;
        newJunkViewFrame.origin.y = junkViewFrameYAdjustment;
        self.imagePager.frame = newJunkViewFrame;
    }
}


@end
