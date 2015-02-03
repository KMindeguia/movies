//
//  NSBundle+Loader.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 24/06/2013.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Loader)

- (id)dataFromResource:(NSString *)resource;
- (id)jsonFromResource:(NSString *)resource;

@end
