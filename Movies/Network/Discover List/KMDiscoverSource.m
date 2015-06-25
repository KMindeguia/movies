//
//  KMDiscoverMapSource.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMDiscoverSource.h"
#import "KMSourceConfig.h"
#import "AFNetworking.h"
#import "KMMovie.h"

#define kDiscoverUrlFormat @"%@/discover/movie?api_key=%@&sort_by=popularity.desc"

@implementation KMDiscoverSource

#pragma mark -
#pragma mark Init Methods

+ (KMDiscoverSource*)discoverSource;
{
    static dispatch_once_t onceToken;
    static KMDiscoverSource* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[KMDiscoverSource alloc]init];
    });
    return instance;
}

#pragma mark -
#pragma mark Request Methods

- (void)getDiscoverList:(NSString*)pageLimit completion:(KMDiscoverListCompletionBlock)completionBlock;
{
    if (completionBlock)
    {
        NSDictionary* parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:pageLimit, nil] forKeys:[NSArray arrayWithObjects:@"page", nil]];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [manager GET:[self prepareUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary* infosDictionary = [self dictionaryFromResponseData:operation.responseData jsonPatternFile:@"KMDiscoverSourceJsonPattern.json"];
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

- (NSString*)prepareUrl
{
    return [NSString stringWithFormat:kDiscoverUrlFormat, [KMSourceConfig config].theMovieDbHost, [KMSourceConfig config].apiKey];
}

@end
