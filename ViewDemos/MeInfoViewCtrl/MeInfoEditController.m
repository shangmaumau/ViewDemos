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

@interface MeInfoEditController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<MeUserEditModel *> *dataArr;

@property (nonatomic, strong) SYMeInfoEditPopView *popEditView;

@end

@implementation MeInfoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self configData];
}

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _popEditView = [[SYMeInfoEditPopView alloc] initWithFrame:self.view.bounds];
}

- (void)configData {
    
    NSArray<NSString *> *titles = @[ @"头像", @"昵称", @"性别", @"生日", @"所在地", @"个性签名"];
    NSArray<NSString *> *subtitles = @[ @"", @"", @"(只准改一次，请谨慎修改)", @"", @"", @""];
    NSArray<NSString *> *values = @[ @"", @"mj小米地", @"男", @"2000-10-10", @"", @"", @""];
    NSArray<NSNumber *> *popctypes = @[@(0), @(PopContentTypeTextField), @(PopContentTypePickerView), @(PopContentTypeDatePicker), @(PopContentTypePickerView), @(PopContentTypeTextView)];
    NSArray<NSNumber *> *poptitlems = @[@(0), @(PopTitleModeNormal), @(PopTitleModeNull), @(PopTitleModeNormal), @(PopTitleModeNormal), @(PopTitleModeNormal)];
    NSArray<NSNumber *> *popnames = @[@(0), @(PopViewNameNull), @(PopViewNameGender), @(PopViewNameBirthday), @(PopViewNameAddress), @(PopViewNameNull)];
    
    NSMutableArray<MeUserEditModel *> *mmodels = [NSMutableArray array];
    for (NSUInteger i = 0; i < titles.count; i++) {
        MeUserEditModel *model = [MeUserEditModel new];
        model.title = titles[i];
        model.subTitle = subtitles[i];
        model.value = values[i];
        model.popctype = [popctypes[i] unsignedIntegerValue];
        model.poptitlem = [poptitlems[i] unsignedIntegerValue];
        model.popname = [popnames[i] unsignedIntegerValue];
        
        [mmodels addObject:model];
    }
    
    self.dataArr = [mmodels copy];
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
    cell.valueLabel.text = model.value.length > 0 ? model.value : @"未设置";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeUserEditModel *meModel = self.dataArr[indexPath.row];
    
    SYMeInfoEditPopModel *popmodel = [SYMeInfoEditPopModel new];
    
    popmodel.contentType = meModel.popctype;
    popmodel.titleMode = meModel.poptitlem;
    popmodel.viewName = meModel.popname;
    popmodel.recoveryData = meModel.value;
    
    [self showPopEditViewWithData:popmodel index:indexPath];
}

- (void)showPopEditViewWithData:(SYMeInfoEditPopModel *)model index:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    [_popEditView showOnView:self.view withData:model];
    [_popEditView configDoneCallback:^(id  _Nullable data) {
       
        if (data) {
            
            weakSelf.dataArr[indexPath.row].value = data;
            
            MeInfoEditCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                NSString *value = (NSString *)data;
                if ([data isKindOfClass:[NSDate class]]) {
                    NSDateFormatter *df = [NSDateFormatter new];
                    df.dateFormat = @"yyyy-MM-dd";
                    value = [df stringFromDate:(NSDate *)data];
                }
                
                if ([value isKindOfClass:[NSString class]]) {
                    cell.valueLabel.text = value;
                }
            }
        }
    }];
    
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
