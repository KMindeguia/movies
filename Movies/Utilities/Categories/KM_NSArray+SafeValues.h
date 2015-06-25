//
//  KM_NSArray+SafeValues.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSArray (KM_NSArray_SafeValues)

- (NSString*)km_safeStringAtIndex:(NSUInteger)index;
- (NSNumber*)km_safeNumberAtIndex:(NSUInteger)index;
- (NSDictionary*)km_safeDictionaryAtIndex:(NSUInteger)index;

@end
