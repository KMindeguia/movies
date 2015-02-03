//
//  km_NSDictionary+SafeValues.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//


#import "KM_NSDictionary+SafeValues.h"

@implementation NSDictionary (KM_NSDictionary_SafeValues)

- (NSString*)km_safeStringForKey:(id)key {
    NSString* string = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]){
        string = obj;
    }
    else {
        string = @"";
    }
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSNumber*)km_safeNumberForKey:(id)key {
    NSNumber* number = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]){
        number = obj;
    }
    else {
        number = [NSNumber numberWithInt:0];
    }
    return number;
}

- (NSArray*)km_safeArrayForKey:(id)key {
    NSArray* array = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSArray class]]){
        array = obj;
    }
    else {
        array = [NSArray array];
    }
    return array;
}

- (NSDictionary*)km_safeDictionaryForKey:(id)key {
    NSDictionary* dictionary = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dictionary = obj;
    }
    else {
        dictionary = [NSDictionary dictionary];
    }
    return dictionary;
}

- (UIImage*)km_safeImageForKey:(id)key;
{
    UIImage* image = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[UIImage class]]) {
        image = obj;
    }
    else {
        image = nil;
    }
    return image;
}

@end
