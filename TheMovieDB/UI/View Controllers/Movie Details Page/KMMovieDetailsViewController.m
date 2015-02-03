//
//  KMMovieDetailsViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMMovieDetailsViewController.h"
#import "StoryBoardUtilities.h"
#import "KMMovieDetailsCell.h"
#import "KMMovieDetailsDescriptionCell.h"
#import "KMMovieDetailsSimilarMoviesCell.h"
#import "KMSimilarMoviesCollectionViewCell.h"
#import "KMMovieDetailsPopularityCell.h"
#import "KMMovieDetailsCommentsCell.h"
#import "KMMovieDetailsViewAllCommentsCell.h"
#import "KMComposeCommentCell.h"
#import "KMMovieDetailsSource.h"
#import "KMSimilarMoviesSource.h"
#import "KMMoviesCollectionViewController.h"

@interface KMMovieDetailsViewController ()

@property (nonatomic, strong) NSMutableArray* similarMoviesDataSource;
@property (nonatomic, strong) KMDetailsPageView* detailsPageView;
@property (nonatomic, strong) KMNetworkLoadingViewController* networkLoadingViewController;

@end

@implementation KMMovieDetailsViewController

#pragma mark -
#pragma mark Init Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavbarButtons];
    [self requestMovieDetails];
    [self requestSimilarMovies];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Setup

- (void)setupDetailsPageView
{
    [super viewDidLoad];
    self.detailsPageView = [[KMDetailsPageView alloc] initWithFrame:self.detailsContainerView.bounds];
    self.detailsPageView.tableViewDataSource = self;
    self.detailsPageView.tableViewDelegate = self;
    self.detailsPageView.delegate = self;
    self.detailsPageView.parallaxScrollFactor = 0.4f;
    self.detailsPageView.defaultimagePagerHeight = 350;
    self.detailsPageView.headerFade = self.detailsPageView.defaultimagePagerHeight - self.navigationBarView.frame.size.height;
    [self.detailsContainerView addSubview:self.detailsPageView];
    self.detailsPageView.headerView = self.navigationBarView;
}

- (void)setupNavbarButtons
{
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 31, 22, 22);
    [buttonBack setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    UIButton *buttonLike = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLike.frame = CGRectMake(285, 31, 22, 22);
    [buttonLike setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateNormal];
    [buttonLike addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLike];
}

#pragma mark -
#pragma mark Container Segue Methods

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // -- Master View Controller
    if ([segue.identifier isEqualToString:[NSString stringWithFormat:@"%s", class_getName([KMNetworkLoadingViewController class])]])
    {
        self.networkLoadingViewController = segue.destinationViewController;
        self.networkLoadingViewController.delegate = self;
    }
}

#pragma mark -
#pragma mark Network Request Methods

- (void)requestSimilarMovies
{
    KMSimilarMoviesCompletionBlock completionBlock = ^(NSArray* data, NSString* errorString)
    {
        if (data != nil)
            [self processSimilarMoviesData:data];
        else
            [self.networkLoadingViewController showErrorView];
    };
    KMSimilarMoviesSource* source = [KMSimilarMoviesSource similarMoviesSource];
    [source getSimilarMovies:self.movieDetails.movieId numberOfPages:@"1" completion:completionBlock];
}

- (void)requestMovieDetails
{
    KMMovieDetailsCompletionBlock completionBlock = ^(KMMovie* movieDetails, NSString* errorString)
    {
        if (movieDetails != nil)
            [self processMovieDetailsData:movieDetails];
        else
            [self.networkLoadingViewController showErrorView];
    };
    KMMovieDetailsSource* source = [KMMovieDetailsSource movieDetailsSource];
    [source getMovieDetails:self.movieDetails.movieId completion:completionBlock];
}

#pragma mark -
#pragma mark Fetched Data Processing

- (void)processSimilarMoviesData:(NSArray*)data
{
    if ([data count] == 0)
        [self.networkLoadingViewController showNoContentView];
    else
    {
        if (!self.similarMoviesDataSource)
            self.similarMoviesDataSource = [[NSMutableArray alloc] init];
        self.similarMoviesDataSource = [NSMutableArray arrayWithArray:data];
        [self.detailsPageView.tableView reloadData];
    }
}

- (void)processMovieDetailsData:(KMMovie*)data
{
    self.movieDetails = data;
    [self setupDetailsPageView];
    [self hideLoadingView];
}

#pragma mark -
#pragma mark Action Methods

- (void)viewAllSimilarMoviesButtonPressed:(id)sender
{
    KMMoviesCollectionViewController* viewController = (KMMoviesCollectionViewController*)[StoryBoardUtilities viewControllerForStoryboardName:@"KMMoviesGridViewStoryboard" class:[KMMoviesCollectionViewController class]];
    viewController.moviesDataSource = self.similarMoviesDataSource;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            KMMovieDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCell"];
            
            if(detailsCell == nil){
                detailsCell = [KMMovieDetailsCell movieDetailsCell];
                [detailsCell.posterImageView setImageURL:[NSURL URLWithString:self.movieDetails.movieThumbnailBackdropImageUrl]];
                detailsCell.movieTitleLabel.text = self.movieDetails.movieTitle;
                detailsCell.genresLabel.text = self.movieDetails.movieGenresString;
            }
            cell = detailsCell;
        }
            break;
        case 1:
        {
            KMMovieDetailsDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsDescriptionCell"];
            
            if(descriptionCell == nil){
                descriptionCell = [KMMovieDetailsDescriptionCell movieDetailsDescriptionCell];
                descriptionCell.movieDescriptionLabel.text = self.movieDetails.movieSynopsis;
            }
            cell = descriptionCell;
        }
            break;
        case 2:
        {
            KMMovieDetailsSimilarMoviesCell *contributionCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsSimilarMoviesCell"];
            
            if(contributionCell == nil){
                contributionCell = [KMMovieDetailsSimilarMoviesCell movieDetailsSimilarMoviesCell];
                [contributionCell.viewAllSimilarMoviesButton addTarget:self action:@selector(viewAllSimilarMoviesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell = contributionCell;
        }
            break;
        case 3:
        {
            KMMovieDetailsPopularityCell *popularityCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsPopularityCell"];
            
            if(popularityCell == nil){
                popularityCell = [KMMovieDetailsPopularityCell movieDetailsPopularityCell];
                popularityCell.voteAverageLabel.text = self.movieDetails.movieVoteAverage;
                popularityCell.voteCountLabel.text = self.movieDetails.movieVoteCount;
                popularityCell.popularityLabel.text = self.movieDetails.moviePopularity;
            }
            cell = popularityCell;
        }
            break;
        case 4:
        {
            KMMovieDetailsCommentsCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCommentsCell"];
            
            if(commentsCell == nil){
                commentsCell = [KMMovieDetailsCommentsCell movieDetailsCommentsCell];
                commentsCell.usernameLabel.text = @"Kevin Mindeguia";
                commentsCell.commentLabel.text = @"Macaroon croissant I love tiramisu I love chocolate bar chocolate bar. Cheesecake dessert croissant sweet. Muffin gummies gummies biscuit bear claw. ";
                [commentsCell.cellImageView setImage:[UIImage imageNamed:@"kevin_avatar"]];
            }
            cell = commentsCell;
        }
            break;
        case 5:
        {
            KMMovieDetailsCommentsCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCommentsCell"];
            
            if(commentsCell == nil){
                commentsCell = [KMMovieDetailsCommentsCell movieDetailsCommentsCell];
                commentsCell.usernameLabel.text = @"Andrew Arran";
                commentsCell.commentLabel.text = @"Chocolate bar carrot cake candy canes oat cake dessert. Topping bear claw dragée. Sugar plum jelly cupcake.";
                [commentsCell.cellImageView setImage:[UIImage imageNamed:@"scrat_avatar"]];
            }
            cell = commentsCell;
        }
            break;
        case 6:
        {
            KMMovieDetailsViewAllCommentsCell *viewAllCommentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsViewAllCommentsCell"];
            
            if(viewAllCommentsCell == nil){
                viewAllCommentsCell = [KMMovieDetailsViewAllCommentsCell movieDetailsAllCommentsCell];
            }
            cell = viewAllCommentsCell;
        }
            break;
        case 7:
        {
            KMComposeCommentCell *composeCommentCell = [tableView dequeueReusableCellWithIdentifier:@"KMComposeCommentCell"];
            
            if(composeCommentCell == nil){
                composeCommentCell = [KMComposeCommentCell composeCommentsCell];
            }
            cell = composeCommentCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor clearColor];
    if ([cell isKindOfClass:[KMMovieDetailsSimilarMoviesCell class]])
    {
        KMMovieDetailsSimilarMoviesCell* similarMovieCell = (KMMovieDetailsSimilarMoviesCell*)cell;
        [similarMovieCell setCollectionViewDataSourceDelegate:self index:indexPath.row];
    }
    if ([cell isKindOfClass:[KMMovieDetailsCommentsCell class]])
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0)
        height = 120;
    else if (indexPath.row == 1)
        height = 119;
    else if (indexPath.row == 2)
    {
        if ([self.similarMoviesDataSource count] == 0)
            height = 0;
        else
            height = 143;
    }
    else if (indexPath.row == 3)
        height = 67;
    else if (indexPath.row >= 4 && indexPath.row < 6)
        height = 100;
    else if (indexPath.row == 6)
        height = 49;
    else if (indexPath.row == 7)
        height = 62;
    return height;
}

#pragma mark -
#pragma mark UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.similarMoviesDataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    KMSimilarMoviesCollectionViewCell* cell = (KMSimilarMoviesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"KMSimilarMoviesCollectionViewCell" forIndexPath:indexPath];
    [cell.cellImageView setImageURL:[NSURL URLWithString:[[self.similarMoviesDataSource objectAtIndex:indexPath.row] movieThumbnailPosterImageUrl]]];
    return cell;
}

#pragma mark -
#pragma mark UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    KMMovieDetailsViewController* viewController = (KMMovieDetailsViewController*)[StoryBoardUtilities viewControllerForStoryboardName:@"KMMovieDetailsStoryboard" class:[KMMovieDetailsViewController class]];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.movieDetails = [self.similarMoviesDataSource objectAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark KMDetailsPageDelegate

- (void)detailsPage:(KMDetailsPageView *)detailsPageView imagePagerDidLoad:(KIImagePager *)imagePager
{
    imagePager.dataSource = self;
    imagePager.delegate = self;
    imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    imagePager.slideshowTimeInterval = 0.0f;
    imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    self.detailsPageView.nbImages = [self.detailsPageView.imagePager.dataSource.arrayWithImages count];
    self.detailsPageView.currentImage = 0;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView tableViewDidLoad:(UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView headerViewDidLoad:(UIView *)headerView
{
    [headerView setAlpha:0.0];
    [headerView setHidden:YES];
}

#pragma mark -
#pragma mark KIImagePager DataSource

- (NSArray *) arrayWithImages
{
    return @[[NSURL URLWithString:self.movieDetails.movieOriginalPosterImageUrl]];
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFill;
}

#pragma mark -
#pragma mark KMNetworkLoadingViewController Methods

- (void)hideLoadingView
{
    [UIView transitionWithView:self.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
     {
         [self.networkLoadingContainerView removeFromSuperview];
     } completion:^(BOOL finished) {
         [self.networkLoadingViewController removeFromParentViewController];
         self.networkLoadingContainerView = nil;
     }];
}

#pragma mark -
#pragma mark KMNetworkLoadingViewDelegate

-(void)retryRequest;
{
    [self requestSimilarMovies];
    [self requestMovieDetails];
}

@end
