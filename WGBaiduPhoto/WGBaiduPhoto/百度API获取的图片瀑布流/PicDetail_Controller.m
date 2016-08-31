//
//  PicDetail_Controller.m
//  WGBaiduPhoto
//
//  Created by wanggang on 16/8/17.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import "PicDetail_Controller.h"
#import "AFNetworking.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@interface PicDetail_Controller () <UIScrollViewDelegate>
{
    UILabel *noticeLabel;
    NSMutableArray *picArray;
    UIScrollView *scoll;
    BOOL isShowTheNotice;
}

@end

@implementation PicDetail_Controller

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    isShowTheNotice = NO;

    [self loadData];
}

- (void)setUI
{

    if (isShowTheNotice)
    {
        //
    }else
    {
        noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.font = [UIFont systemFontOfSize:14.0f];
        noticeLabel.backgroundColor = [UIColor yellowColor];
        noticeLabel.textColor = [UIColor redColor];
        noticeLabel.text = @"滑到左右尽头退出大图模式😀!";
        noticeLabel.alpha = 0.75f;
        [self.view addSubview:noticeLabel];

        [UIView animateWithDuration:3.0f animations:^{
            noticeLabel.frame = CGRectMake(0, -20, self.view.frame.size.width, 20);
        }completion:^(BOOL finished) {
            [noticeLabel removeFromSuperview];

            isShowTheNotice = YES;
        }];
    }
}

- (void)loadData
{
    NSString *url = @"http://www.tngou.net/tnfs/api/show";
    NSDictionary *dic = @{
                          @"id":_theID
                          };
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject[@"status"] boolValue]) {
//            [self showPic:responseObject];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] boolValue]) {
            [self showPic:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

- (void)showPic:(NSDictionary *)dataDic
{

    picArray = [NSMutableArray array];

    for (id obj in dataDic[@"list"]) {
        [picArray addObject:obj[@"src"]];
    }

    scoll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scoll.backgroundColor = [UIColor blackColor];
    scoll.contentSize = CGSizeMake(picArray.count * self.view.frame.size.width, 0);
    scoll.pagingEnabled = YES;
    scoll.delegate = self;

    for (int i = 0; i < picArray.count; i ++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/img%@",picArray[i]]] placeholderImage:[UIImage imageNamed:@"ic_default_picture"]];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.tag = 100 + i;
        [scoll addSubview:iv];
    }

    [self.view addSubview:scoll];

    [self setUI];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f  %f",scrollView.contentOffset.x,picArray.count * self.view.frame.size.width + 50);
    if (scrollView.contentOffset.x < -50)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (scrollView.contentOffset.x > (picArray.count - 1) * self.view.frame.size.width + 50)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
