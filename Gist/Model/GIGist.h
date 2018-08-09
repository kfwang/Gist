//
//  Gist.h
//  Gist
//
//  Created by Kent Wang on 8/8/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIGist : NSObject

@property (nonatomic, strong) NSString *gistID;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *avatarURLString;
@property (nonatomic, strong) NSData *avatarData;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSNumber *comments;
@property (nonatomic, strong) NSString *fileTextURL;
@property (nonatomic, strong) NSString *fileText;

- (instancetype)initWithID: (NSString *)gistID loginName:(NSString *)loginName avatarURLString:(NSString *)avatarURLString avatarData:(NSData*)avatarData fileName:(NSString *)fileName description:(NSString *)description createdAt:(NSDate *)createdAt comments:(NSNumber *)comments fileTextURL:(NSString *)fileTextURL fileText:(NSString *)fileText;

@end
