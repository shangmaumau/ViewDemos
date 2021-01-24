//
//  SYUserInfoEditPopView.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "SYUserInfoEditPopView.h"
#import "SYPopSearchView.h"

#import "SMMUILayoutCategories.h"

#import "SYLocalJSONManager.h"
#import "DFCityDataModels.h"
#import "DFProfDataModels.h"

@implementation SYUserInfoEditPopModel

- (instancetype)init {
    if (self = [super init]) {
        
        _viewTitle = NSLocalizedString(@"视图标题", @"");
        _title = NSLocalizedString(@"我是大标题", @"");
        _subtitle = NSLocalizedString(@"我是小标题", @"");
        _cancelTitle = NSLocalizedString(@"取消", @"");
        _doneTitle = NSLocalizedString(@"完成", @"");

        _contentType = PopContentTypePickerView;
        _viewName = PopViewNameNull;
        _titleMode = PopTitleModeNormal;
        
        _recoveryData = @"";
        
    }
    return self;
}

@end

@interface UserInfoBirthdayView : UIView

@property (nonatomic, strong) UIButton *ageButton;
@property (nonatomic, strong) UIButton *cslaButton;

- (void)updateContentWithDate:(NSDate *)newDate;

@end

@implementation UserInfoBirthdayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _configBasicSubviews];
    }
    return self;
}

- (void)_configBasicSubviews {
    
    _ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ageButton.userInteractionEnabled = NO;
    _ageButton.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    _ageButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_ageButton setTitleColor:[UIColor colorWith255R:99 g:85 b:136] forState:UIControlStateNormal];
    _ageButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8.0);
    [_ageButton setImage:[UIImage imageNamed:@"sy_userinfo_birthday_icon"] forState:UIControlStateNormal];
    
    _cslaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cslaButton.userInteractionEnabled = NO;
    _cslaButton.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    _cslaButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_cslaButton setTitleColor:[UIColor colorWith255R:99 g:85 b:136] forState:UIControlStateNormal];
    _cslaButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8.0);
    [_cslaButton setImage:[UIImage imageNamed:@"sy_userinfo_cons_icon"] forState:UIControlStateNormal];
    
    [self addSubview:_ageButton];
    [self addSubview:_cslaButton];
    
    [_ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
    }];
    
    [_cslaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.mas_height);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)updateContentWithDate:(NSDate *)newDate {
    
    dispatch_queue_t cur = dispatch_queue_create("com.doubleFishes.handleDate", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(cur, ^{
        // 下面两个方法需要一定时间，如不异步处理，会有卡顿
        NSString *cslaString = [UserInfoBirthdayView constellationStringFromDate:newDate];
        NSInteger age = [UserInfoBirthdayView ageFromBirthday:newDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (cslaString != nil) {
                [self->_cslaButton setTitle:cslaString forState:UIControlStateNormal];
            }
            if (age > 0) {
                [self->_ageButton setTitle:[NSString stringWithFormat:@"%d岁", (int)age] forState:UIControlStateNormal];
            }
        });
    });
}

+ (NSInteger)ageFromBirthday:(NSDate *)birthday {
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *deltaDate = [calendar components:unitFlags fromDate:birthday toDate:nowDate options:0];
    
    return [deltaDate year];
}

+ (NSString * _Nullable)constellationStringFromDate:(NSDate *)date {
    
    NSUInteger month = 0;
    NSUInteger day = 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComp = [calendar components:unitFlags fromDate:date];
    
    month = [dateComp month];
    day = [dateComp day];
    
    if (month < 1 || month > 12 || day < 1 || day > 31) {
        return nil;
    }
    if (month == 2 && day > 29) {
        return nil;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        if (day > 30) {
            return nil;
        }
    }
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102223444433";
    return [NSString stringWithFormat:@"%@座", [astroString substringWithRange:NSMakeRange(month * 2 - (day < [[astroFormat substringWithRange:NSMakeRange((month - 1), 1)] intValue] - (-19)) * 2, 2)]];
}

@end

@interface SYUserInfoEditPopView ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, PopSearchViewDelegate> {
    NSUInteger _firstRowIdx;
    NSUInteger _secondRowIdx;
    NSUInteger _thirdRowIdx;
    
    CGFloat _contentTopMargin;
    
    CGFloat _keyboardOffset;
    BOOL _keyboardIsShowing;
}

@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *subtitleText;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) SYPopSearchView *searchView;
@property (nonatomic, strong) UserInfoBirthdayView *birthdayView;

@property (nonatomic, strong) __kindof UIView *contentView;
@property (nonatomic, strong) __kindof UIView *contentBeginView;

@property (nonatomic, strong) SYUserInfoEditPopModel *lastModel;
@property (nonatomic, strong) NSArray *pickerData;

@property (nonatomic, strong) id inputData;

@property (nonatomic, copy) void (^doneCallback)(id data);

@end

@implementation SYUserInfoEditPopView

// MARK: - 公开方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _resetPickerIndices];
        [self _configBasicSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)showOnView:(__kindof UIView *)view withData:(SYUserInfoEditPopModel *)data {
    
    if (!data) {
        return;
    }
    
    [super showOnView:view];
    
    [self _resetPickerIndices];
    [self _updateModel:data];
    [self _configPickerData];
    
    [self _configTitleView];
    [self _configContentBeginView];
    [self _configContentView];
    [self _recoveryContentData];

    [self updateConstraintsIfNeeded];
    
    [self _updateTitleText];
}

- (void)dismiss {
    
    if (_keyboardIsShowing) {
        [_contentView resignFirstResponder];
        _keyboardIsShowing = NO;
    }
    
    [super dismiss];
}

- (void)configDoneCallback:(void (^)(id _Nullable))callback {
    _doneCallback = callback;
}

// MARK: - 视图交互事件

- (void)cancelButtonAction:(UIButton *)sender {
 
    [self dismiss];
}

- (void)doneButtonAction:(UIButton *)sender {
    
    [self _configDoneData];
    
    if (_doneCallback) {
        _doneCallback(_inputData);
    }
    [self dismiss];
}

- (void)__datePickerValueDidChange:(UIDatePicker *)picker {
    _inputData = picker.date;
    [_birthdayView updateContentWithDate:picker.date];
}

- (void)__textFieldTextDidChange:(UITextField *)tf {
    
    UITextRange *selectedRange = [tf markedTextRange];
    // 获取高亮部分
    UITextPosition *position = [tf positionFromPosition:selectedRange.start offset:0];
    
    if (!position) {
        _inputData = tf.text;
    }
}


- (void)__keyboardWillShow:(NSNotification *)notif {
    
    CGRect krect = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    krect = [self convertRect:krect fromView:self.window];
    
    CGRect crect = [self convertRect:_contentView.frame fromView:self.contentView_c];
    
    // 键盘在内容之上
    if (CGRectGetMinY(krect) < CGRectGetMaxY(crect)) {
        CGFloat gap = CGRectGetMinY(krect) - CGRectGetMaxY(crect) - 16.0;
        CGRect newFrame = CGRectAddY(gap, self.animateView.frame);
        
        [UIView animateWithDuration:0.25 delay:0 options:(7 << 16) animations:^{
            self.animateView.frame = newFrame;
        } completion:^(BOOL finished) {
            self->_keyboardIsShowing = YES;
            [self.contentView_c updateConstraintsIfNeeded];
        }];
    }
}

- (void)__keyboardWillHide:(NSNotification *)notif {
    CGRect newFrame = CGRectNewY(0, self.animateView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:(7 << 16) animations:^{
        self.animateView.frame = newFrame;
    } completion:^(BOOL finished) {
        self->_keyboardIsShowing = NO;
        [self.contentView_c updateConstraintsIfNeeded];
    }];
}

// MARK: - 添加移除功能视图

- (void)_addTitleViews {
    
    _titleText = [UILabel new];
    _titleText.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium];
    _titleText.textColor = [UIColor doubleFishThemeColor];
    
    _subtitleText = [UILabel new];
    _subtitleText.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    // rgba(99, 85, 136, 1)
    _subtitleText.textColor = [UIColor colorWith255R:99.0 g:85.0 b:136.0];
    
    [self.contentView_c addSubview:_titleText];
    [self.contentView_c addSubview:_subtitleText];
    
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30.0*kWidthScale));
        make.top.equalTo(self.viewTitleText.mas_bottom).offset(30.0);
        make.left.equalTo(self.contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(self.contentView_c.mas_right).offset(-kUIPadding);
    }];
    
    [_subtitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20.0*kWidthScale));
        make.top.equalTo(_titleText.mas_bottom).offset(2.0);
        make.left.equalTo(self.contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(self.contentView_c.mas_right).offset(-kUIPadding);
    }];
}

- (void)_removeTitleViews {
    [_titleText removeFromSuperview];
    [_subtitleText removeFromSuperview];
    _titleText = nil;
    _subtitleText = nil;
}

- (void)_addBirthdayAddView {
    
    _birthdayView = [UserInfoBirthdayView new];
    _birthdayView.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.04];
    _birthdayView.layer.cornerRadius = 8.0;
    [self.contentView_c addSubview:_birthdayView];
    
    CGSize bsize = CGSizeMake(0, 51.5*kWidthScale);
    [_birthdayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(bsize.height));
        make.top.equalTo(_contentBeginView.mas_bottom).offset(24.0);
        make.left.equalTo(self.contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(self.contentView_c.mas_right).offset(-kUIPadding);
    }];
}

- (void)_removeBirthdayAddView {
    [_birthdayView removeFromSuperview];
    _birthdayView = nil;
}

// MARK: - 配置视图

- (void)_configBasicSubviews {
    
    CGSize csize = CGSizeMake(0, 445.0*kWidthScale);
    [self.contentView_c mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(csize.height));
    }];
}

- (void)_configTitleView {
    
    if ([self isTitleViewStay]) {
        return;
    }
    
    switch (_model.titleMode) {
            
        case PopTitleModeNull: {
            [self _removeTitleViews];
            CGSize csize = CGSizeMake(0, 261.0*kWidthScale);
            [self.contentView_c mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(csize.height));
            }];
        }
            break;
            
        case PopTitleModeNormal: {
            [self _addTitleViews];
            CGSize csize = CGSizeMake(0, 445.0*kWidthScale);
            [self.contentView_c mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(csize.height));
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)_configContentBeginView {
    
    switch (_model.titleMode) {
        case PopTitleModeNull:
            _contentBeginView = self.viewTitleText;
            break;
            
        case PopTitleModeNormal:
            _contentBeginView = _subtitleText;
            break;
            
        default:
            break;
    }
}

- (void)_configContentView {
    
    if ([self isContentViewStay]) {
        return;
    }
    
    [self _removeBirthdayAddView];
    
    [_contentView removeFromSuperview];
    _contentView = [self gimmeContentView];
    // 测试查看 位置
    // _contentView.backgroundColor = [UIColor systemGrayColor];
    [self.contentView_c addSubview:_contentView];
    
    CGSize csize = CGSizeMake(0, 210.0*kWidthScale);
    CGFloat leftPad = kUIPadding;
    CGFloat rightPad = kUIPadding;
    CGFloat topMargin = 24.0;
    BOOL isPickerType = YES;
    
    switch (_model.contentType) {
        case PopContentTypePickerView:
        {
            _pickerView = _contentView;
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            
            leftPad = 0;
            rightPad = 0;
            topMargin = 0;
        }
            break;
            
        case PopContentTypeDatePicker:
        {
            _datePicker = _contentView;
            [_datePicker addTarget:self action:@selector(__datePickerValueDidChange:) forControlEvents:UIControlEventValueChanged];
            
            if (_model.viewName == PopViewNameBirthday) {
                [self _addBirthdayAddView];
                _contentBeginView = _birthdayView;
            }
            
            leftPad = 0;
            rightPad = 0;
            topMargin = 0;
        }
            break;
            
        case PopContentTypeTextField:
        {
            _textField = _contentView;
            [_textField addTarget:self action:@selector(__textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            csize.height = 51.5*kWidthScale;
            isPickerType = NO;
        }
            break;
            
        case PopContentTypeTextView:
        {
            _textView = _contentView;
            _textView.delegate = self;
            
            csize.height = 96.5*kWidthScale;
            isPickerType = NO;
        }
            break;
            
        case PopContentTypeSearchView:
        {
            _searchView = _contentView;
            _searchView.delegate = self;
            
            if (_model.dataSource.count > 0) {
                [_searchView configDataSource:_model.dataSource];
            }
            
            csize.height = 261.5*kWidthScale;
            isPickerType = NO;
        }
            break;
            
        default:
            break;
    }
    
    _contentTopMargin = topMargin;
    
    if (isPickerType) {
        
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView_c.mas_safeAreaLayoutGuideBottom).offset(0);
            make.top.equalTo(_contentBeginView.mas_bottom).offset(topMargin);
            make.left.equalTo(self.contentView_c.mas_left).offset(leftPad);
            make.right.equalTo(self.contentView_c.mas_right).offset(-rightPad);
        }];
        
    } else {
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(csize.height));
            make.top.equalTo(_contentBeginView.mas_bottom).offset(topMargin);
            make.left.equalTo(self.contentView_c.mas_left).offset(leftPad);
            make.right.equalTo(self.contentView_c.mas_right).offset(-rightPad);
        }];
    }
}

// MARK: - 配置和更新数据

- (void)_resetPickerIndices {
    _firstRowIdx = 0;
    _secondRowIdx = 0;
    _thirdRowIdx = 0;
}

- (void)_updateModel:(SYUserInfoEditPopModel *)model {
    _lastModel = _model;
    _model = model;
}

- (void)_configPickerData {
    switch (_model.viewName) {
        case PopViewNameAddress:
            _pickerData = [SYLocalJSONManager cities];
            break;
            
        case PopViewNameProfession:
            _pickerData = [SYLocalJSONManager profs];
            break;
            
        case PopViewNameGender:
            _pickerData = @[ NSLocalizedString(@"男", @""), NSLocalizedString(@"女", @"") ];
            break;
            
        case PopViewNameUniversity:
            /// 稍后会在配置内容视图的时候，从中获取
            _model.dataSource = [SYLocalJSONManager universities_name];
            break;
            
        default:
            _pickerData = _model.dataSource;
            break;
    }
}

- (void)_configDoneData {
    
    switch (_model.contentType) {
        case PopContentTypePickerView: {
            // 根据不同情况来处理
            
            switch (_model.viewName) {
                case PopViewNameAddress:
                {
                    DFCityBaseModel *baseModel = _pickerData[_firstRowIdx];
                    DFCityCityModel *cityModel = baseModel.sub[_secondRowIdx];
                    NSString *districtName = (NSString *)[cityModel.sub[_thirdRowIdx] valueForKey:@"name"];
                    
                    _inputData = [NSString stringWithFormat:@"%@ %@ %@", baseModel.name, cityModel.name, districtName];
                }
                    break;
                
                case PopViewNameProfession:
                {
                    DFProfBaseModel *baseModel = _pickerData[_firstRowIdx];
                    DFProfModel *profModel = baseModel.sub[_secondRowIdx];
                    _inputData = [NSString stringWithFormat:@"%@ %@", baseModel.name, profModel.name];
                }
                    
                default:
                    
                    _inputData = _pickerData[_firstRowIdx];
                    
                    break;
            }
            
        } break;
            
            // 下面四个已经处理
        case PopContentTypeDatePicker:
            break;
            
        case PopContentTypeTextField:
            break;
            
        case PopContentTypeTextView:
            break;
            
        case PopContentTypeSearchView:
            break;
            
        default:
            break;
    }
}

- (void)_recoveryContentData {
    
    switch (_model.contentType) {
        case PopContentTypePickerView:
            
            break;
            
            // 下面三个已经处理
        case PopContentTypeDatePicker: {
            if ([_model.recoveryData isKindOfClass:[NSString class]]) {
                NSDateFormatter *df = [NSDateFormatter new];
                df.dateFormat = @"yyyy-MM-dd";
                
                NSDate *date = [df dateFromString:(NSString *)(_model.recoveryData)];
                if (date) {
                    _datePicker.date = date;
                    
                    if (_model.viewName == PopViewNameBirthday) {
                        [_birthdayView updateContentWithDate:date];
                    }
                    
                }
            }
        }
            break;
            
        case PopContentTypeTextField:
            _textField.text = (NSString *)(_model.recoveryData);
            break;
            
        case PopContentTypeTextView:
            _textView.text = (NSString *)(_model.recoveryData);
            break;
            
        case PopContentTypeSearchView:
            break;
            
        default:
            break;
    }
}

// MARK: - 更新界面

- (void)_updateTitleText {
    self.viewTitleText.text = _model.viewTitle;
    _titleText.text = _model.title;
    _subtitleText.text = _model.subtitle;
    
    [self.cancelButton setTitle:_model.cancelTitle forState:UIControlStateNormal];
    [self.doneButton setTitle:_model.doneTitle forState:UIControlStateNormal];
}

// MARK: - 判断是否视图不需要替换

- (BOOL)isTitleViewStay {
    if (!_lastModel) {
        return NO;
    }
    if (_lastModel.titleMode == _model.titleMode) {
        return YES;
    }
    return NO;
}

- (BOOL)isContentViewStay {
    if (!_lastModel) {
        return NO;
    }
    if (_lastModel.contentType == _model.contentType && _lastModel.viewName == _model.viewName) {
        return YES;
    }
    return NO;
}

// MARK: - 给我内容视图

- (__kindof UIView *)gimmeContentView {
    
    __kindof UIView *cv = nil;
    
    switch (_model.contentType) {
        case PopContentTypePickerView:
            cv = [self gimmePickerView];
            break;
            
        case PopContentTypeDatePicker:
            cv = [self gimmeDatePicker];
            break;
            
        case PopContentTypeTextField:
            cv = [self gimmeTextField];
            break;
            
        case PopContentTypeTextView:
            cv = [self gimmeTextView];
            break;
            
        case PopContentTypeSearchView:
            cv = [self gimmeSearchView];
            break;
            
        default:
            break;
    }
    
    return cv;
}

- (UIPickerView *)gimmePickerView {
    
    UIPickerView *view = [UIPickerView new];
    
    return view;
}

- (UIDatePicker *)gimmeDatePicker {
    
    UIDatePicker *view = [UIDatePicker new];
    if (@available(iOS 13.4, *)) {
        view.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    view.datePickerMode = UIDatePickerModeDate;
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd";
    
    view.date = [df dateFromString:@"1990-01-01"];
    view.minimumDate = [df dateFromString:@"1900-01-01"];
    view.maximumDate = [NSDate date];
    
    return view;
}

- (UITextField *)gimmeTextField {
    
    UITextField *view = [UITextField new];
    view.textColor = [UIColor doubleFishThemeColor];
    view.font = [UIFont systemFontOfSize:18.0];
    
    view.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    view.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.04];
    // rgba(255, 120, 253, 1)
    view.tintColor = [UIColor doubleFishTintColor];
    view.layer.cornerRadius = 8.0;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIPadding, kUIPadding)];
    view.leftViewMode = UITextFieldViewModeAlways;
    view.leftView = leftView;
    
    return view;
}

- (UITextView *)gimmeTextView {
    
    UITextView *view = [UITextView new];
    view.textColor = [UIColor doubleFishThemeColor];
    view.font = [UIFont systemFontOfSize:18.0];
    
    view.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.04];
    view.tintColor = [UIColor doubleFishTintColor];
    view.layer.cornerRadius = 8.0;
    
    view.textContainerInset = UIEdgeInsetsMake(11.5, 11.5, 11.5, 11.5);
    
    return view;
}

- (SYPopSearchView *)gimmeSearchView {
    SYPopSearchView *view = [SYPopSearchView new];
    [view configSearchPlaceholderText:@"请输入学校名称"];
    
    return view;
}

// MARK: - 搜索视图代理

- (void)searchView:(SYPopSearchView *)searchView willSelectRow:(NSInteger)row {
    
}

- (void)searchView:(SYPopSearchView *)searchView didSelectRow:(NSInteger)row {
    
    _inputData = _model.dataSource[row];
}

- (void)textViewDidChange:(UITextView *)textView {
    _inputData = textView.text;
}

// MARK: - 选择器数据源、代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger count = 0;
    switch (_model.viewName) {
        case PopViewNameAddress:
            count = 3;
            break;
            
        case PopViewNameProfession:
            count = 2;
            break;
            
        default:
            count = 1;
            break;
    }
    return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 31.5*kWidthScale;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger count = 0;
    
    switch (_model.viewName) {
        case PopViewNameAddress:{
            
            switch (component) {
                case 0:
                {
                    count = _pickerData.count;
                }
                    break;
                    
                case 1:
                {
                    DFCityBaseModel *baseModel = _pickerData[_firstRowIdx];
                    count =  baseModel.sub.count;
                }
                    break;
                    
                case 2:
                {
                    DFCityBaseModel *baseModel = _pickerData[_firstRowIdx];
                    DFCityCityModel *subModel = baseModel.sub[_secondRowIdx];
                    count = subModel.sub.count;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case PopViewNameProfession:{
            switch (component) {
                case 0:
                {
                    count = _pickerData.count;
                }
                    break;
                    
                case 1:
                {
                    DFProfBaseModel *baseModel = _pickerData[_firstRowIdx];
                    count =  baseModel.sub.count;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            count = _pickerData.count;
            break;
    }
    
    return count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = @"";
    
    switch (_model.viewName) {
        case PopViewNameAddress:{
            
            switch (component) {
                case 0:
                {
                    DFCityBaseModel *baseModel = _pickerData[row];
                    title = baseModel.name;
                }
                    break;
                    
                case 1:
                {
                    DFCityBaseModel *baseModel = _pickerData[_firstRowIdx];
                    DFCityCityModel *subModel = baseModel.sub[row];
                    title = subModel.name;
                }
                    break;
                    
                case 2:
                {
                    DFCityBaseModel *baseModel = _pickerData[_firstRowIdx];
                    DFCityCityModel *subModel = baseModel.sub[_secondRowIdx];
                    title = (NSString *)(subModel.sub[row][@"name"]);
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
            break;
            
        case PopViewNameProfession:{
            switch (component) {
                case 0:
                {
                    DFProfBaseModel *baseModel = _pickerData[row];
                    title = baseModel.name;
                }
                    break;
                    
                case 1:
                {
                    DFProfBaseModel *baseModel = _pickerData[_firstRowIdx];
                    DFProfModel *subModel = baseModel.sub[row];
                    title = subModel.name;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            title = (NSString *)(_pickerData[row]);
            if (![title isKindOfClass:[NSString class]]) {
                title = [[_pickerData[row] valueForKey:@"name"] stringValue];
            }
            if (![title isKindOfClass:[NSString class]]) {
                title = [[_pickerData[row] valueForKey:@"title"] stringValue];
            }
            break;
    }
    
    NSMutableAttributedString *mAttribute = [[NSMutableAttributedString alloc] initWithString:title];
    [mAttribute addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:22.0]
                       range:NSMakeRange(0, title.length)];
    [mAttribute addAttribute:NSForegroundColorAttributeName
                       value:[UIColor doubleFishThemeColor]
                       range:NSMakeRange(0, title.length)];
    
    return mAttribute;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger compCount = [pickerView numberOfComponents];
    
    switch (component) {
        case 0:
        {
            _firstRowIdx = row;
            if (compCount > 1) {
                _secondRowIdx = 0;
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                
                if (compCount > 2) {
                    _thirdRowIdx = 0;
                    [pickerView reloadComponent:2];
                    [pickerView selectRow:0 inComponent:2 animated:YES];
                }
            }
        }
            break;
            
        case 1:
        {
            _secondRowIdx = row;
            
            if (compCount > 2) {
                _thirdRowIdx = 0;
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
        }
            break;
            
        case 2:
        {
            _thirdRowIdx = row;
        }
            break;
            
        default:
            break;
    }
}

@end
