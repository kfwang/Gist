//
//  GIGistTableViewCell.h
//  Gist
//
//  Created by Kent Wang on 8/8/18.
//  Copyright © 2018 Kent Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIGistTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end
