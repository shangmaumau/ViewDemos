//
//  KXWgGameResultShareView.h
//  kxGame
//
//  Created by Michael on 2021/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KXWgPlayerUserModel;

@interface KXWgGameResultShareView : UIView

- (void)updateWithUserList:(NSArray<KXWgPlayerUserModel *> *)userList;
- (void)showInView:(__kindof UIView *)view;

- (void)hide;

- (void)setHideCallback:(void (^)(void))callback;

@end

NS_ASSUME_NONNULL_END
