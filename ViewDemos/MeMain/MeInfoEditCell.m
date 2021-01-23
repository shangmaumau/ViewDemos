//
//  MeInfoEditCell.m
//  ViewDemos
//
//  Created by sam chojine on 2021/1/23.
//

#import "MeInfoEditCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+EasyMethods.h"

@implementation MeInfoEditCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return  self;
}

- (void)configUI {
    
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.headImageV];
    [self.contentView addSubview:self.arrowImageV];
    [self.contentView addSubview:self.separator];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@5);
        make.height.equalTo(@10);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageV.mas_left).offset(-13);
        make.centerY.equalTo(self.mas_centerY);
    }];
 
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@-14);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageV.mas_left).offset(-13);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@65);
    }];
    
}


- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#200D56"];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#B0A9C2"];
    }
    return _subTitleLabel;
}

- (UILabel *)valueLabel {
    
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        _valueLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _valueLabel.textColor =  [UIColor colorWithHexString:@"#B0A9C2"];;
    }
    return _valueLabel;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor colorWithHexString:@"#B0A9C2"];
    }
    return _separator;
}

- (UIImageView *)headImageV {
    
    if (!_headImageV) {
        _headImageV = [UIImageView new];
        _headImageV.backgroundColor = UIColor.redColor;
        _headImageV.contentMode = UIViewContentModeScaleAspectFill;
        _headImageV.layer.cornerRadius = 65/2;
        _headImageV.clipsToBounds = YES;
        _headImageV.hidden = YES;
    }
    return _headImageV;
}


- (UIImageView *)arrowImageV {
    
    if (!_arrowImageV) {
        _arrowImageV = [UIImageView new];
        _arrowImageV.image = [UIImage imageNamed:@"sy_userinfo_arrow_icon"];
    }
    return _arrowImageV;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
