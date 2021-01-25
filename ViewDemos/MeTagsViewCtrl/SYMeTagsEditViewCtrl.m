//
//  SYMeTagsEditViewCtrl.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import "SYMeTagsEditViewCtrl.h"
#import "SYMeTagsEditCell.h"
#import "SYMeTagsEditHeaderView.h"

#import "SMMUILayoutCategories.h"

@interface UIPictureButton : UIView

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, copy) void (^tapCallback)(void);

- (void)configImage:(UIImage *)image text:(NSString *)text;
- (void)configTapCallback:(void (^)(void))callback;

@end

@implementation UIPictureButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _configSubviews];
    }
    return self;
}

- (void)_configSubviews {
    
    _icon = [UIImageView new];
    _icon.contentMode = UIViewContentModeCenter;
    
    _text = [UILabel new];
    _text.font = [UIFont systemFontOfSize:12.0];
    // rgba(255, 120, 253, 1)
    _text.textColor =[UIColor colorWith255R:255 g:120 b:253];
    _text.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_icon];
    [self addSubview:_text];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height).multipliedBy(0.7);
    }];
    
    [_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height).multipliedBy(0.3);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__tapSelfAction:)];
    
    [self addGestureRecognizer:tap];
}

- (void)configTapCallback:(void (^)(void))callback {
    _tapCallback = callback;
}

- (void)configImage:(UIImage *)image text:(NSString *)text {
    _icon.image = image;
    _text.text = text;
}

- (void)__tapSelfAction:(UIGestureRecognizer *)gesture {
    if (_tapCallback) {
        _tapCallback();
    }
}

@end


@interface SYMeTagsHeaderView : UIView

@property (nonatomic, strong) UIView *contentView_c;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIPictureButton *selectPhotoButton;

@end

@implementation SYMeTagsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _configSubviews];
    }
    return self;
}

- (void)_configSubviews {
    
    _contentView_c = [UIView new];
    _contentView_c.backgroundColor = [[UIColor systemGreenColor] colorWithAlphaComponent:0.4];
    _contentView_c.layer.cornerRadius = kUIPadding;
    
    _bgImageView = [UIImageView new];
    
    _selectPhotoButton = [UIPictureButton new];
    [_selectPhotoButton configImage:[UIImage imageNamed:@"sy_userinfo_camera_btn"] text:NSLocalizedString(@"上传照片", @"")];
    
    [self addSubview:_contentView_c];
    
    [_contentView_c addSubview:_bgImageView];
    [_contentView_c addSubview:_selectPhotoButton];
    
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
        make.left.equalTo(self.mas_left).offset(kUIPadding).priority(250);
        make.right.equalTo(self.mas_right).offset(-kUIPadding).priority(250);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView_c);
    }];
    
    CGSize bsize = CGSizeMake(50.0*kWidthScale, 50.0*kWidthScale);
    
    [_selectPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(bsize);
        make.centerX.equalTo(_contentView_c);
        make.centerY.equalTo(_contentView_c);
    }];
    
}


@end

static NSString * editCellIdentifier = @"editCellIdentifier";

@implementation MeTagsRowModel


@end

@implementation MeTagsSectionModel


@end

@interface SYMeTagsEditViewCtrl ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYMeTagsHeaderView *headerView;
@property (nonatomic, strong) NSArray<MeTagsSectionModel *> *sectionModels;

@end

@implementation SYMeTagsEditViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _configSubviews];
    [self _configDataSource];
    
    [_tableView reloadData];
}

- (void)_configSubviews {
    
    _headerView = [[SYMeTagsHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 158.5*kWidthScale)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.separatorColor = [[UIColor doubleFishTextGrayColor] colorWithAlphaComponent:0.16];
//    _tableView.separatorInset = UIEdgeInsetsMake(0, kUIPadding, 0, kUIPadding);
    
    [_tableView registerClass:[SYMeTagsEditCell class] forCellReuseIdentifier:editCellIdentifier];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = _headerView;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//    }];
}

- (void)_configDataSource {
    
    NSArray<NSArray<NSString *> *> *rowtitles = @[
        @[ @"外形", @"个性" ],
        @[ @"外形", @"个性" ],
        @[ @"兴趣爱好", @"音乐", @"影视" ]
    ];
    
    NSArray<NSArray<NSString *> *> *rowsubtitles = @[
        @[ @"我的外型特征", @"我的个性特征" ],
        @[ @"我喜欢的外型", @"我喜欢的性格" ],
        @[ @"我喜欢的约会", @"我喜欢的音乐", @"我喜欢的影视" ]
    ];
    
    NSArray<NSString *> *secTitles = @[ @"我的风格", @"我喜欢的", @"兴趣" ];
    NSArray<NSString *> *secSubtitles = @[ @"", @"(精确匹配，不对外显示)", @"" ];
    NSArray<NSString *> *secIcons = @[ @"sy_metags_mystyle_icon", @"sy_metags_mystyle_icon", @"sy_metags_mylove_icon" ];

    NSMutableArray<MeTagsSectionModel *> *models = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < secTitles.count; i++) {
        
        MeTagsSectionModel *secmodel = [MeTagsSectionModel new];
        secmodel.title = secTitles[i];
        secmodel.subtitle = secSubtitles[i];
        secmodel.iconName = secIcons[i];
        
        NSArray<NSString *> *rt = rowtitles[i];
        NSArray<NSString *> *rst = rowsubtitles[i];
        
        NSMutableArray<MeTagsRowModel *> *rowmodels = [NSMutableArray array];
        for (NSUInteger j = 0; j < rt.count; j++) {
            MeTagsRowModel *rowmodel = [MeTagsRowModel new];
            rowmodel.title = rt[j];
            rowmodel.subtitle = rst[j];
            [rowmodels addObject:rowmodel];
        }
        secmodel.rowModels = [rowmodels copy];
        
        [models addObject:secmodel];
    }
    
    _sectionModels = [models copy];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.5 * kWidthScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54.5 * kWidthScale;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionModels ? _sectionModels.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sectionModels[section].rowModels ? _sectionModels[section].rowModels.count : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SYMeTagsEditHeaderView *headerView = [SYMeTagsEditHeaderView new];
    [headerView updateContentWithModel:_sectionModels[section]];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYMeTagsEditCell *cell = [tableView dequeueReusableCellWithIdentifier:editCellIdentifier forIndexPath:indexPath];
    
    MeTagsRowModel *model = _sectionModels[indexPath.section].rowModels[indexPath.row];
    if (model) {
        [cell updateContentWithModel:model];
    }
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
