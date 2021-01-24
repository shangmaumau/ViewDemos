//
//  SYUserInfoBasePopView.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import "SYUserInfoBasePopView.h"
#import "SMMUILayoutCategories.h"

@implementation SYUserInfoBasePopView

// MARK: - 公开方法

- (void)showOnView:(__kindof UIView *)view {
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 options:(7 << 16) animations:^{
        self.animateView.frame = CGRectNewY(0, self.animateView.frame);
        self.backgroundView_c.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 delay:0 options:(7 << 16) animations:^{
        self.animateView.frame = CGRectNewY([UIScreen height_c], self.animateView.frame);
        self.backgroundView_c.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

// MARK: - 覆写父类方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _addBasicSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [_contentView_c layerCornerRadiusWithRadius:16.0 corner:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}

// MARK: - 配置子视图

- (void)_addBasicSubviews {
    
    _backgroundView_c = [UIView new];
    _backgroundView_c.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.3];
    _backgroundView_c.alpha = 0;
    
    _animateView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen height_c], self.bounds.size.width, self.bounds.size.height)];
    
    _contentView_c = [UIView new];
    _contentView_c.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.88];
    
    _viewTitleText = [UILabel new];
    _viewTitleText.textAlignment = NSTextAlignmentCenter;
    _viewTitleText.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    _viewTitleText.textColor = [UIColor doubleFishThemeColor];
    _viewTitleText.text = NSLocalizedString(@"我是标题", @"");
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // rgba(176, 169, 194, 1)
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_cancelButton setTitleColor:[UIColor colorWith255R:176 g:169 b:194] forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // rgba(255, 120, 253, 1)
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_doneButton setTitleColor:[UIColor doubleFishTintColor] forState:UIControlStateNormal];
    [_doneButton setTitle:NSLocalizedString(@"完成", @"") forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_backgroundView_c];
    [self addSubview:_animateView];
    [_animateView addSubview:_contentView_c];
    [_contentView_c addSubview:_viewTitleText];
    [_contentView_c addSubview:_cancelButton];
    [_contentView_c addSubview:_doneButton];
    
    [_backgroundView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGSize csize = CGSizeMake(0, 445.0*kWidthScale);
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_animateView.mas_width);
        make.height.equalTo(@(csize.height));
        make.centerX.equalTo(_animateView.mas_centerX);
        make.bottom.equalTo(_animateView.mas_bottom);
    }];
    
    [_viewTitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_contentView_c.mas_width).multipliedBy(0.6);
        make.height.equalTo(@(30.0*kWidthScale));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.top.equalTo(_contentView_c.mas_top).offset(kUIPadding);
    }];
    
    CGSize btnsize = CGSizeMake(30.0*kWidthScale, 20.0*kWidthScale);
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(btnsize));
        make.centerY.equalTo(_viewTitleText.mas_centerY);
        make.left.equalTo(_contentView_c.mas_left).offset(kUIPadding);
    }];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(btnsize));
        make.centerY.equalTo(_viewTitleText.mas_centerY);
        make.right.equalTo(_contentView_c.mas_right).offset(-kUIPadding);
    }];
    
}

// MARK: - 视图交互事件

- (void)cancelButtonAction:(UIButton *)sender {
    [self dismiss];
}

- (void)doneButtonAction:(UIButton *)sender {
    
}


@end
