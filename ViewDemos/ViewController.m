//
//  ViewController.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "ViewController.h"
#import "MyUserInfoPickerView.h"

@interface ViewController ()

@property (nonatomic, strong) MyUserInfoPickerView *uiPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.view.backgroundColor = [UIColor systemTealColor];
    [self configViews];
}

- (void)configViews {
    _uiPickerView = [[MyUserInfoPickerView alloc] initWithFrame:self.view.bounds];
}

- (IBAction)showView:(UIButton *)sender {

    NSLog(@"hello");
    [self __showPickerView];
}

- (IBAction)dimissView:(UIButton *)sender {
    
    
}

- (void)__showPickerView {
    
    MyUserInfoPickerModel *model = [MyUserInfoPickerModel new];
    model.viewName = PopViewNameBirthday;
    model.contentType = PopContentTypeDatePicker;
    
    [_uiPickerView showOnView:self.view withData:model];
}

@end
