//
//  SYMeTagsEditCell.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/24.
//

#import "SYMeTagsEditCell.h"
#import "SMMUILayoutCategories.h"

#import "SYMeTagsEditViewCtrl.h"

@implementation SYMeTagsEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _configSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)_configSubviews {
    
    _titleText = [UILabel new];
    _titleText.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    _titleText.textColor = [UIColor doubleFishThemeColor];
    _subtitleText = [UILabel new];
    _subtitleText.textAlignment = NSTextAlignmentRight;
    _subtitleText.font = [UIFont systemFontOfSize:12.0];
    _subtitleText.textColor = [UIColor doubleFishTextGrayColor];
    
    _seperatorLine = [UIView new];
    _seperatorLine.backgroundColor = [[UIColor doubleFishTextGrayColor] colorWithAlphaComponent:0.16];

    [self.contentView addSubview:_titleText];
    [self.contentView addSubview:_subtitleText];
    [self addSubview:_seperatorLine];
    
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kUIPadding);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_subtitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kUIPaddingHalf);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.mas_left).offset(kUIPadding);
        make.right.equalTo(self.mas_right).offset(-kUIPadding);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)updateContentWithModel:(MeTagsRowModel *)model {
    _model = model;
    
    _titleText.text = model.title;
    _subtitleText.text = model.subtitle;
}

@end
