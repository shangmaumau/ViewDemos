//
//  ViewController.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "ViewController.h"
#import "UserInfoEditPopView.h"

#import "PopSearchView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UserInfoEditPopView *uiPickerView;

@property (nonatomic, strong) PopSearchView *searchView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.view.backgroundColor = [UIColor systemTealColor];
    [self configViews];
}

- (void)configViews {
    _uiPickerView = [[UserInfoEditPopView alloc] initWithFrame:self.view.bounds];
    
//    _searchView = [PopSearchView new];
//    [self.view addSubview:_searchView];
//    
//    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.view.mas_top).offset(50.0);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.height.equalTo(@(225.0));
//    }];
//    
}

- (IBAction)showView:(UIButton *)sender {
    [self __showPickerView];
}

- (IBAction)dimissView:(UIButton *)sender {
    
    
}

- (void)__showPickerView {
    
    UserInfoEditPopModel *model = [UserInfoEditPopModel new];
    
    // pickerView 和 datePicker 的高度，需要做适配，不能挨着底部
    
    model.viewName = PopViewNameBirthday;
    model.contentType = PopContentTypeDatePicker;
    
     // model.viewName = PopViewNameAddress;
     // model.titleMode = PopTitleModeNull;
    
//    model.titleMode = PopTitleModeNull;
//    model.dataSource = @[ NSLocalizedString(@"男", @""), NSLocalizedString(@"女", @"") ];
    
//    model.contentType = PopContentTypeTextView;
//    model.recoveryData = @"我是内容";
    
    [_uiPickerView showOnView:self.view withData:model];
}

@end
