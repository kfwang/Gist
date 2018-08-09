//
//  GistsTableViewController.m
//  Gist
//
//  Created by Kent Wang on 8/8/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import "GIGistsTableViewController.h"
#import "GIGistsService.h"
#import "GIGistsStorage.h"
#import "GIGistTableViewCell.h"
#import "GIGist.h"
#import "GIGistDetailViewController.h"

@interface GIGistsTableViewController ()

@property (nonatomic, strong) NSArray *gists;
@property (nonatomic, strong) GIGistsService *service;
@property (nonatomic, strong) GIGistsStorage *storage;

@end

@implementation GIGistsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gists = nil;
    self.service = [[GIGistsService alloc] init];
    self.storage = [[GIGistsStorage alloc] init];
    [self fetchGists:nil];
    [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(fetchGists:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchGists:(NSTimer *)timer {
    [self.service fetchGistsWithCompletionHandler:^(NSArray *results) {
        if (results) {
            self.gists = results;
            [self.storage saveGists:results];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.gists) {
        self.gists = [self.storage getAllGists];
    }
    return self.gists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GIGist *gist = [self.gists objectAtIndex:indexPath.row];
    GIGistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GistTableViewCell" forIndexPath:indexPath];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ / %@", gist.loginName, gist.fileName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    cell.createdAtLabel.text = [dateFormatter stringFromDate:gist.createdAt];
    
    cell.descriptionLabel.text = gist.descriptionString;
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@ comments", gist.comments];
    
    if (gist.avatarData) {
        cell.avatarImageView.image = [UIImage imageWithData:gist.avatarData];
    } else {
        cell.avatarImageView.image = nil;
        NSURL *avatarURL = [NSURL URLWithString:gist.avatarURLString];
        [self.service fetchDataForURL:avatarURL withCompletionHandler:^(NSData *data) {
            if (data) {
                gist.avatarData = data;
                [self.storage updateGist:gist];
                cell.avatarImageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"gistDetail" sender:indexPath];
}

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self.service fetchGistsWithCompletionHandler:^(NSArray *results) {
        if (results) {
            self.gists = results;
            [self.storage saveGists:results];
            [self.tableView reloadData];
        }
        [sender endRefreshing];
    }];
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     GIGist *gist = [self.gists objectAtIndex:((NSIndexPath*)sender).row];
     ((GIGistDetailViewController*)(segue.destinationViewController)).gist = gist;
 }

@end
