//
//  SYMeInfoEditController.m
//  ViewDemos
//
//  Created by sam chojine on 2021/1/23.
//

#import "SYMeInfoEditController.h"
#import "SYMeInfoEditCell.h"
#import "SYMeInfoEditModel.h"

#import "SMMUILayoutCategories.h"


static NSString * meInfoCellIdentifier = @"meInfoCellIdentifier";
static NSString * meShengjianCellIdentifier = @"meShengjianCellIdentifier";

@interface SYMeInfoHeaderView : UIView

@property (nonatomic, strong) UIView *contentView_c;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UIButton *bgUploadButton;
@property (nonatomic, strong) UIButton *avatarUploadButton;


@end

@implementation SYMeInfoHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _configSubviews];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    _avatarImage.layer.cornerRadius = 71.5 * kWidthScale / 2.0;
    _bgImage.layer.cornerRadius = kUIPadding;
    [_bgUploadButton layerCornerRadiusWithRadius:kUIPadding corner:(UIRectCornerTopRight|UIRectCornerBottomLeft)];
}

- (void)_configSubviews {
    
    _contentView_c = [UIView new];
    _contentView_c.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    _contentView_c.layer.cornerRadius = kUIPadding;
    
    _bgImage = [UIImageView new];
    _bgImage.contentMode = UIViewContentModeScaleAspectFit;
    _bgImage.layer.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4].CGColor;
    
    _avatarImage = [UIImageView new];
    _avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImage.layer.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4].CGColor;
    
    _bgUploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgUploadButton.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
    _bgUploadButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgUploadButton setImage:[UIImage imageNamed:@"sy_userinfo_camera_btn"] forState:UIControlStateNormal];
    [_bgUploadButton addTarget:self action:@selector(uploadBgImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _avatarUploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatarUploadButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_avatarUploadButton setImage:[UIImage imageNamed:@"sy_userinfo_cameralittle_btn"] forState:UIControlStateNormal];
    [_avatarUploadButton addTarget:self action:@selector(uploadAvatarImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_contentView_c];
    
    [_contentView_c addSubview:_bgImage];
    [_contentView_c addSubview:_avatarImage];
    [_contentView_c addSubview:_bgUploadButton];
    [_contentView_c addSubview:_avatarUploadButton];
    
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(kUIPadding).priority(250);
        make.right.equalTo(self.mas_right).offset(-kUIPadding).priority(250);
    }];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView_c);
    }];
    
    CGSize asize = CGSizeMake(71.0*kWidthScale, 71.0*kWidthScale);
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(asize);
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.centerY.equalTo(_contentView_c.mas_centerY);
    }];
    
    CGSize uasize = CGSizeMake(25.0*kWidthScale, 25.0*kWidthScale);
    
    [_avatarUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(uasize);
        make.right.equalTo(_avatarImage.mas_right).offset(-kUIPaddingHalf/4.0);
        make.bottom.equalTo(_avatarImage.mas_bottom).offset(-kUIPaddingHalf/4.0);
    }];
    
    CGSize ubsize = CGSizeMake(53.0*kWidthScale, 53.0*kWidthScale);
    [_bgUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(ubsize);
        make.top.equalTo(_bgImage.mas_top);
        make.right.equalTo(_bgImage.mas_right);
    }];
}

- (void)uploadBgImageAction:(UIButton *)sender {
    
}

- (void)uploadAvatarImageAction:(UIButton *)sender {
    
}


@end

@interface SYMeInfoEditController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYMeInfoHeaderView *tabHeaderView;

@property (nonatomic, strong) NSArray<SYMeInfoEditModel *> *dataArr;

@property (nonatomic, strong) SYMeInfoEditPopView *popEditView;


@end

@implementation SYMeInfoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self configData];
}

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _configTableView];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    NSMutableArray<SYMeInfoEditModel *> *mmodels = [NSMutableArray array];
    for (NSUInteger i = 0; i < titles.count; i++) {
        SYMeInfoEditModel *model = [SYMeInfoEditModel new];
        model.title = titles[i];
        model.subTitle = subtitles[i];
        model.value = values[i];
        model.popctype = [popctypes[i] unsignedIntegerValue];
        model.poptitlem = [poptitlems[i] unsignedIntegerValue];
        model.popname = [popnames[i] unsignedIntegerValue];
        
        [mmodels addObject:model];
    }
    
    _dataArr = [mmodels copy];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == 0 ? 98 : 54.5 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYMeInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:meInfoCellIdentifier forIndexPath:indexPath];
    cell.headImageV.hidden = indexPath.row == 0 ? NO : YES;
    cell.valueLabel.hidden = indexPath.row == 0 ? YES : NO;
    
    SYMeInfoEditModel *model = self.dataArr[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.subTitleLabel.text = model.subTitle;
    cell.valueLabel.text = model.value.length > 0 ? model.value : @"未设置";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYMeInfoEditModel *meModel = _dataArr[indexPath.row];
    
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
            
            SYMeInfoEditCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
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

- (void)_configTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColor.clearColor;
    
    _tabHeaderView = [[SYMeInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, 120.0, 160.0*kWidthScale)];
    
    _tableView.tableHeaderView = _tabHeaderView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[SYMeInfoEditCell class] forCellReuseIdentifier:meInfoCellIdentifier];
    
}

@end
