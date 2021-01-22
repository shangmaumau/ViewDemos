//
//  ViewController.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "ViewController.h"
#import "UserInfoEditPopView.h"
#import "UserInfoSelectPopView.h"

#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UserInfoEditPopView *editPopView;

@property (nonatomic, strong) UserInfoSelectPopView *selectPopView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.view.backgroundColor = [UIColor systemTealColor];
    [self configViews];
}

- (void)configViews {
    _editPopView = [[UserInfoEditPopView alloc] initWithFrame:self.view.bounds];
    _selectPopView = [[UserInfoSelectPopView alloc] initWithFrame:self.view.bounds];
}

- (IBAction)showView:(UIButton *)sender {
    // [self __showEditPopView];
    [self __showSelectPopView];
}

- (IBAction)dimissView:(UIButton *)sender {
    
}

- (void)__showEditPopView {
    
    UserInfoEditPopModel *model = [UserInfoEditPopModel new];
    
//    model.contentType = PopContentTypeSearchView;
    
    // pickerView 和 datePicker 的高度，需要做适配，不能挨着底部

    model.viewName = PopViewNameBirthday;
    model.contentType = PopContentTypeDatePicker;
    
//    model.viewName = PopViewNameAddress;
//    model.titleMode = PopTitleModeNull;
    
//    model.titleMode = PopTitleModeNull;
//    model.dataSource = @[ NSLocalizedString(@"男", @""), NSLocalizedString(@"女", @"") ];
    
//    model.contentType = PopContentTypeTextView;
//    model.recoveryData = @"我是内容";
    
    [_editPopView showOnView:self.view withData:model];
}

- (void)__showSelectPopView {
    
    UserInfoTofuModel *tf1 = [UserInfoTofuModel new];
    tf1.isSelected = YES;
    UserInfoTofuModel *tf2 = [UserInfoTofuModel new];
    tf2.isSelected = YES;
    UserInfoTofuModel *tf3 = [UserInfoTofuModel new];
    tf3.isSelected = YES;
    UserInfoTofuModel *tf4 = [UserInfoTofuModel new];
    tf4.isSelected = YES;
    UserInfoTofuModel *tf5 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf6 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf7 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf8 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf9 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf10 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf11 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf12 = [UserInfoTofuModel new];
    
    UserInfoTofuModel *tf13 = [UserInfoTofuModel new];
    UserInfoTofuModel *tf14 = [UserInfoTofuModel new];
    
    [_selectPopView showOnView:self.view withModels:@[ tf1, tf2, tf3, tf4, tf5, tf6, tf7, tf8, tf9, tf10, tf11, tf12, tf13, tf14 ]];
    
    
    
}

@end
