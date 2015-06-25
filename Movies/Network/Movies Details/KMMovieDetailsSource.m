//
//  KMMovieDetailsSource.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMMovieDetailsSource.h"
#import "KMSourceConfig.h"
#import "AFNetworking.h"

#define kSimilarMoviesUrlFormat @"%@/movie/%@?api_key=%@"

@implementation KMMovieDetailsSource

#pragma mark -
#pragma mark Init Methods

+ (KMMovieDetailsSource*)movieDetailsSource;
{
    static dispatch_once_t onceToken;
    static KMMovieDetailsSource* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[KMMovieDetailsSource alloc]init];
    });
    return instance;
}

#pragma mark -
#pragma mark Request Methods

- (void)getMovieDetails:(NSString*)movieId completion:(KMMovieDetailsCompletionBlock)completionBlock;
{
    if (completionBlock)
    {        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [manager GET:[self prepareUrl:movieId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary* infosDictionary = [self dictionaryFromResponseData:operation.responseData jsonPatternFile:@"KMMovieDetailsSourceJsonPattern.json"];
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

- (KMMovie*)processResponseObject:(NSDictionary*)data
{
    if (data == nil)
        return nil;
    return [[KMMovie alloc] initWithDictionary:data];
}

#pragma mark -
#pragma mark Private

- (NSString*)prepareUrl:(NSString*)movieId
{
    return [NSString stringWithFormat:kSimilarMoviesUrlFormat, [KMSourceConfig config].theMovieDbHost, movieId, [KMSourceConfig config].apiKey];
}

@end
