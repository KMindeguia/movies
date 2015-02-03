//
//  KMMovieDetailsSource.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMBaseSource.h"
#import "KMMovie.h"

typedef void (^KMMovieDetailsCompletionBlock)(KMMovie* movieDetails, NSString* errorString);

@interface KMMovieDetailsSource : KMBaseSource

+ (KMMovieDetailsSource*)movieDetailsSource;

- (void)getMovieDetails:(NSString*)movieId completion:(KMMovieDetailsCompletionBlock)completionBlock;

@end
