//
//  SYMeInfoBasePopView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMeInfoBasePopView : UIView

@property (nonatomic, strong) UIView *backgroundView_c;
@property (nonatomic, strong) UIView *animateView;
/// 默认高度 445.0，在子类中根据需要使用 `mas_updateConstraints` 来修改高度。
@property (nonatomic, strong) UIView *contentView_c;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UILabel *viewTitleText;

- (void)showOnView:(__kindof UIView *)view;
- (void)dismiss;

- (void)cancelButtonAction:(UIButton *)sender;
- (void)doneButtonAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
