//
//  NewsOfDayCell.h
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsOfDay.h"
@interface NewsOfDayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab4title;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@property (nonatomic, strong)NewsOfDay * newsOfDay;

@end
