//
//  SYMeTagsEditHeaderView.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/24.
//

#import "SYMeTagsEditHeaderView.h"
#import "SMMUILayoutCategories.h"
#import "SYMeTagsEditViewCtrl.h"

@implementation SYMeTagsEditHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _configSubviews];
    }
    return self;
}

- (void)_configSubviews {
    
    _iconImage = [UIImageView new];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleText = [UILabel new];
    _titleText.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    _titleText.textColor = [UIColor doubleFishThemeColor];
    
    _subtitleText = [UILabel new];
    _subtitleText.font = [UIFont systemFontOfSize:12.0];
    _subtitleText.textColor = [UIColor doubleFishTextGrayColor];
    
    [self addSubview:_iconImage];
    [self addSubview:_titleText];
    [self addSubview:_subtitleText];
    
    CGSize iconsize = CGSizeMake(22.0*kWidthScale, 22.0*kWidthScale);
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(iconsize));
        make.left.equalTo(self.mas_left).offset(10.0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImage.mas_right).offset(kUIPaddingHalf/2.0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_subtitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleText.mas_right).offset(kUIPaddingHalf/2.0).priority(500);
        make.right.equalTo(self.mas_right).offset(-kUIPadding).priority(250);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)updateContentWithModel:(MeTagsSectionModel *)model {
    _model = model;
    
    _iconImage.image = [UIImage imageNamed:model.iconName];
    _titleText.text = model.title;
    _subtitleText.text = model.subtitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
