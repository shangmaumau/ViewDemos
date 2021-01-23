//
//  MeInfoEditController.m
//  ViewDemos
//
//  Created by sam chojine on 2021/1/23.
//

#import "MeInfoEditController.h"
#import "MeInfoEditCell.h"
#import "MeUserEditModel.h"

#import <Masonry/Masonry.h>
#import "MJExtension.h"

@interface MeInfoEditController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MeInfoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self configData];
}

- (void)configUI {
    
    UIImageView *bgImageV = [UIImageView new];
    bgImageV.image = [UIImage imageNamed:@"sy_userinfo_bg_img"];
    [self.view addSubview:bgImageV];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    // 毛玻璃
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView * visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    [self.view addSubview:visualView];
//    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)configData {
    
    NSDictionary *dic0 = @{@"title":@"头像",@"subTitle":@"",@"value":@""};
    NSDictionary *dic1 = @{@"title":@"昵称",@"subTitle":@"(只准改一次，请谨慎修改)",@"value":@"mj小米地"};
    NSDictionary *dic2 = @{@"title":@"性别",@"subTitle":@"",@"value":@"男"};
    NSDictionary *dic3 = @{@"title":@"生日",@"subTitle":@"",@"value":@"2000-10-10"};
    NSDictionary *dic4 = @{@"title":@"所在地",@"subTitle":@"",@"value":@""};
    NSDictionary *dic5 = @{@"title":@"123",@"subTitle":@"",@"value":@""};
    NSDictionary *dic6 = @{@"title":@"456",@"subTitle":@"",@"value":@""};
    NSArray *arr = @[dic0,dic1,dic2,dic3,dic4,dic5,dic6];
    self.dataArr = [MeUserEditModel mj_objectArrayWithKeyValuesArray:arr];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == 0 ? 98 : 54.5 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeInfoEditCell class]) forIndexPath:indexPath];
    cell.headImageV.hidden = indexPath.row == 0 ? NO : YES;
    cell.valueLabel.hidden = indexPath.row == 0 ? YES : NO;
    
    MeUserEditModel *model = self.dataArr[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.subTitleLabel.text = model.subTitle;
    cell.valueLabel.text = model.value.length >0 ? model.value:@"未设置";
    
    return cell;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView registerClass:[MeInfoEditCell class] forCellReuseIdentifier:NSStringFromClass([MeInfoEditCell class])];
        
    }
    return _tableView;
}




@end
