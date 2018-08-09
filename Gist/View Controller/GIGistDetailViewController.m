//
//  GIGistDetailViewController.m
//  Gist
//
//  Created by Kent Wang on 8/9/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import "GIGistDetailViewController.h"
#import "GIGist.h"
#import "GIGistsService.h"
#import "GIGistsStorage.h"

@interface GIGistDetailViewController ()

@end

@implementation GIGistDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.text = @"No data loaded";
    self.textView.textColor = UIColor.lightGrayColor;
    self.textView.textAlignment = NSTextAlignmentCenter;
    
    if (self.gist.fileText) {
        self.textView.text = self.gist.fileText;
        self.textView.textColor = UIColor.blackColor;
        self.textView.textAlignment = NSTextAlignmentNatural;
    } else {
        NSURL *url = [NSURL URLWithString:self.gist.fileTextURL];
        GIGistsService *service = [[GIGistsService alloc] init];
        [service fetchDataForURL:url withCompletionHandler:^(NSData *data) {
            if (data) {
                self.gist.fileText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                GIGistsStorage *storage = [[GIGistsStorage alloc] init];
                [storage updateGist:self.gist];
                self.textView.text = self.gist.fileText;
                self.textView.textColor = UIColor.blackColor;
                self.textView.textAlignment = NSTextAlignmentNatural;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
