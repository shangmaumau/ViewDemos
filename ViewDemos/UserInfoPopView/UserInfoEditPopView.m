//
//  UserInfoEditPopView.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "UserInfoEditPopView.h"
#import <Masonry/Masonry.h>

#import "UIScreen+EasyMethods.h"
#import "UIColor+EasyMethods.h"

#import "LocalJSONManager.h"

#define kUIPadding      (16.0)
#define kUIPaddingHalf  (8.0)

#define kWidthScale     ([UIScreen widthScale])

@implementation UserInfoEditPopModel


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
        
    }
    return self;
}

@end

@interface UserInfoBirthdayView : UIView

@end

@implementation UserInfoBirthdayView



@end

@interface UserInfoEditPopView ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate> {
    NSUInteger _firstRowIdx;
    NSUInteger _secondRowIdx;
    NSUInteger _thirdRowIdx;
    
    CGFloat _contentTopMargin;
}

@property (nonatomic, strong) UIView *backgroundView_c;
@property (nonatomic, strong) UIView *animateView;
@property (nonatomic, strong) UIView *contentView_c;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UILabel *viewTitleText;
@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *subtitleText;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UserInfoBirthdayView *birthdayView;

@property (nonatomic, strong) __kindof UIView *contentView;
@property (nonatomic, strong) __kindof UIView *contentBeginView;

@property (nonatomic, strong) UserInfoEditPopModel *lastModel;
@property (nonatomic, strong) NSArray *pickerData;

@end

@implementation UserInfoEditPopView

// MARK: - 公开方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _resetPickerIndices];
        [self _configBasicSubviews];
    }
    return self;
}

- (void)showOnView:(__kindof UIView *)view withData:(UserInfoEditPopModel *)data {
    
    if (!data) {
        return;
    }
    
    [view addSubview:self];
    
    [self _resetPickerIndices];
    [self _updateModel:data];
    [self _configPickerData];
    
    [self _configTitleView];
    [self _configContentView];
    
    [self updateConstraintsIfNeeded];
    
    [self _updateTitleText];
    
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.animateView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss {

    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.animateView.frame = CGRectMake(0, [UIScreen height_c], self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
    
}

// MARK: - 按钮点击事件

- (void)cancelButtonAction:(UIButton *)sender {
 
    [self dismiss];
}

- (void)doneButtonAction:(UIButton *)sender {
    
}

// MARK: - 添加移除功能视图

- (void)_addTitleViews {
    
    _titleText = [UILabel new];
    _titleText.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium];
    _titleText.textColor = [UIColor doubleFishThemeColor];
    
    _subtitleText = [UILabel new];
    _subtitleText.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    // rgba(99, 85, 136, 1)
    _subtitleText.textColor = [UIColor colorWith255R:99 g:85 b:136];
    
    [_contentView_c addSubview:_titleText];
    [_contentView_c addSubview:_subtitleText];
    
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30.0*kWidthScale));
        make.top.equalTo(_viewTitleText.mas_bottom).offset(30.0);
        make.left.equalTo(_contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(_contentView_c.mas_right).offset(-kUIPadding);
    }];
    
    [_subtitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20.0*kWidthScale));
        make.top.equalTo(_titleText.mas_bottom).offset(2.0);
        make.left.equalTo(_contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(_contentView_c.mas_right).offset(-kUIPadding);
    }];
}

- (void)_removeTitleViews {
    [_titleText removeFromSuperview];
    [_subtitleText removeFromSuperview];
}

- (void)_addBirthdayAddView {
    
    _birthdayView = [UserInfoBirthdayView new];
    _birthdayView.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.04];
    _birthdayView.layer.cornerRadius = 8.0;
    [_contentView_c addSubview:_birthdayView];
    
    CGSize bsize = CGSizeMake(0, 51.5*kWidthScale);
    [_birthdayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(bsize.height));
        make.top.equalTo(_contentBeginView.mas_bottom).offset(24.0);
        make.left.equalTo(_contentView_c.mas_left).offset(kUIPadding);
        make.right.equalTo(_contentView_c.mas_right).offset(-kUIPadding);
    }];
}

- (void)_removeBirthdayAddView {
    [_birthdayView removeFromSuperview];
}

// MARK: - 配置视图

- (void)_configBasicSubviews {
    
    _backgroundView_c = [UIView new];
    _backgroundView_c.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.3];
    
    _animateView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen height_c], self.bounds.size.width, self.bounds.size.height)];
    
    _contentView_c = [UIView new];
    _contentView_c.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.88];
    
    _viewTitleText = [UILabel new];
    _viewTitleText.textAlignment = NSTextAlignmentCenter;
    _viewTitleText.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    _viewTitleText.textColor = [UIColor doubleFishThemeColor];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // rgba(176, 169, 194, 1)
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_cancelButton setTitleColor:[UIColor colorWith255R:176 g:169 b:194] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // rgba(255, 120, 253, 1)
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_doneButton setTitleColor:[UIColor colorWith255R:255 g:120 b:253] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_backgroundView_c];
    [self addSubview:_animateView];
    [_animateView addSubview:_contentView_c];
    [_contentView_c addSubview:_viewTitleText];
    [_contentView_c addSubview:_cancelButton];
    [_contentView_c addSubview:_doneButton];
    
    [_backgroundView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGSize csize = CGSizeMake(375.0*kWidthScale, 445.0*kWidthScale);
    [_contentView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(csize));
        make.centerX.equalTo(_animateView.mas_centerX);
        make.bottom.equalTo(_animateView.mas_bottom);
    }];
    
    [_viewTitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_contentView_c.mas_width).multipliedBy(0.6);
        make.height.equalTo(@(30.0*kWidthScale));
        make.centerX.equalTo(_contentView_c.mas_centerX);
        make.top.equalTo(_contentView_c.mas_top).offset(kUIPadding);
    }];
    
    CGSize btnsize = CGSizeMake(30.0*kWidthScale, 20.0*kWidthScale);
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(btnsize));
        make.centerY.equalTo(_viewTitleText.mas_centerY);
        make.left.equalTo(_contentView_c.mas_left).offset(kUIPadding);
    }];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(btnsize));
        make.centerY.equalTo(_viewTitleText.mas_centerY);
        make.right.equalTo(_contentView_c.mas_right).offset(-kUIPadding);
    }];
    
}

- (void)_configTitleView {
    
    if ([self isTitleViewStay]) {
        return;
    }
    
    switch (_model.titleMode) {
            
        case PopTitleModeNull: {
            [self _removeTitleViews];
            CGSize csize = CGSizeMake(375.0*kWidthScale, 261.0*kWidthScale);
            [_contentView_c mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(@(csize));
            }];
            
            _contentBeginView = _viewTitleText;
        }
            break;
            
        case PopTitleModeNormal: {
            [self _addTitleViews];
            CGSize csize = CGSizeMake(375.0*kWidthScale, 445.0*kWidthScale);
            [_contentView_c mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(@(csize));
            }];
            
            _contentBeginView = _subtitleText;
        }
            break;
            
        default:
            break;
    }
}

- (void)_configContentView {
    
    if ([self isContentViewStay]) {
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentBeginView.mas_bottom).offset(_contentTopMargin);
        }];
        return;
    }
    
    [_birthdayView removeFromSuperview];
    
    [_contentView removeFromSuperview];
    _contentView = [self gimmeContentView];
    [_contentView_c addSubview:_contentView];
    
    CGSize csize = CGSizeMake(0, 225.0*kWidthScale);
    CGFloat leftPad = kUIPadding;
    CGFloat rightPad = kUIPadding;
    CGFloat topMargin = 24.0;
    
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
            csize.height = 51.5*kWidthScale;
        }
            break;
            
        case PopContentTypeTextView:
        {
            _textView = _contentView;
            csize.height = 96.5*kWidthScale;
        }
            break;
            
        case PopContentTypeSearchBar:
        {
            // _searchBar = _contentView;
            csize.height = 51.5*kWidthScale;
        }
            break;
            
        default:
            break;
    }
    
    _contentTopMargin = topMargin;
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(csize.height));
        make.top.equalTo(_contentBeginView.mas_bottom).offset(topMargin);
        make.left.equalTo(_contentView_c.mas_left).offset(leftPad);
        make.right.equalTo(_contentView_c.mas_right).offset(-rightPad);
    }];
}

// MARK: - 配置和更新数据

- (void)_resetPickerIndices {
    _firstRowIdx = 0;
    _secondRowIdx = 0;
    _thirdRowIdx = 0;
}

- (void)_updateModel:(UserInfoEditPopModel *)model {
    _lastModel = _model;
    _model = model;
}

- (void)_configPickerData {
    switch (_model.viewName) {
        case PopViewNameAddress:
            _pickerData = [LocalJSONManager cities];
            break;
            
        case PopViewNameProfession:
            _pickerData = [LocalJSONManager profs];
            break;
            
        case PopViewNameUniversity:
            _pickerData = [LocalJSONManager universities_name];
            break;
            
        default:
            _pickerData = _model.dataSource;
            break;
    }
}

// MARK: - 更新界面

- (void)_updateTitleText {
    _viewTitleText.text = _model.viewTitle;
    _titleText.text = _model.title;
    _subtitleText.text = _model.subtitle;
    
    [_cancelButton setTitle:_model.cancelTitle forState:UIControlStateNormal];
    [_doneButton setTitle:_model.doneTitle forState:UIControlStateNormal];
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
            
        case PopContentTypeSearchBar:
            cv = [self gimmeTextField];
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
    view.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    view.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.04];
    // rgba(255, 120, 253, 1)
    view.tintColor = [UIColor colorWith255R:255 g:120 b:253];
    view.layer.cornerRadius = 8.0;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIPadding, kUIPadding)];
    view.leftViewMode = UITextFieldViewModeAlways;
    view.leftView = leftView;
    
    return view;
}

- (UITextView *)gimmeTextView {
    
    UITextView *view = [UITextView new];
    view.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.04];
    view.tintColor = [UIColor colorWith255R:255 g:120 b:253];
    view.layer.cornerRadius = 8.0;
    
    view.textContainerInset = UIEdgeInsetsMake(11.5, 11.5, 11.5, 11.5);
    
    return view;
}

// MARK: - 选择器数据源和代理

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
            count = 1;
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
