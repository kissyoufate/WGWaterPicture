//
//  ShowPic_Cell.h
//  WGBaiduPhoto
//
//  Created by wanggang on 16/8/17.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicModel.h"

@interface ShowPic_Cell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong)PicModel *model;

@end
