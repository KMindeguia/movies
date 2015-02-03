//
//  KIImagePager.m
//  KIImagePager
//
//  Created by Marcus Kida on 07.04.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#define kPageControlHeight  30
#define kOverlayWidth       50
#define kOverlayHeight      15

#import "KIImagePager.h"

@interface KIImagePager () <UIScrollViewDelegate>
{
    __weak id <KIImagePagerDataSource> _dataSource;
    __weak id <KIImagePagerDelegate> _delegate;
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UILabel *_countLabel;
    UILabel *_captionLabel;
    UIView *_indicatorBackground;
    NSTimer *_slideshowTimer;
    NSUInteger _slideshowTimeInterval;
    NSMutableDictionary *_activityIndicators;
    
    BOOL _indicatorDisabled;
}
@end

@implementation KIImagePager

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize contentMode = _contentMode;
@synthesize pageControl = _pageControl;
@synthesize indicatorDisabled = _indicatorDisabled;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) layoutSubviews
{
    [self initialize];
}

#pragma mark - General
- (void) initialize
{
    self.clipsToBounds = YES;
    self.slideshowShouldCallScrollToDelegate = YES;
    self.backgroundColor = [UIColor blackColor];
    self.captionBackgroundColor = [UIColor whiteColor];
    self.captionTextColor = [UIColor blackColor];
    self.captionFont = [UIFont fontWithName:@"Helvetica-Light" size:12.0f];
    
    [self initializeScrollView];
    [self initializePageControl];
    if(!_indicatorDisabled) {
        [self initalizeImageCounter];
    }
    [self initializeCaption];
    [self loadData];
    self.hidePageControlForSinglePages = YES;
}

- (UIColor *) randomColor
{
    return [UIColor colorWithHue:(arc4random() % 256 / 256.0)
                      saturation:(arc4random() % 128 / 256.0) + 0.5
                      brightness:(arc4random() % 128 / 256.0) + 0.5
                           alpha:1];
}

- (void) initalizeImageCounter
{
    _indicatorBackground = [[UIView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width-(kOverlayWidth-4),
                                                                    _scrollView.frame.size.height-kOverlayHeight,
                                                                    kOverlayWidth,
                                                                    kOverlayHeight)];
    _indicatorBackground.backgroundColor = [UIColor whiteColor];
    _indicatorBackground.alpha = 0.7f;
    _indicatorBackground.layer.cornerRadius = 5.0f;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [icon setImage:[UIImage imageNamed:@"KICamera"]];
    icon.center = CGPointMake(_indicatorBackground.frame.size.width-18, _indicatorBackground.frame.size.height/2);
    [_indicatorBackground addSubview:icon];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 24)];
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    [_countLabel setTextColor:[UIColor blackColor]];
    [_countLabel setFont:[UIFont systemFontOfSize:11.0f]];
    _countLabel.center = CGPointMake(15, _indicatorBackground.frame.size.height/2);
    [_indicatorBackground addSubview:_countLabel];
    
    [self addSubview:_indicatorBackground];
}

- (void) initializeCaption
{
    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _scrollView.frame.size.width - 10, 20)];
    [_captionLabel setBackgroundColor:self.captionBackgroundColor];
    [_captionLabel setTextColor:self.captionTextColor];
    [_captionLabel setFont:self.captionFont];
    
    _captionLabel.alpha = 0.7f;
    _captionLabel.layer.cornerRadius = 5.0f;
    
    [self addSubview:_captionLabel];
}

- (void) reloadData
{
    for (UIView *view in _scrollView.subviews)
        [view removeFromSuperview];
    
    [self loadData];
    [self checkWetherToToggleSlideshowTimer];
}

#pragma mark - ScrollView Initialization
- (void) initializeScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    [self addSubview:_scrollView];
}

- (void) loadData
{
    NSArray *aImageUrls = (NSArray *)[_dataSource arrayWithImages];
    _activityIndicators = [NSMutableDictionary new];
    
    [self updateCaptionLabelForImageAtIndex:0];
    
    if([aImageUrls count] > 0) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * [aImageUrls count],
                                               _scrollView.frame.size.height)];

        for (int i = 0; i < [aImageUrls count]; i++) {
            CGRect imageFrame = CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:imageFrame];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setContentMode:[_dataSource contentModeForImage:i]];
            [imageView setTag:i];
            if ([[aImageUrls objectAtIndex:i] isKindOfClass:[UIImage class]])
                [imageView setImage:[aImageUrls objectAtIndex:i]];
            else
                [imageView setImageURL:[aImageUrls objectAtIndex:i]];
            
            if([[aImageUrls objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                // Set ImageView's Image directly
                [imageView setImage:(UIImage *)[aImageUrls objectAtIndex:i]];
            }
            
            // Add GestureRecognizer to ImageView
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                  initWithTarget:self
                                                                  action:@selector(imageTapped:)];
            [singleTapGestureRecognizer setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:singleTapGestureRecognizer];
            [imageView setUserInteractionEnabled:YES];
            
            [_scrollView addSubview:imageView];
        }
        [_countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[_dataSource arrayWithImages] count]]];
        _pageControl.numberOfPages = [(NSArray *)[_dataSource arrayWithImages] count];
    } else {
        EGOImageView *blankImage = [[EGOImageView alloc] initWithFrame:_scrollView.frame];
        [_scrollView addSubview:blankImage];
    }
}

- (void) imageTapped:(UITapGestureRecognizer *)sender
{
    if([_delegate respondsToSelector:@selector(imagePager:didSelectImageAtIndex:)]) {
        [_delegate imagePager:self didSelectImageAtIndex:[(UIGestureRecognizer *)sender view].tag];
    }
}

- (void) setIndicatorDisabled:(BOOL)indicatorDisabled
{
    if(indicatorDisabled) {
        [_pageControl removeFromSuperview];
        [_indicatorBackground removeFromSuperview];
    } else {
        [self addSubview:_pageControl];
        [self addSubview:_indicatorBackground];
    }
    
    _indicatorDisabled = indicatorDisabled;
}

#pragma mark - PageControl Initialization
- (void) initializePageControl
{
    CGRect pageControlFrame = CGRectMake(0, 0, _scrollView.frame.size.width, kPageControlHeight);
    _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    _pageControl.center = CGPointMake(_scrollView.frame.size.width/2, _scrollView.frame.size.height - 12);
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

#pragma mark - ScrollView Delegate;
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = (uint32_t)lround((float)scrollView.contentOffset.x / scrollView.frame.size.width);
    _pageControl.currentPage = currentPage;
    
    [self updateCaptionLabelForImageAtIndex:currentPage];
    [self fireDidScrollToIndexDelegateForPage:currentPage];
}

#pragma mark - Delegate Helper
- (void) updateCaptionLabelForImageAtIndex:(NSUInteger)index
{
    if ([_dataSource respondsToSelector:@selector(captionForImageAtIndex:)]) {
        if ([[_dataSource captionForImageAtIndex:index] length] > 0) {
            [_captionLabel setHidden:NO];
            [_captionLabel setText:[NSString stringWithFormat:@" %@", [_dataSource captionForImageAtIndex:index]]];
            return;
        }
    }
    [_captionLabel setHidden:YES];
}

- (void) fireDidScrollToIndexDelegateForPage:(NSUInteger)page
{
    if([_delegate respondsToSelector:@selector(imagePager:didScrollToIndex:)]) {
        [_delegate imagePager:self didScrollToIndex:page];
    }
}

#pragma mark - Slideshow
- (void) slideshowTick:(NSTimer *)timer
{
    NSUInteger nextPage = 0;
    if([_pageControl currentPage] < ([[_dataSource arrayWithImages] count] - 1)) {
        nextPage = [_pageControl currentPage] + 1;
    }
    
    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * nextPage, 0, self.frame.size.width, self.frame.size.width) animated:YES];
    [_pageControl setCurrentPage:nextPage];
    
    [self updateCaptionLabelForImageAtIndex:nextPage];
    
    if (self.slideshowShouldCallScrollToDelegate) {
        [self fireDidScrollToIndexDelegateForPage:nextPage];
    }
}

- (void) checkWetherToToggleSlideshowTimer
{
    if (_slideshowTimeInterval > 0) {
        if ([(NSArray *)[_dataSource arrayWithImages] count] > 1) {
            _slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:_slideshowTimeInterval target:self selector:@selector(slideshowTick:) userInfo:nil repeats:YES];
        }
    }
}

#pragma mark - Setter / Getter
- (void) setSlideshowTimeInterval:(NSUInteger)slideshowTimeInterval
{
    _slideshowTimeInterval = slideshowTimeInterval;
    
    if([_slideshowTimer isValid]) {
        [_slideshowTimer invalidate];
    }
    [self checkWetherToToggleSlideshowTimer];
}

- (NSUInteger) slideshowTimeInterval
{
    return _slideshowTimeInterval;
}

- (void) setCaptionBackgroundColor:(UIColor *)captionBackgroundColor
{
    [_captionLabel setBackgroundColor:captionBackgroundColor];
    _captionBackgroundColor = captionBackgroundColor;
}

- (void) setCaptionTextColor:(UIColor *)captionTextColor
{
    [_captionLabel setTextColor:captionTextColor];
    _captionTextColor = captionTextColor;
}

- (void) setCaptionFont:(UIFont *)captionFont
{
    [_captionLabel setFont:captionFont];
    _captionFont = captionFont;
}

- (void) setHidePageControlForSinglePages:(BOOL)hidePageControlForSinglePages
{
    _hidePageControlForSinglePages = hidePageControlForSinglePages;
    if (hidePageControlForSinglePages) {
        if ([(NSArray *)[_dataSource arrayWithImages] count] < 2) {
            [_pageControl setHidden:YES];
            return;
        }
    }
    [_pageControl setHidden:NO];
}

- (NSUInteger) currentPage
{
    return [_pageControl currentPage];
}

- (void) setCurrentPage:(NSUInteger)currentPage
{
    [self setCurrentPage:currentPage animated:YES];
}

- (void) setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated
{
    NSAssert((currentPage < [(NSArray *)[_dataSource arrayWithImages] count]), @"currentPage must not exceed maximum number of images");
    
    [_pageControl setCurrentPage:currentPage];
    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * currentPage, 0, self.frame.size.width, self.frame.size.width) animated:animated];
}

@end
