//
//  SYMeInfoEditCell.h
//  ViewDemos
//
//  Created by sam chojine on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMeInfoEditCell : UITableViewCell

typedef NS_ENUM(NSUInteger, EditCellType) {
    /// 头像
    EditCellTypeHead,
    /// 其他
    EditCellTypeNormal
};

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UIImageView *arrowImageV;
@property (nonatomic, strong) UIImageView *headImageV;

@property (nonatomic, strong) UIView *separator;


@end

NS_ASSUME_NONNULL_END
