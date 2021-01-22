//
//  KXWgGameResultView.m
//  kxGame
//
//  Created by Michael on 2021/1/5.
//

#import "KXWgGameResultView.h"
#import "SMMCategories.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KXWgGameResultUserView ()

@property (nonatomic, strong) UIImageView *winloseIcon;
@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UIButton *genderAndNameButton;

@end

@implementation KXWgGameResultUserView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addCustomViews];
    }
    return self;
}

- (void)layoutSubviews {
    _avatarImage.layer.cornerRadius = 60.0*kWidthScale / 2.0;
    _avatarImage.layer.masksToBounds = YES;
}

- (void)addCustomViews {
    
    _winloseIcon = [UIImageView new];
    _winloseIcon.contentMode = UIViewContentModeScaleAspectFit;
    _winloseIcon.hidden = YES;
    
    _avatarImage = [UIImageView new];
    _avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _genderAndNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _genderAndNameButton.userInteractionEnabled = NO;
    _genderAndNameButton.titleLabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium];
    _genderAndNameButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_genderAndNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 图片右侧留点间隙
    _genderAndNameButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4.0);
    
    [self addSubview:_winloseIcon];
    [self addSubview:_avatarImage];
    [self addSubview:_genderAndNameButton];
    
    [_winloseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(57.0*kWidthScale));
        make.height.equalTo(@(32.0*kWidthScale));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
    }];
    
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(60.0*kWidthScale, 60.0*kWidthScale)));
        make.top.equalTo(_winloseIcon.mas_bottom).offset(kUIPadding);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_genderAndNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(-kUIPaddingHalf/2.0);
        make.right.equalTo(self.mas_right).offset(kUIPaddingHalf/2.0);
        make.top.equalTo(_avatarImage.mas_bottom).offset(kUIPaddingHalf);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)showLittleWinLoseIcon {
    _winloseIcon.hidden = NO;
}

- (void)hideLittleWinLoseIcon {
    _winloseIcon.hidden = YES;
}

- (void)showAsMyself {
    UIColor *meNameColor = [UIColor colorWith255R:255.0 g:243.0 b:86.0];
    [_genderAndNameButton setTitleColor:meNameColor forState:UIControlStateNormal];
}

- (void)updateInfoWithModel:(KXWgPlayerUserModel *)model {
    
    NSString *url = model.headPortraitUrl;
    NSString *name = model.nickName;
    BOOL isBoy = (model.sex == 1);
    BOOL isWin = (model.winState == 1);
    
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    [_genderAndNameButton setTitle:name forState:UIControlStateNormal];
    
    if (isBoy) {
        [_genderAndNameButton setImage:[UIImage imageNamed:@"wg_settle_male_icon"] forState:UIControlStateNormal];
    } else {
        [_genderAndNameButton setImage:[UIImage imageNamed:@"wg_settle_female_icon"] forState:UIControlStateNormal];
    }
    
    if (isWin) {
        _winloseIcon.image = [UIImage imageNamed:@"wg_settle_littlewin_icon"];
    } else {
        _winloseIcon.image = [UIImage imageNamed:@"wg_settle_littlelose_icon"];
    }
}

- (void)dealloc {
    printf("dealloc -- DGWgGameResultUserView");
}

@end

@interface KXWgGameResultView () {
    NSDate *_appearDate;
}

@property (nonatomic, strong) UIImageView *contentView_c;

@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) KXWgGameResultUserView *leftUserView;
@property (nonatomic, strong) KXWgGameResultUserView *rightUserView;

@property (nonatomic, strong) UIImageView *vsIconImage;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation KXWgGameResultView

- (instancetype)initWithFrame:(CGRect)frame andGameType:(DGWgGamePos)type {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWith255R:0 g:0 b:0] colorWithAlphaComponent:0.6];
        _gameType = type;
        [self addCustomViews];
        
    }
    return self;
}

- (void)addCustomViews {
    
    _contentView_c = [UIImageView new];
    _contentView_c.contentMode = UIViewContentModeScaleAspectFit;
    _contentView_c.image = [UIImage imageNamed:@"wg_settle_bg"];
    
    _faceView = [UIImageView new];
    _faceView.contentMode = UIViewContentModeScaleAspectFit;
    
    _vsIconImage = [UIImageView new];
    _vsIconImage.contentMode = UIViewContentModeScaleAspectFit;
    _vsIconImage.image = [UIImage imageNamed:@"wg_settle_vs_icon"];
    
    _leftUserView = [KXWgGameResultUserView new];
    _rightUserView = [KXWgGameResultUserView new];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"wg_settle_close_btn"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *shareButtonImageName = @"wg_settle_share_btn";
    if (_gameType == DGWgGamePosLiveRoom) {
        shareButtonImageName = @"wg_settle_onemore_btn";
    }
    
    [_shareButton setImage:[UIImage imageNamed:shareButtonImageName] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_contentView_c];
    
    [_contentView_c addSubview:_faceView];
    [_contentView_c addSubview:_vsIconImage];
    [_contentView_c addSubview:_leftUserView];
    [_contentView_c addSubview:_rightUserView];
    [_contentView_c addSubview:_closeButton];
    [_contentView_c addSubview:_shareButton];
    
    CGFloat c_width = 278.0*kWidthScale;
    CGFloat c_height = 201.5*kWidthScale;
    
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(c_width));
        make.height.equalTo(@(c_height));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(265.5*kWidthScale));
        make.height.equalTo(@(152.0*kWidthScale));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.centerY.equalTo(_contentView_c.mas_top);
    }];
    
    [_vsIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(122.5*kWidthScale));
        make.height.equalTo(@(44.5*kWidthScale));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.centerY.equalTo(_contentView_c.mas_centerY).offset(kUIPaddingHalf);
    }];
    
    [_leftUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(90.0*kWidthScale));
        make.height.equalTo(@(130.0*kWidthScale));
        make.centerY.equalTo(_contentView_c.mas_centerY).offset(-kUIPaddingHalf);
        make.right.equalTo(_contentView_c.mas_centerX).offset(-kUIPadding*2.0);
    }];
    
    [_rightUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(90.0*kWidthScale));
        make.height.equalTo(@(130.0*kWidthScale));
        make.centerY.equalTo(_contentView_c.mas_centerY).offset(-kUIPaddingHalf);
        make.left.equalTo(_contentView_c.mas_centerX).offset(kUIPadding*2.0);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(118.0*kWidthScale));
        make.height.equalTo(@(44.5*kWidthScale));
        make.top.equalTo(_contentView_c.mas_bottom).offset(19.0);
        make.right.equalTo(_contentView_c.mas_centerX).offset(-12.0);
    }];
    
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(118.0*kWidthScale));
        make.height.equalTo(@(44.5*kWidthScale));
        make.top.equalTo(_contentView_c.mas_bottom).offset(19.0);
        make.left.equalTo(_contentView_c.mas_centerX).offset(12.0);
    }];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (__kindof UIView *view in _contentView_c.subviews) {
        CGPoint viewP = [self convertPoint:point toView:view];
        if ([view isEqual:_shareButton] && [view pointInside:viewP withEvent:event]) {
            return view;
        }
        if ([view isEqual:_closeButton] && [view pointInside:viewP withEvent:event]) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)closeButtonAction:(UIButton *)sender {
    [self hide];
    if (_gameType == DGWgGamePosLiveRoom) {
//        [KXNiuDataTool ami_clickWtihCode:@"close_button_clcik" eventName:@"关闭按钮点击" extendParameter:[self niushuDict]];
    }
}

- (void)shareButtonAction:(UIButton *)sender {
    [self hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameResultView:shareButtonAction:)]) {
        [self.delegate gameResultView:self shareButtonAction:sender];
    }
    if (_gameType == DGWgGamePosLiveRoom) {
//        [KXNiuDataTool ami_clickWtihCode:@"one_more_game_click" eventName:@"再来一局按钮点击" extendParameter:[self niushuDict]];
    }
}

- (void)showInView:(__kindof UIView *)view userList:(nonnull NSArray<KXWgPlayerUserModel *> *)userList {
    
    if (userList.count != 2) {
        return;
    }
    
    [view addSubview:self];
    _contentView_c.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self->_contentView_c.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
    
//    if (_gameType == DGWgGamePosLiveRoom) {
//        _appearDate = [NSDate kx_date];
//    }
    
    /// 当前用户是否在局内
    BOOL isMeInRound = NO;
    NSInteger meIndex = -1;
    
    for (NSUInteger i = 0; i < userList.count; i++) {
        if (userList[i].isSelf) {
            isMeInRound = YES;
            meIndex = i;
            break;
        }
    }
    
    [self resetBottomButtonsLayout];
    
    KXWgPlayerUserModel *model0 = nil;
    KXWgPlayerUserModel *model1 = nil;
    
    if (isMeInRound) {
        model0 = userList[meIndex];
        model1 = [userList anotherObjectOf:meIndex];
        _faceView.hidden = NO;
        [_leftUserView hideLittleWinLoseIcon];
        [_rightUserView hideLittleWinLoseIcon];
        
        switch (model0.winState) {
            case 1: _faceView.image = [UIImage imageNamed:@"wg_settle_win_icon"];
                break;
            case 2: _faceView.image = [UIImage imageNamed:@"wg_settle_lose_icon"];
                break;
        }
        // 改变昵称的颜色
        [_leftUserView showAsMyself];
        
    } else {
        _faceView.hidden = YES;
        [_leftUserView showLittleWinLoseIcon];
        [_rightUserView showLittleWinLoseIcon];
        
        // 直播间：第三方视角要隐藏再来一局按钮
        if (_gameType == DGWgGamePosLiveRoom) {
            _shareButton.hidden = YES;
            [_closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(118.0*kWidthScale));
                make.height.equalTo(@(44.5*kWidthScale));
                make.top.equalTo(_contentView_c.mas_bottom).offset(19.0);
                make.centerX.equalTo(_contentView_c.mas_centerX);
            }];
            [_contentView_c updateConstraintsIfNeeded];
        }
        
        model0 = userList[0];
        model1 = userList[1];
    }
    
    [_leftUserView updateInfoWithModel:model0];
    [_rightUserView updateInfoWithModel:model1];
    
}

/// 重置底部按钮布局，在多种切换里面，有用。
- (void)resetBottomButtonsLayout {
    
    _closeButton.hidden = NO;
    _shareButton.hidden = NO;
    
    [_closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(118.0*kWidthScale));
        make.height.equalTo(@(44.5*kWidthScale));
        make.top.equalTo(_contentView_c.mas_bottom).offset(19.0);
        make.right.equalTo(_contentView_c.mas_centerX).offset(-12.0);
    }];
    
    [_shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(118.0*kWidthScale));
        make.height.equalTo(@(44.5*kWidthScale));
        make.top.equalTo(_contentView_c.mas_bottom).offset(19.0);
        make.left.equalTo(_contentView_c.mas_centerX).offset(12.0);
    }];
    
    [_contentView_c updateConstraintsIfNeeded];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self->_contentView_c.transform = CGAffineTransformMakeScale(0.4, 0.4);
        self->_contentView_c.alpha = 0;
    } completion:^(BOOL finished) {
        self->_contentView_c.alpha = 1;
        [self removeFromSuperview];
    }];
    
    if (_gameType == DGWgGamePosLiveRoom && _appearDate ) {
//        [KXNiuDataTool ami_endViewPageWtihCode:@"game_settlement_pop_click_view_page" eventName:@"游戏结算弹窗页面浏览" startViewDate:_appearDate extendParameter:[self niushuDict]];
    }
}

- (void)dealloc {
    printf("dealloc -- KXWgGameResultView");
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (NSDictionary *)niushuDict {
    return @{@"current_pageId" : @"game_settlement_pop_page", @"source_page_id" : @"live_room_page"};
}
@end
