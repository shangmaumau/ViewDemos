//
//  ViewController.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "ViewController.h"
#import "UserInfoEditPopView.h"

@interface ViewController ()

@property (nonatomic, strong) UserInfoEditPopView *uiPickerView;

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
}

- (IBAction)showView:(UIButton *)sender {
    [self __showPickerView];
}

- (IBAction)dimissView:(UIButton *)sender {
    
    
}

- (void)__showPickerView {
    
    UserInfoEditPopModel *model = [UserInfoEditPopModel new];
    
    // pickerView 和 datePicker 的高度，需要做适配，不能挨着底部
    
//    model.viewName = PopViewNameBirthday;
//    model.contentType = PopContentTypeDatePicker;
    
     // model.viewName = PopViewNameAddress;
     // model.titleMode = PopTitleModeNull;
    
//    model.titleMode = PopTitleModeNull;
//    model.dataSource = @[ NSLocalizedString(@"男", @""), NSLocalizedString(@"女", @"") ];
    
    model.contentType = PopContentTypeTextView;
    model.recoveryData = @"我是内容";
    
    [_uiPickerView showOnView:self.view withData:model];
}

@end
