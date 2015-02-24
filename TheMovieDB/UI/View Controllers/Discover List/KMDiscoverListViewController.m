//
//  KMDiscoverListViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMDiscoverListViewController.h"
#import "StoryBoardUtilities.h"
#import "KMDiscoverListCell.h"
#import "KMDiscoverSource.h"
#import "KMMovie.h"
#import "KMMovieDetailsViewController.h"

@interface KMDiscoverListViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) KMNetworkLoadingViewController* networkLoadingViewController;

@end

@implementation KMDiscoverListViewController

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
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self requestMovies];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setup Methods

- (void)setupTableView
{
    if (!_refreshControl)
    {
        _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
        [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:_refreshControl];
    }
}

#pragma mark -
#pragma mark Container Segue Methods

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[NSString stringWithFormat:@"%s", class_getName([KMNetworkLoadingViewController class])]])
    {
        self.networkLoadingViewController = segue.destinationViewController;
        self.networkLoadingViewController.delegate = self;
    }
}

#pragma mark -
#pragma mark Network Requests methods

- (void)refreshFeed
{
    [self requestMovies];
}

- (void)requestMovies
{
    KMDiscoverListCompletionBlock completionBlock = ^(NSArray* data, NSString* errorString)
    {
        [self.refreshControl endRefreshing];
        if (data != nil)
            [self processData:data];
        else
            [self.networkLoadingViewController showErrorView];
    };
    KMDiscoverSource* source = [KMDiscoverSource discoverSource];
    [source getDiscoverList:@"1" completion:completionBlock];
}

#pragma mark -
#pragma mark Fetched Data Processing

- (void)processData:(NSArray*)data
{
    if ([data count] == 0)
        [self.networkLoadingViewController showNoContentView];
    else
    {
        [self hideLoadingView];
        if (!self.dataSource)
            self.dataSource = [[NSMutableArray alloc] init];
        self.dataSource = [NSMutableArray arrayWithArray:data];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark KMNetworkLoadingViewDelegate

-(void)retryRequest;
{
    [self requestMovies];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.dataSource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    KMDiscoverListCell* cell = (KMDiscoverListCell*)[tableView dequeueReusableCellWithIdentifier:@"DiscoverListCell" forIndexPath:indexPath];
    [cell.timelineImageView setImageURL:[NSURL URLWithString:[[self.dataSource objectAtIndex:indexPath.row] movieOriginalBackdropImageUrl]]];
    [cell.titleLabel setText:[[self.dataSource objectAtIndex:indexPath.row] movieTitle]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    KMMovieDetailsViewController* viewController = (KMMovieDetailsViewController*)[StoryBoardUtilities viewControllerForStoryboardName:@"KMMovieDetailsStoryboard" class:[KMMovieDetailsViewController class]];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.movieDetails = [self.dataSource objectAtIndex:indexPath.row];
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

@end
