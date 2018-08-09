//
//  GIGistsStorage.m
//  Gist
//
//  Created by Kent Wang on 8/9/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIGistsStorage.h"
#import "GIGist.h"
#import "Gist+CoreDataModel.h"
#import "AppDelegate.h"

@interface GIGistsStorage ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *entityName;

@end

@implementation GIGistsStorage

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appDelegate = (AppDelegate *)(UIApplication.sharedApplication.delegate);
        self.entityName = NSStringFromClass([Gist class]);
    }
    return self;
}

- (void)saveGists:(NSArray *)gists {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *error = nil;
    [self.appDelegate.persistentContainer.persistentStoreCoordinator executeRequest:batchDeleteRequest withContext:self.appDelegate.persistentContainer.viewContext error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    for (GIGist *gist in gists) {
        Gist *gistManagedObject = [[Gist alloc] initWithEntity:[self entityDescription:self.appDelegate.persistentContainer.viewContext] insertIntoManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
        gistManagedObject.gistID = gist.gistID;
        gistManagedObject.loginName = gist.loginName;
        gistManagedObject.fileName = gist.fileName;
        gistManagedObject.descriptionString = gist.descriptionString;
        gistManagedObject.comments = gist.comments.integerValue;
        gistManagedObject.avatarURLString = gist.avatarURLString;
        gistManagedObject.avatarData = gist.avatarData;
        gistManagedObject.createdAt = gist.createdAt;
        gistManagedObject.fileTextURL = gist.fileTextURL;
        gistManagedObject.fileText = gist.fileText;
    }
    [self saveDatabase];
}

- (NSArray *)getAllGists {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:false];
    [request setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    NSArray *results = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    } else {
        NSMutableArray *gistResults = [NSMutableArray array];
        for (Gist *gistManagedObject in results) {
            GIGist *gist = [[GIGist alloc] initWithID:gistManagedObject.gistID loginName:gistManagedObject.loginName avatarURLString:gistManagedObject.avatarURLString avatarData:gistManagedObject.avatarData fileName:gistManagedObject.fileName description:gistManagedObject.descriptionString createdAt:gistManagedObject.createdAt comments:@(gistManagedObject.comments) fileTextURL:gistManagedObject.fileTextURL fileText:gistManagedObject.fileText];
            [gistResults addObject:gist];
        }
        return gistResults;
    }
}

- (void)updateGist:(GIGist *)gist {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gistID == %@", gist.gistID];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *results = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        if (results && results.count > 0) {
            Gist *gistManagedObject = [results objectAtIndex:0];
            gistManagedObject.gistID = gist.gistID;
            gistManagedObject.loginName = gist.loginName;
            gistManagedObject.fileName = gist.fileName;
            gistManagedObject.descriptionString = gist.descriptionString;
            gistManagedObject.comments = gist.comments.integerValue;
            gistManagedObject.avatarURLString = gist.avatarURLString;
            gistManagedObject.avatarData = gist.avatarData;
            gistManagedObject.createdAt = gist.createdAt;
            gistManagedObject.fileTextURL = gist.fileTextURL;
            gistManagedObject.fileText = gist.fileText;
            [self saveDatabase];
        }
    }
}

- (NSEntityDescription *)entityDescription:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:self.entityName inManagedObjectContext:context];
}

- (void)saveDatabase {
    if (self.appDelegate.persistentContainer.viewContext.hasChanges) {
        [self.appDelegate saveContext];
    }
}

@end
