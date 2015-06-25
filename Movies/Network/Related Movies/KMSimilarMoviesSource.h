//
//  KMRelatedMoviesSource.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMBaseSource.h"

typedef void (^KMSimilarMoviesCompletionBlock)(NSArray* data, NSString* errorString);

@interface KMSimilarMoviesSource : KMBaseSource

+ (KMSimilarMoviesSource*)similarMoviesSource;

- (void)getSimilarMovies:(NSString*)movieId numberOfPages:(NSString*)numberOfPages completion:(KMSimilarMoviesCompletionBlock)completionBlock;

@end
