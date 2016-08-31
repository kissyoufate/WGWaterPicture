//
//  PicCollection_Controller.m
//  WGBaiduPhoto
//
//  Created by wanggang on 16/8/17.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import "PicCollection_Controller.h"
#import "AFNetworking.h"
#import "PicModel.h"
#import "ShowPic_Cell.h"
#import "HMWaterflowLayout.h"
#import "MJRefresh.h"
#import "PicDetail_Controller.h"

@interface PicCollection_Controller () <UICollectionViewDataSource,UICollectionViewDelegate,HMWaterflowLayoutDelegate>
{
    int page;
    NSMutableArray *dataArray;
    UICollectionView *collect;
    NSMutableArray *heightArray;
}

@end

@implementation PicCollection_Controller

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;

    page = 1;

    [self loadData];
}

- (void)loadData
{
    NSString *url = @"http://www.tngou.net/tnfs/api/list";
    NSDictionary *dic = @{
                          @"page":@(page),
                          @"rows":@(20),
                          @"id":_picID
                          };
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject[@"status"] boolValue]) {
//
//            if (!dataArray) {
//                dataArray = [NSMutableArray array];
//                heightArray = [NSMutableArray array];
//            }else
//            {
//                if (page == 1) {
//                    [dataArray removeAllObjects];
//                    [heightArray removeAllObjects];
//                }
//            }
//
//            for (id obj in responseObject[@"tngou"]) {
//                PicModel *model = [PicModel new];
//                [model setValuesForKeysWithDictionary:obj];
//                [dataArray addObject:model];
//
//                NSNumber *num = [NSNumber numberWithInt:arc4random_uniform(2)==0?250:300];
//                [heightArray addObject:num];
//            }
//
//            if (collect) {
//                [collect reloadData];
//            }else
//                [self createCollection];
//
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] boolValue]) {
            
            if (!dataArray) {
                dataArray = [NSMutableArray array];
                heightArray = [NSMutableArray array];
            }else
            {
                if (page == 1) {
                    [dataArray removeAllObjects];
                    [heightArray removeAllObjects];
                }
            }
            
            for (id obj in responseObject[@"tngou"]) {
                PicModel *model = [PicModel new];
                [model setValuesForKeysWithDictionary:obj];
                [dataArray addObject:model];
                
                NSNumber *num = [NSNumber numberWithInt:arc4random_uniform(2)==0?250:300];
                [heightArray addObject:num];
            }
            
            if (collect) {
                [collect reloadData];
            }else
                [self createCollection];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

- (void)createCollection
{
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
    layout.columnMargin = 5;
    layout.rowMargin = 5;
    layout.columnsCount = 2;
    layout.delegate = self;

    collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:layout];
    collect.delegate = self;
    collect.dataSource = self;
    collect.showsHorizontalScrollIndicator = NO;
    collect.showsVerticalScrollIndicator = NO;
    collect.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collect];

    [collect registerNib:[UINib nibWithNibName:@"ShowPic_Cell" bundle:nil] forCellWithReuseIdentifier:@"ShowPic_Cell"];

    collect.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self loadData];
    }];

    collect.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self loadData];
    }];
}

- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    return [heightArray[indexPath.row] floatValue];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPic_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShowPic_Cell" forIndexPath:indexPath];
    cell.model = dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicDetail_Controller *pVC = [[PicDetail_Controller alloc] init];
    pVC.theID = [dataArray[indexPath.row] id];
    [self presentViewController:pVC animated:YES completion:nil];
}

@end
