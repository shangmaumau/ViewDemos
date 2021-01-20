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
    model.contentType = PopContentTypeTextField;
    
//    model.contentType = PopContentTypeTextField;
//    model.contentType = PopContentTypeTextField;
    
    [_uiPickerView showOnView:self.view withData:model];
}

@end