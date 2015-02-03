//
//  KMBaseSource.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMBaseSource : NSObject

@property (nonatomic, strong) NSOperationQueue* operationQueue;

- (NSDictionary*)dictionaryFromResponseData:(NSData*)responseData jsonPatternFile:(NSString*)jsonFile;

@end
