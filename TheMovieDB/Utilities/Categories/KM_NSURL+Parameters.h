//
//  KM_NSURL+Parameters.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 26/06/2013.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSURL (KM_NSURL_Parameters)

+ (NSURL*)URLWithString:(NSString*)urlString additionalParameters:(NSString*)additionalParameters;

@end
