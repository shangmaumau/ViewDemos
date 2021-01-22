//
//  KXWgGameResultShareView.m
//  kxGame
//
//  Created by Michael on 2021/1/6.
//

#import "KXWgGameResultShareView.h"
#import "KXWgGameResultView.h"
#import "SMMCategories.h"


@interface KXWgGameResultShareView ()

@property (nonatomic, strong) UIImageView *contentView_c;

@property (nonatomic, strong) UIImageView *gameTitleIcon;
@property (nonatomic, strong) KXWgGameResultUserView *leftUserView;
@property (nonatomic, strong) KXWgGameResultUserView *rightUserView;
@property (nonatomic, strong) UIImageView *vsIconImage;
@property (nonatomic, strong) UIImageView *qrCodeView;
@property (nonatomic, strong) UILabel *qrCodeText;

@property (nonatomic, copy) void (^callback)(void);

@end

@implementation KXWgGameResultShareView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addCustomViews];
    }
    return self;
}

- (void)setHideCallback:(void (^)(void))callback {
    _callback = callback;
}

- (void)addCustomViews {
    
    _contentView_c = [UIImageView new];
    _contentView_c.contentMode = UIViewContentModeScaleAspectFit;
    _contentView_c.image = [UIImage imageNamed:@"wg_settle_share_bg"];
    
    _gameTitleIcon = [UIImageView new];
    _gameTitleIcon.contentMode = UIViewContentModeScaleAspectFit;
    _gameTitleIcon.image = [UIImage imageNamed:@"wg_settle_share_title_icon"];
    
    _leftUserView = [KXWgGameResultUserView new];
    _rightUserView = [KXWgGameResultUserView new];
    _vsIconImage = [UIImageView new];
    _vsIconImage.contentMode = UIViewContentModeScaleAspectFit;
    _vsIconImage.image = [UIImage imageNamed:@"wg_settle_vs_icon"];
    
    _qrCodeView = [UIImageView new];
    _qrCodeView.contentMode = UIViewContentModeScaleAspectFit;
    _qrCodeView.image = [UIImage imageNamed:@"draw_code_imgV"];
    
    _qrCodeText = [UILabel new];
    _qrCodeText.textAlignment = NSTextAlignmentCenter;
    _qrCodeText.font = [UIFont systemFontOfSize:13.0];
    _qrCodeText.text = NSLocalizedString(@"扫描二维码，跟我一起玩真爱桌球吧！", @"");
    _qrCodeText.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.48];
    
    [self addSubview:_contentView_c];
    
    [_contentView_c addSubview:_gameTitleIcon];
    [_contentView_c addSubview:_vsIconImage];
    [_contentView_c addSubview:_leftUserView];
    [_contentView_c addSubview:_rightUserView];
    [_contentView_c addSubview:_qrCodeView];
    [_contentView_c addSubview:_qrCodeText];
    
    CGFloat u_width = 90.0*kWidthScale;
    CGFloat u_height = 130.0*kWidthScale;
    
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_gameTitleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(218.5*kWidthScale));
        make.height.equalTo(@(103.0*kWidthScale));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.top.equalTo(_contentView_c.mas_top);
    }];
    
    [_leftUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(u_width));
        make.height.equalTo(@(u_height));
        make.top.equalTo(_gameTitleIcon.mas_bottom).offset(-kUIPadding * 2.0);
        make.right.equalTo(_contentView_c.mas_centerX).offset(-kUIPadding * 2.0);
    }];
    
    [_rightUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(u_width));
        make.height.equalTo(@(u_height));
        make.top.equalTo(_gameTitleIcon.mas_bottom).offset(-kUIPadding * 2.0);
        make.left.equalTo(_contentView_c.mas_centerX).offset(kUIPadding * 2.0);
    }];
    
    [_vsIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(122.5*kWidthScale));
        make.height.equalTo(@(44.5*kWidthScale));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.centerY.equalTo(_leftUserView.mas_centerY).offset(kUIPadding);
    }];
    
    [_qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(62.5*kWidthScale, 62.5*kWidthScale)));;
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.top.equalTo(_leftUserView.mas_bottom).offset(2.0*kUIPadding);
    }];
    
    [_qrCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_contentView_c.mas_width);
        make.height.equalTo(@(kUIPadding));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.top.equalTo(_qrCodeView.mas_bottom).offset(kUIPadding/2.0);
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)updateWithUserList:(NSArray<KXWgPlayerUserModel *> *)userList {
    
    if (userList.count != 2) {
        return;
    }
    
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
    
    KXWgPlayerUserModel *model0 = nil;
    KXWgPlayerUserModel *model1 = nil;
    
    if (isMeInRound) {
        model0 = userList[meIndex];
        model1 = [userList anotherObjectOf:meIndex];
        // 改变昵称的颜色
        [_leftUserView showAsMyself];
    } else {
        model0 = userList[0];
        model1 = userList[1];
    }
    
    [_leftUserView updateInfoWithModel:model0];
    [_rightUserView updateInfoWithModel:model1];
}

- (void)showInView:(__kindof UIView *)view {
    
    [view addSubview:self];
    _contentView_c.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self->_contentView_c.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)hide {
    
    if (_callback) {
        _callback();
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self->_contentView_c.transform = CGAffineTransformMakeScale(0.4, 0.4);
        self->_contentView_c.alpha = 0;
    } completion:^(BOOL finished) {
        self->_contentView_c.alpha = 1;
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    printf("dealloc -- KXWgGameResultShareView");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
