//
//  KXHomeNewComerGiftsView.m
//  yuewan
//
//  Created by Michael on 2021/1/7.
//

#import "KXHomeNewComerGiftsView.h"
#import "SMMCategories.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * giftCellIdentifier = @"MNHomeNewComerGiftCellIdentifier";

@implementation KXHomeNewComerGiftModel

- (instancetype)initWithData:(id)data {
    if (data == nil) {
        return nil;
    }
    if (self = [super init]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            _iconURL = [data[@"iconUrl"] stringValue] ? [NSURL URLWithString:[data[@"iconUrl"] stringValue]] : nil;
            _name = [data[@"name"] stringValue];
            _quantity = [data[@"num"] unsignedIntegerValue];
            _sortNum = [data[@"sortNum"] unsignedIntegerValue];
            _identifier = [data[@"id"] unsignedIntegerValue];
        } else {
            return nil;
        }
    }
    return self;
}

@end

@implementation KXHomeNewComerGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addCustomViews];
    }
    return self;
}

- (void)addCustomViews {
    
    _contentView_c = [UIView new];
    _contentView_c.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:245.0/255.0 blue:222.0/255.0 alpha:1.0];
    _contentView_c.layer.cornerRadius = 10.0;
    
    _iconImage = [UIImageView new];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _nameAndQuantityText = [UILabel new];
    _nameAndQuantityText.textAlignment = NSTextAlignmentCenter;
    _nameAndQuantityText.textColor = [UIColor colorWithRed:214.0/255.0 green:108.0/255.0 blue:1.0/255.0 alpha:1.0];
    _nameAndQuantityText.font = [UIFont systemFontOfSize:8.5];
    
    [self.contentView addSubview:_contentView_c];
    [self.contentView addSubview:_iconImage];
    [self.contentView addSubview:_nameAndQuantityText];
    
    CGSize ibg_size = CGSizeMake(47.0*kWidthScale, 47.0*kWidthScale);
    CGSize i_size = CGSizeMake(35.0*kWidthScale, 35.0*kWidthScale);
    
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(ibg_size));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(i_size));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(_contentView_c.mas_centerY);
    }];
    
    [_nameAndQuantityText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView_c.mas_bottom).offset(kUIPaddingHalf/2.0);
        make.left.equalTo(_contentView_c.mas_left).offset(-kUIPaddingHalf);
        make.right.equalTo(_contentView_c.mas_right).offset(kUIPaddingHalf);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)updateWithIconURL:(NSURL *)url giftName:(NSString *)name andQuantity:(NSUInteger)quantity {
    
    // [_iconImage lv_setImageWithURL:url.absoluteString placeholder:XN_IMG(@"gift_pannel_placeholder")];
    
    [_iconImage sd_setImageWithURL:url placeholderImage:nil];
    NSString *tmpName = name;
    
    // TODO: 土方法，没有考虑中英混合的情况
    if (tmpName.length > 5) {
        tmpName = [NSString stringWithFormat:@"%@…", [tmpName substringToIndex:5]];
    }
    
    NSString *text = [NSString stringWithFormat:@"%@×%lu", tmpName, (unsigned long)quantity];
    if (quantity == 0) {
        text = tmpName;
    }
    _nameAndQuantityText.text = text;
}

@end

@interface KXHomeNewComerGiftsView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    CGSize _contentViewSize;
}

@property (nonatomic, strong) UIView *backgroundView_c;

@property (nonatomic, strong) UIImageView *contentView_c;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<KXHomeNewComerGiftModel *> *giftModels;

@property (nonatomic, strong) UIButton *enterAndDrawButton;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, copy) void(^drawBlock)(void);

@end


@implementation KXHomeNewComerGiftsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentViewSize = CGSizeMake(316.0*kWidthScale, 400.0*kWidthScale);
        [self _addCustomViews];
    }
    return self;
}

- (void)configDrawCallbackAction:(void (^)(void))callback {
    _drawBlock = callback;
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
    _contentView_c.image = [UIImage imageNamed:@"ym_newcomer_gifts_bg"];
    
    _enterAndDrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_enterAndDrawButton setImage:[UIImage imageNamed:@"ym_newcomer_gifts_draw_btn"] forState:UIControlStateNormal];
    [_enterAndDrawButton addTarget:self action:@selector(_enterAndDrawAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"ym_popview_bottom_close_btn"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [self _configCollectionView];
    
    [self addSubview:_backgroundView_c];
    [self addSubview:_contentView_c];
    
    [_contentView_c addSubview:_collectionView];
    [_contentView_c addSubview:_enterAndDrawButton];
    [_contentView_c addSubview:_closeButton];
    
    [_backgroundView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGSize c_size = _contentViewSize;
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.equalTo(@(c_size));
    }];
    
    [_enterAndDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(123.5*kWidthScale));
        make.height.equalTo(@(40.5*kWidthScale));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.bottom.equalTo(_contentView_c.mas_bottom).offset(-kUIPaddingHalf*1.5);
    }];
    
    CGSize co_size = CGSizeMake(200.0*kWidthScale, 210.0*kWidthScale);
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(co_size));
        make.centerY.equalTo(_contentView_c.mas_centerY).offset(kUIPadding * 1.5 * kWidthScale);
        make.centerX.equalTo(_contentView_c.mas_centerX);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(32.0*kWidthScale, 32.0*kWidthScale)));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.top.equalTo(_contentView_c.mas_bottom).offset(20.0);
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (__kindof UIView *view in _contentView_c.subviews) {
        CGPoint viewP = [self convertPoint:point toView:view];
        if ([view isEqual:_closeButton] && [view pointInside:viewP withEvent:event]) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)_configCollectionView {
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[KXHomeNewComerGiftCell class] forCellWithReuseIdentifier:giftCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, kUIPaddingHalf, kUIPaddingHalf, kUIPaddingHalf);
    
}

- (void)_enterAndDrawAction:(UIButton *)sender {
    printf("_enterAndDrawAction\n");
    if (_drawBlock) {
        _drawBlock();
    }
}

- (void)_tapToHide {
    [self hide];
}

- (void)showInView:(__kindof UIView *)view withList:(nonnull NSArray<KXHomeNewComerGiftModel *> *)list {
    
    [view addSubview:self];
    _contentView_c.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self->_contentView_c.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
        
    }];
    
    _giftModels = list;
    
    [_collectionView reloadData];
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

// MARK: - 集合视图数据源、代理、布局

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _giftModels?_giftModels.count:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KXHomeNewComerGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:giftCellIdentifier forIndexPath:indexPath];
    KXHomeNewComerGiftModel *model = _giftModels[indexPath.row];
    
    [cell updateWithIconURL:model.iconURL giftName:model.name andQuantity:model.quantity];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = 50.0*kWidthScale;
    CGFloat itemHeight = 60.0*kWidthScale;
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kUIPaddingHalf * 1.5; // 12.0pt
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kUIPadding / 2.0;
}


@end

