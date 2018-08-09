//
//  GIGistsService.h
//  Gist
//
//  Created by Kent Wang on 8/8/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIGistsService : NSObject

- (void)fetchGistsWithCompletionHandler:(void (^)(NSArray *results))completionHandler;
- (void)fetchDataForURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *data))completionHandler;

@end
