//
//  GIGistsService.m
//  Gist
//
//  Created by Kent Wang on 8/8/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import "GIGistsService.h"
#import "GIGist.h"

@interface GIGistsService ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation GIGistsService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        self.dataTask = nil;
    }
    return self;
}

- (void)fetchGistsWithCompletionHandler:(void (^)(NSArray *results))completionHandler {
    [self.dataTask cancel];
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/gists/public"];
    self.dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil);
            });
        } else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse*)response).statusCode == 200) {
                NSArray *results = [self createModelDataWith:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(results);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil);
                });
            }
        }
    }];
    [self.dataTask resume];
}

- (void)fetchDataForURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *data))completionHandler {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil);
            });
        } else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse*)response).statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(data);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil);
                });
            }
        }
    }];
    [dataTask resume];
}

- (NSArray *)createModelDataWith:(NSData*)data {
    NSMutableArray *results = [NSMutableArray array];
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    for (NSDictionary *jsonDictionary in jsonArray) {
        NSString *gistID = [jsonDictionary objectForKey:@"id"];
        NSDictionary *owner = [jsonDictionary objectForKey:@"owner"];
        NSString *login = [owner objectForKey:@"login"];
        NSString *avatarURLString = [owner objectForKey:@"avatar_url"];
        NSString *fileName = @"";
        NSString *fileTextURL = @"";
        NSDictionary *files = [jsonDictionary objectForKey:@"files"];
        NSArray * filesArray = [files allValues];
        if (filesArray.count > 0) {
            NSDictionary *file = [filesArray objectAtIndex:0];
            fileName = [file objectForKey:@"filename"];
            fileTextURL = [file objectForKey:@"raw_url"];
        }
        NSString *description = [jsonDictionary objectForKey:@"description"];
        if ([description isEqual:[NSNull null]]) { description = @""; }
        NSString *createdAt = [jsonDictionary objectForKey:@"created_at"];
        createdAt = [createdAt stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
        NSDate *date = [dateFormatter dateFromString: createdAt];
        
        NSNumber *comments = [jsonDictionary objectForKey:@"comments"];
        
        GIGist *gist = [[GIGist alloc] initWithID: gistID loginName:login avatarURLString:avatarURLString avatarData:nil fileName:fileName description:description createdAt:date comments:comments fileTextURL:fileTextURL fileText:nil];
        [results addObject:gist];
        NSLog(@"%@ %@", login, date.description);
    }
    return results;
}

@end
