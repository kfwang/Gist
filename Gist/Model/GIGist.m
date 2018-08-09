//
//  Gist.m
//  Gist
//
//  Created by Kent Wang on 8/8/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import "GIGist.h"

@implementation GIGist

- (instancetype)initWithID: (NSString *)gistID loginName:(NSString *)loginName avatarURLString:(NSString *)avatarURLString avatarData:(NSData*)avatarData fileName:(NSString *)fileName description:(NSString *)description createdAt:(NSDate *)createdAt comments:(NSNumber *)comments fileTextURL:(NSString *)fileTextURL fileText:(NSString *)fileText {
    self = [self init];
    if (self) {
        self.gistID = gistID;
        self.loginName = loginName;
        self.avatarURLString = avatarURLString;
        self.avatarData = avatarData;
        self.fileName = fileName;
        self.descriptionString = description;
        self.createdAt = createdAt;
        self.comments = comments;
        self.fileTextURL = fileTextURL;
        self.fileText = fileText;
    }
    return self;
}

@end
