//
//  KMRelatedMoviesSource.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMSimilarMoviesSource.h"
#import "KMSourceConfig.h"
#import "AFNetworking.h"
#import "KMMovie.h"

#define kSimilarMoviesUrlFormat @"%@/movie/%@/similar?api_key=%@"

@implementation KMSimilarMoviesSource

#pragma mark -
#pragma mark Init Methods

+ (KMSimilarMoviesSource*)similarMoviesSource;
{
    static dispatch_once_t onceToken;
    static KMSimilarMoviesSource* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[KMSimilarMoviesSource alloc]init];
    });
    return instance;
}

#pragma mark -
#pragma mark Request Methods

- (void)getSimilarMovies:(NSString*)movieId numberOfPages:(NSString*)numberOfPages completion:(KMSimilarMoviesCompletionBlock)completionBlock;
{
    if (completionBlock)
    {
        NSDictionary* parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:numberOfPages, nil] forKeys:[NSArray arrayWithObjects:@"page", nil]];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [manager GET:[self prepareUrl:movieId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary* infosDictionary = [self dictionaryFromResponseData:operation.responseData jsonPatternFile:@"KMSimilarMoviesSourceJsonPattern.json"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 completionBlock([self processResponseObject:infosDictionary], nil);
             });
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 NSString* errorString = error.localizedDescription;
                 if ([errorString length] == 0)
                     errorString = nil;
                 completionBlock(nil, errorString);
             });
         }];
    }
}

#pragma mark -
#pragma mark Data Parsing

- (NSArray*)processResponseObject:(NSDictionary*)data
{
    if (data == nil)
        return nil;
    NSArray* itemsList = [NSArray arrayWithArray:[data objectForKey:@"results"]];
    NSMutableArray* sortedArray = [[NSMutableArray alloc] init];
    for (NSDictionary* item in itemsList)
    {
        KMMovie* movie = [[KMMovie alloc] initWithDictionary:item];
        [sortedArray addObject:movie];
    }
    return sortedArray;
}


#pragma mark -
#pragma mark Private

- (NSString*)prepareUrl:(NSString*)movieId
{
    return [NSString stringWithFormat:kSimilarMoviesUrlFormat, [KMSourceConfig config].theMovieDbHost, movieId, [KMSourceConfig config].apiKey];
}

@end
