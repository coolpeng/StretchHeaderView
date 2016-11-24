//
//  ViewController.m
//  StretchHeaderView
//
//  Created by Edward on 16/11/24.
//  Copyright © 2016年 coolpeng. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ORIGIN_IMAGE_HEIGHT 328/640.f*SCREEN_WIDTH


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView addSubview:self.headerImage];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取tableview的偏移量
    CGFloat offset_y = scrollView.contentOffset.y;
    CGFloat offset_x = (ORIGIN_IMAGE_HEIGHT + offset_y)*0.5; // 设置横向偏移量为纵向偏移量的一半
    
    if (offset_y <= -ORIGIN_IMAGE_HEIGHT) {// 起始偏移量为ORIGIN_IMAGE_HEIGHT，下拉时，偏移量offset_y会越来越小（因为是负数，绝对值会越来大）
        
        // 改变图片的frame
        //double fabs(double i);取double类型数据的绝对值

        CGRect rect = self.headerImage.frame;
        rect.origin.x = offset_x;
        rect.size.width = SCREEN_WIDTH+fabs(offset_x)*2;
        rect.origin.y = offset_y;
        rect.size.height = - offset_y;

        self.headerImage.frame = rect;
    }
}


#pragma tableview 协议事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld行",(long)indexPath.row];
    return cell;
}


#pragma mark  懒加载
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(ORIGIN_IMAGE_HEIGHT, 0, 0, 0);
    }
    return _tableView;
}

- (UIImageView *)headerImage {
    
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -ORIGIN_IMAGE_HEIGHT, SCREEN_WIDTH, ORIGIN_IMAGE_HEIGHT)];
        _headerImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"headerImage" ofType:@"jpg"]];
    }
    return _headerImage;
}


@end
