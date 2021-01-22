//
//  KXHomeRecommendedView.m
//  yuewan
//
//  Created by Michael on 2021/1/11.
//

#import "KXHomeRecommendedView.h"
#import "SMMCategories.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * rmdUserCellIdentifier = @"KXHomeRecommendedCellIdentifier";

@implementation KXHomeRecommendedModel

- (instancetype)initWithData:(id)data {
    if (data == nil) {
        return nil;
    }
    if (self = [super init]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            _avatarURL = [data[@"headPortraitUrl"] stringValue] ? [NSURL URLWithString:[data[@"headPortraitUrl"] stringValue]] : nil;
            _age = [data[@"age"] unsignedIntegerValue];
            _gender = [data[@"sex"] unsignedIntegerValue];
            _name = [data[@"nickName"] stringValue];
            _identifier = [data[@"customerId"] unsignedIntegerValue];
        } else {
            return nil;
        }
    }
    return self;
    
}

@end

@interface KXHomeRecommendedCell ()

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *nameText;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIButton *genderAndAgeButton;
@property (nonatomic, strong) CAGradientLayer *genderGLLayer;

@property (nonatomic, copy) void (^selectedCallback)(BOOL isSelected);

@property (nonatomic, strong) KXHomeRecommendedModel *model;

@end

@implementation KXHomeRecommendedCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addCustomViews];
    }
    return self;
}

- (void)layoutSubviews {
    _avatarImage.layer.cornerRadius = 50.0*kWidthScale / 2.0;
    _avatarImage.layer.masksToBounds = YES;
    
    [self makeViewGradient:_genderAndAgeButton isBoy:(_model.gender == 1)];
}

- (void)makeViewGradient:(UIButton *)view isBoy:(BOOL)isBoy {
    
    [_genderGLLayer removeFromSuperlayer];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = view.bounds;
    
    if (isBoy) {
        gl.startPoint = CGPointMake(-0.18, -0.13);
        gl.endPoint = CGPointMake(0.86, 1.08);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:153/255.0 green:219/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:96/255.0 green:180/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
    } else {
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(0.97, 1.06);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:166/255.0 blue:187/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:107/255.0 blue:132/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
    }
    
    gl.cornerRadius = 7.5*kWidthScale;
    
    _genderGLLayer = gl;
    
    [view.layer insertSublayer:_genderGLLayer below:view.imageView.layer];
}

- (void)updateInfoWithModel:(KXHomeRecommendedModel *)model {
    
    _model = model;
    
    _nameText.text = model.name;
    _selectButton.selected = model.isSelected;
    
    if (model.age == 0) {
        [_genderAndAgeButton setTitle:nil forState:UIControlStateNormal];
    } else {
        [_genderAndAgeButton setTitle:[@(model.age) stringValue] forState:UIControlStateNormal];
    }
    
    if (model.gender == 1) {
        [_genderAndAgeButton setImage:[UIImage imageNamed:@"man_icon_small"] forState:UIControlStateNormal];
    } else {
        [_genderAndAgeButton setImage:[UIImage imageNamed:@"woman_icon_small"] forState:UIControlStateNormal];
    }
    
    [_avatarImage sd_setImageWithURL:model.avatarURL placeholderImage:nil];
}

- (void)configSelectedCallback:(void (^)(BOOL))callback {
    _selectedCallback = callback;
}

- (void)changeSelectedButtonState:(BOOL)isSelected {
    _selectButton.selected = isSelected;
}

- (void)addCustomViews {
    
    CGSize a_size = CGSizeMake(50.0*kWidthScale, 50.0*kWidthScale);
    CGSize s_size = CGSizeMake(13.5*kWidthScale, 13.5*kWidthScale);
    
    _avatarImage = [UIImageView new];
    _avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImage.backgroundColor = [UIColor systemTealColor];
    
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.contentMode = UIViewContentModeScaleAspectFit;
    [_selectButton setImage:[UIImage imageNamed:@"ym_checknull_btn"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"ym_checkyes_btn"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameText = [UILabel new];
    _nameText.textAlignment = NSTextAlignmentCenter;
    _nameText.textColor = [UIColor blackColor];
    _nameText.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
    
    _genderAndAgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _genderAndAgeButton.userInteractionEnabled = NO;
    _genderAndAgeButton.titleLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium];
    _genderAndAgeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_genderAndAgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 图片右侧留点间隙
    _genderAndAgeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4.0);
    
    [self.contentView addSubview:_avatarImage];
    [self.contentView addSubview:_selectButton];
    [self.contentView addSubview:_nameText];
    [self.contentView addSubview:_genderAndAgeButton];
    
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(a_size));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(s_size));
        make.top.equalTo(_avatarImage.mas_top);
        make.right.equalTo(_avatarImage.mas_right);
    }];
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(14.0));
        make.top.equalTo(_avatarImage.mas_bottom).offset(8.5*kWidthScale);
        make.left.equalTo(self.contentView.mas_left).offset(-kUIPaddingHalf);
        make.right.equalTo(self.contentView.mas_right).offset(kUIPaddingHalf);
    }];
    
    [_genderAndAgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(32.0*kWidthScale, 15.0*kWidthScale)));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(_nameText.mas_bottom).offset(3.5*kWidthScale);
    }];
    
}

- (void)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (_selectedCallback) {
        _selectedCallback(sender.isSelected);
    }
}

@end

@interface KXHomeRecommendedView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    CGSize _contentViewSize;
}

@property (nonatomic, strong) UIView *backgroundView_c;
@property (nonatomic, strong) UIImageView *contentView_c;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<KXHomeRecommendedModel *> *rcmdUsrsModels;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, copy) void(^followCallback)(NSArray<NSNumber *> *ids);

@end


@implementation KXHomeRecommendedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentViewSize = CGSizeMake(260.0*kWidthScale, 372.0*kWidthScale);
        [self _addCustomViews];
    }
    return self;
}

- (void)_addCustomViews {
    
    _backgroundView_c = [UIView new];
    _backgroundView_c.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _backgroundView_c.userInteractionEnabled = YES;
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapToHide)];
    [_backgroundView_c addGestureRecognizer:oneTap];
    
    _contentView_c = [UIImageView new];
    _contentView_c.userInteractionEnabled = YES;
    _contentView_c.contentMode = UIViewContentModeScaleAspectFit;
    _contentView_c.image = [UIImage imageNamed:@"ym_rcmdusrs_bg"];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followButton setImage:[UIImage imageNamed:@"ym_rcmdusrs_follow_btn"] forState:UIControlStateNormal];
    [_followButton addTarget:self action:@selector(_tapToFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"ym_popview_bottom_close_btn"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(_closeViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self _configCollectionView];
    
    [self addSubview:_backgroundView_c];
    [self addSubview:_contentView_c];
    [_contentView_c addSubview:_collectionView];
    [_contentView_c addSubview:_followButton];
    [_contentView_c addSubview:_closeButton];
    
    [_backgroundView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGSize c_size = _contentViewSize;
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-kUIPadding);
        make.size.equalTo(@(c_size));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(265.0*kWidthScale, 215.0*kWidthScale)));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.centerY.equalTo(_contentView_c.mas_centerY).offset(kUIPaddingHalf);
    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(204.0*kWidthScale, 60.0*kWidthScale)));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.bottom.equalTo(_contentView_c.mas_bottom).offset(-kUIPaddingHalf);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(32.0*kWidthScale, 32.0*kWidthScale)));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.top.equalTo(_contentView_c.mas_bottom).offset(20.0);
    }];
    
}

// MARK: - override

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (__kindof UIView *view in _contentView_c.subviews) {
        CGPoint viewP = [self convertPoint:point toView:view];
        if ([view isEqual:_closeButton] && [view pointInside:viewP withEvent:event]) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

// MARK: - open methods

- (void)showInView:(__kindof UIView *)view withList:(nonnull NSArray<KXHomeRecommendedModel *> *)list {
    
    [view addSubview:self];
    _contentView_c.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self->_contentView_c.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
        
    }];
    
    // 先把其中的元素的选择状态改了
    [list enumerateObjectsUsingBlock:^(KXHomeRecommendedModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = YES;
    }];
    
    _rcmdUsrsModels = list;
    
    [_collectionView reloadData];
}

- (void)_closeViewAction:(UIButton *)sender {
    [self hide];
}

- (void)hide {
    
    [UIView animateWithDuration:0.2 animations:^{
        self->_contentView_c.transform = CGAffineTransformMakeScale(0.4, 0.4);
        self->_contentView_c.alpha = 0;
    } completion:^(BOOL finished) {
        self->_contentView_c.alpha = 1;
        [self removeFromSuperview];
    }];
}

- (void)configFollowButtonCallback:(void (^)(NSArray<NSNumber *> * _Nonnull))callback {
    _followCallback = callback;
}

- (void)_configCollectionView {
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[KXHomeRecommendedCell class] forCellWithReuseIdentifier:rmdUserCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, kUIPaddingHalf, kUIPaddingHalf, kUIPaddingHalf);
}

// MARK: - view event

- (void)_tapToFollowAction:(UIButton *)sender {
    printf("_tapToFollowAction\n");
    
    if (_followCallback) {
        NSArray<NSNumber *> *ids = [self _selectedUserIds];
        _followCallback(ids);
    }
}

- (void)_tapToHide {
    [self hide];
}

/// 改变 model 的选择状态，根据相应 cell 的 indexPath 。
- (void)changeSelectedState:(BOOL)isSelected ofIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _rcmdUsrsModels.count-1) {
        return;
    }
    KXHomeRecommendedModel *obj = _rcmdUsrsModels[indexPath.row];
    if (isSelected != obj.isSelected) {
        obj.isSelected = isSelected;
    }
}

- (void)switchSelectedStateOfIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _rcmdUsrsModels.count-1) {
        return;
    }
    KXHomeRecommendedModel *obj = _rcmdUsrsModels[indexPath.row];
    obj.isSelected = !obj.isSelected;
    
    KXHomeRecommendedCell *cell = (KXHomeRecommendedCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [cell changeSelectedButtonState:obj.isSelected];
    }
}

/// 选择的要关注的用户 id 的数组。
- (NSArray<NSNumber *> *)_selectedUserIds {
    NSMutableArray<NSNumber *> *ids = [NSMutableArray array];
    for (KXHomeRecommendedModel *_model in _rcmdUsrsModels) {
        if (_model.isSelected) {
            [ids addObject:[NSNumber numberWithUnsignedInteger:_model.identifier]];
        }
    }
    return [ids copy];
}

// MARK: - 集合视图数据源、代理、布局

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _rcmdUsrsModels?_rcmdUsrsModels.count:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KXHomeRecommendedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rmdUserCellIdentifier forIndexPath:indexPath];
    KXHomeRecommendedModel *model = _rcmdUsrsModels[indexPath.row];
    [cell updateInfoWithModel:model];
    __weak typeof(self) weakSelf = self;
    [cell configSelectedCallback:^(BOOL isSelected) {
        [weakSelf changeSelectedState:isSelected ofIndexPath:indexPath];
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = 75.0*kWidthScale;
    CGFloat itemHeight = 91.0*kWidthScale;
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kUIPaddingHalf / 2.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self switchSelectedStateOfIndexPath:indexPath];
}


@end

