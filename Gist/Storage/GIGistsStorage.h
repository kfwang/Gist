//
//  GIGistsStorage.h
//  Gist
//
//  Created by Kent Wang on 8/9/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGist;

@interface GIGistsStorage : NSObject

- (void)saveGists:(NSArray *)gists;
- (NSArray *)getAllGists;
- (void)updateGist:(GIGist *)gist;

@end
