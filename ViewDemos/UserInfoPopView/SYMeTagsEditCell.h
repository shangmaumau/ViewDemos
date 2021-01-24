//
//  SYMeTagsEditCell.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class MeTagsRowModel;

@interface SYMeTagsEditCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *subtitleText;
@property (nonatomic, strong) UIView *seperatorLine;

@property (nonatomic, strong) MeTagsRowModel *model;

- (void)updateContentWithModel:(MeTagsRowModel *)model;

@end

NS_ASSUME_NONNULL_END
