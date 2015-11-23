//
//  ThemesCell.h
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThemesOfDaily;

@interface ThemesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) ThemesOfDaily *model;

@end
