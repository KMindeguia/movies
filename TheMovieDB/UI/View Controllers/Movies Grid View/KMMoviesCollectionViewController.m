//
//  KMMoviesCollectionViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 05/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMMoviesCollectionViewController.h"
#import "StoryBoardUtilities.h"
#import "KMMovie.h"
#import "KMMoviePosterCell.h"
#import "KMMovieDetailsViewController.h"

@interface KMMoviesCollectionViewController ()

@end

@implementation KMMoviesCollectionViewController

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

- (void)awakeFromNib
{
    if (!self.moviesDataSource)
        self.moviesDataSource = [[NSArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.moviesDataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    KMMoviePosterCell* cell = (KMMoviePosterCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"KMMoviePosterCell" forIndexPath:indexPath];
    [cell.moviePosterImageView setImageURL:[NSURL URLWithString:[[self.moviesDataSource objectAtIndex:indexPath.row] movieOriginalPosterImageUrl]]];
    return cell;
}

#pragma mark -
#pragma mark UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    KMMovieDetailsViewController* viewController = (KMMovieDetailsViewController*)[StoryBoardUtilities viewControllerForStoryboardName:@"KMMovieDetailsStoryboard" class:[KMMovieDetailsViewController class]];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.movieDetails = [self.moviesDataSource objectAtIndex:indexPath.row];
}

@end
