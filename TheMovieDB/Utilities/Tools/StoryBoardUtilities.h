//
//  StoryBoardUtilities.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 09/02/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface StoryBoardUtilities : NSObject

+ (UIViewController*)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)class;

@end
