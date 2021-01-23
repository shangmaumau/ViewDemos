//
//  SYUserInfoSelectPopView.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import "SYUserInfoSelectPopView.h"
#import "SMMCategories.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString * tofuCellIdentifier = @"tofuCellIdentifier";


@implementation SYUserInfoTofuModel

- (instancetype)init {
    if (self = [super init]) {
        _name = @"我是名称";
        _identifier = 9999999;
        _isSelected = NO;
    }
    return self;
}

@end

@implementation SYUserInfoTofuCell

// MARK: - 公开方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _addSubviews];
    }
    return self;
}

- (void)updateContentWithModel:(SYUserInfoTofuModel *)model {
    _model = model;
    [_tofuButton setTitle:model.name forState:UIControlStateNormal];
    [self changeSelectedButtonState:model.isSelected];
}

/// 外部决定是否改变按钮的选择态。
- (void)changeSelectedButtonState:(BOOL)isSelected {
    
    _tofuButton.selected = isSelected;
    _model.isSelected = isSelected;
    
    [self _updateTitleColorOfView:_tofuButton];
    [self _updateGradientLayerOfView:_tofuButton];
}

- (void)configSelectedCallback:(void (^)(BOOL))callback {
    _selectedCallback = callback;
}

// MARK: - 覆写父类方法

- (void)layoutSubviews {
    [self _updateGradientLayerOfView:_tofuButton];
}

// MARK: - 视图交互事件

- (void)_tofuButtonAction:(UIButton *)sender {
    /// 只改变选择态，不改变形态，形态如果不能改变，则需要将选择态复原为未选择
    sender.selected = !sender.selected;
    if (_selectedCallback) {
        _selectedCallback(sender.isSelected);
    }
}

// MARK: - 配置子视图

- (void)_addSubviews {
    
    _tofuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _tofuButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_tofuButton addTarget:self action:@selector(_tofuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_tofuButton];
    
    // 82.5 43
    CGSize bsize = CGSizeMake(82.5*kWidthScale, 43.0*kWidthScale);
    [_tofuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(bsize));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

// MARK: - 更新视图数据、效果

- (void)_updateGradientLayerOfView:(UIButton *)view {
    
    [_genderGLLayer removeFromSuperlayer];
    
    if (view.isSelected) {
        
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = view.bounds;
        
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:226/255.0 green:187/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:120/255.0 blue:253/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:199/255.0 blue:142/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(0.6f), @(1.0f)];
        
        gl.cornerRadius = 21.5*kWidthScale;
        
        _genderGLLayer = gl;
        
        [view.layer insertSublayer:_genderGLLayer below:view.imageView.layer];
        
    } else {
        
        view.layer.backgroundColor = [UIColor whiteColor].CGColor;
        view.layer.cornerRadius = 21.5*kWidthScale;
    }
}

- (void)_updateTitleColorOfView:(UIButton *)view {
    // rgba(99, 85, 136, 1)
    if (view.isSelected) {
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [view setTitleColor:[UIColor colorWith255R:99 g:85 b:136] forState:UIControlStateNormal];
    }
}

@end

@interface SYUserInfoSelectPopView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    NSUInteger _tagIndex;
}

@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *subtitleText;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSArray<SYUserInfoTofuTagModel *> *tofuTagModels;
@property (nonatomic, strong) NSArray<SYUserInfoTofuModel *> *tofuModels;

@end

@implementation SYUserInfoSelectPopView

// MARK: - 公开方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.doneButton.hidden = YES;
        _tagIndex = 0;
        
        [self _configBasicSubviews];
    }
    return self;
}

- (void)showOnView:(__kindof UIView *)view withModels:(NSArray<SYUserInfoTofuModel *> *)list {
    [super showOnView:view];
    
    [self updateWithModels:list];
    [self updateBottomButtonTitle:NSLocalizedString(@"下一步", @"")];
}

- (void)updateWithModels:(NSArray<SYUserInfoTofuModel *> *)list {
    _tofuModels = list;
    [_collectionView reloadData];
}

// MARK: - 

// MARK: - 配置子视图

- (void)_configBasicSubviews {
    
    _titleText = [UILabel new];
    _titleText.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium];
    _titleText.textColor = [UIColor doubleFishThemeColor];
    _titleText.text = NSLocalizedString(@"我是大标题", @"");
    
    _subtitleText = [UILabel new];
    _subtitleText.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    // rgba(99, 85, 136, 1)
    _subtitleText.textColor = [UIColor colorWith255R:99.0 g:85.0 b:136.0];
    _subtitleText.text = NSLocalizedString(@"我是小标题", @"");
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"df_userinfo_next_btn"] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self _configCollectionView];
    
    [self.contentView_c addSubview:_titleText];
    [self.contentView_c addSubview:_subtitleText];
    [self.contentView_c addSubview:_nextButton];
    [self.contentView_c addSubview:_collectionView];
    
    CGFloat cheight = 521.0*kWidthScale;
    
    [self.contentView_c mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(cheight));
    }];
    
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30.0*kWidthScale));
        make.top.equalTo(self.viewTitleText.mas_bottom).offset(30.0);
        make.left.equalTo(self.contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(self.contentView_c.mas_right).offset(-kUIPadding);
    }];
    
    [_subtitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20.0*kWidthScale));
        make.top.equalTo(_titleText.mas_bottom).offset(2.0);
        make.left.equalTo(self.contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(self.contentView_c.mas_right).offset(-kUIPadding);
    }];
    
    CGSize bsize = CGSizeMake(311.0*kWidthScale, 50.0*kWidthScale);
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(bsize));
        make.centerX.equalTo(self.contentView_c.mas_centerX);
        make.bottom.equalTo(self.contentView_c.mas_safeAreaLayoutGuideBottom).offset(-kUIPadding);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subtitleText.mas_bottom).offset(24.0);
        make.left.equalTo(self.contentView_c.mas_left).offset(0);
        make.right.equalTo(self.contentView_c.mas_right).offset(-0);
        make.bottom.equalTo(_nextButton.mas_top).offset(-kUIPadding);
    }];
    
}

- (void)_configCollectionView {
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[SYUserInfoTofuCell class] forCellWithReuseIdentifier:tofuCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 30.0*kWidthScale, kUIPadding, 30.0*kWidthScale);
}

// MARK: - 集合视图数据源、代理、布局

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tofuModels ? _tofuModels.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SYUserInfoTofuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tofuCellIdentifier forIndexPath:indexPath];
    SYUserInfoTofuModel *model = _tofuModels[indexPath.row];
    [cell updateContentWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [cell configSelectedCallback:^(BOOL isSelected) {
        [weakSelf _changeSelectedState:isSelected ofIndexPath:indexPath];
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = 82.5*kWidthScale;
    CGFloat itemHeight = 43.0*kWidthScale;
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kUIPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 30.0 * kWidthScale;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // [self _switchSelectedStateOfIndexPath:indexPath];
}

// MARK: - 其他方法

- (void)_changeSelectedState:(BOOL)isSelected ofIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _tofuModels.count-1) {
        return;
    }
    
    SYUserInfoTofuCell *cell = (SYUserInfoTofuCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    if (isSelected && [self _selectedItemIds].count == 5) {
        
        [self showHUDWithTitle:NSLocalizedString(@"最多选择5个", @"")];
        
        if (cell) {
            // 恢复到原状态
            [cell changeSelectedButtonState:NO];
        }
        return;
    }
    
    SYUserInfoTofuModel *obj = _tofuModels[indexPath.row];
    if (isSelected != obj.isSelected) {
        obj.isSelected = isSelected;
        if (cell) {
            [cell changeSelectedButtonState:isSelected];
        }
    }
}

- (NSArray<NSNumber *> *)_selectedItemIds {
    NSMutableArray<NSNumber *> *ids = [NSMutableArray array];
    
    for (SYUserInfoTofuModel *_model in _tofuModels) {
        if (_model.isSelected) {
            [ids addObject:[NSNumber numberWithUnsignedInteger:_model.identifier]];
        }
    }
    return [ids copy];
}

- (void)showHUDWithTitle:(NSString *)title {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView_c animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.textColor = [UIColor whiteColor];
    
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.bezelView.layer.cornerRadius = kUIPadding;
    
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)updateBottomButtonTitle:(NSString *)newTitle {
    [_nextButton setTitle:newTitle forState:UIControlStateNormal];
}

@end
