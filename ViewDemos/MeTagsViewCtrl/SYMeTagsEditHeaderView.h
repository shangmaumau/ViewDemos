//
//  SYMeTagsEditHeaderView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MeTagsSectionModel;

@interface SYMeTagsEditHeaderView : UIView

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *subtitleText;

@property (nonatomic, strong) MeTagsSectionModel *model;

- (void)updateContentWithModel:(MeTagsSectionModel *)model;

@end

NS_ASSUME_NONNULL_END
