//
//  KXWgGameResultView.h
//  kxGame
//
//  Created by Michael on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DGWgGamePos) {
    DGWgGamePosLiveRoom,
    DGWgGamePosGame
};

@interface KXWgPlayerUserModel : NSObject

@property (nonatomic, strong) NSString *headPortraitUrl;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSUInteger sex;
@property (nonatomic, assign) NSUInteger winState;

- (BOOL)isSelf;

@end

@interface KXWgGameResultUserView : UIView
- (void)updateInfoWithModel:(KXWgPlayerUserModel *)model;
- (void)showAsMyself;
- (void)showLittleWinLoseIcon;
- (void)hideLittleWinLoseIcon;
@end

@class KXWgGameResultView;
@protocol KXWgGameResultViewDelegate <NSObject>
@optional
- (void)gameResultView:(KXWgGameResultView *)settleView shareButtonAction:(UIButton *)sender;
@end

@interface KXWgGameResultView : UIView
@property (nonatomic, weak) id<KXWgGameResultViewDelegate> delegate;
@property (nonatomic, assign) DGWgGamePos gameType;

- (instancetype)initWithFrame:(CGRect)frame andGameType:(DGWgGamePos)type;
- (void)showInView:(__kindof UIView *)view userList:(NSArray<KXWgPlayerUserModel *> *)userList;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
