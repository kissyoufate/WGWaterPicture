//
//  PicSuburb_Controller.m
//  WGBaiduPhoto
//
//  Created by wanggang on 16/8/17.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import "PicSuburb_Controller.h"
#import "AFNetworking.h"
#import "ListModel.h"
#import "PicCollection_Controller.h"

@interface PicSuburb_Controller () <UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *searchKeyWords;
    int page;
    NSMutableArray *dataArray;
}

@end

@implementation PicSuburb_Controller

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setBasicUI];

    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData
{
    NSString *url = @"http://www.tngou.net/tnfs/api/classify";
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject[@"status"] boolValue]) {
//
//            dataArray = [NSMutableArray array];
//
//            for (id obj in responseObject[@"tngou"]) {
//                ListModel *model = [ListModel new];
//                [model setValuesForKeysWithDictionary:obj];
//                [dataArray addObject:model];
//            }
//
//            [self createTB];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] boolValue]) {
            
            dataArray = [NSMutableArray array];
            
            for (id obj in responseObject[@"tngou"]) {
                ListModel *model = [ListModel new];
                [model setValuesForKeysWithDictionary:obj];
                [dataArray addObject:model];
            }
            
            [self createTB];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

- (void)createTB
{
    UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    tb.delegate = self;
    tb.dataSource = self;
    [self.view addSubview:tb];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = [dataArray[indexPath.row] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PicCollection_Controller *pVC = [[PicCollection_Controller alloc] init];
    pVC.title = [dataArray[indexPath.row] name];
    pVC.picID = [dataArray[indexPath.row] id];
    [self.navigationController pushViewController:pVC animated:YES];
}

#pragma mark - 基础界面UI
- (void)setBasicUI
{
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.title = @"列表😆";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:100/255.0f green:200/255.0f blue:250/255.0f alpha:1.0f];

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchMyLike)];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)searchMyLike
{
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"请输入" message:@"输入搜索关键词" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"搜索", nil];
    a.alertViewStyle = UIAlertViewStylePlainTextInput;
    [a show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        searchKeyWords = [alertView textFieldAtIndex:0].text;
        NSLog(@"%@",searchKeyWords);
    }
}

@end
