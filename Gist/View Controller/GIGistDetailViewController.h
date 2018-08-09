//
//  GIGistDetailViewController.h
//  Gist
//
//  Created by Kent Wang on 8/9/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIGist;

@interface GIGistDetailViewController : UIViewController

@property (nonatomic, strong) GIGist *gist;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
