//
// NSString+MD5.h
// Originally created for MyFile
//
// Created by Árpád Goretity, 2011. Some infos were grabbed from StackOverflow.
// Released into the public domain. You can do whatever you want with this within the limits of applicable law (so nothing nasty!).
// I'm not responsible for any damage related to the use of this software. There's NO WARRANTY AT ALL.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

// MD5 hash of the file on the filesystem specified by path
+ (NSString *) stringWithMD5OfFile: (NSString *) path;
// The string's MD5 hash
- (NSString *) MD5Hash;

@end

