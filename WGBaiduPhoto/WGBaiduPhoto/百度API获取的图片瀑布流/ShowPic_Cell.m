//
//  ShowPic_Cell.m
//  WGBaiduPhoto
//
//  Created by wanggang on 16/8/17.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import "ShowPic_Cell.h"
#import "UIImageView+WebCache.h"

@implementation ShowPic_Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(PicModel *)model
{
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/img%@",model.img]] placeholderImage:[UIImage imageNamed:@"waite.jpg"]];
    _titleLabel.text = model.title;
}

@end
