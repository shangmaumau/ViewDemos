//
//  ViewController.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "ViewController.h"

#import "SYUserInfoEditPopView.h"
#import "SYUserInfoSelectPopView.h"
#import "MeInfoEditController.h"

#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) SYUserInfoEditPopView *editPopView;

@property (nonatomic, strong) SYUserInfoSelectPopView *selectPopView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.view.backgroundColor = [UIColor systemTealColor];
    [self configViews];
}

- (void)configViews {
    _editPopView = [[SYUserInfoEditPopView alloc] initWithFrame:self.view.bounds];
    _selectPopView = [[SYUserInfoSelectPopView alloc] initWithFrame:self.view.bounds];
}

- (IBAction)showView:(UIButton *)sender {
    // [self __showEditPopView];
    [self __showSelectPopView];
}

- (IBAction)dimissView:(UIButton *)sender {
    
}

- (IBAction)infoEdit:(id)sender {
    
    MeInfoEditController *meedit = [MeInfoEditController new];
    meedit.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:meedit animated:YES completion:nil];
    
}

- (void)__showEditPopView {
    
    SYUserInfoEditPopModel *model = [SYUserInfoEditPopModel new];

    model.titleMode = PopTitleModeNull;
    model.contentType = PopContentTypeDatePicker;
    model.recoveryData = @"2002-01-23"; // 这个数据用于恢复，用户不选择，返回会为空
    
    [_editPopView showOnView:self.view withData:model];
    
    [_editPopView configDoneCallback:^(id  _Nonnull data) {
        NSLog(@"data %@", data);
    }];
}

- (void)__showSelectPopView {
    
    SYUserInfoTofuModel *tf1 = [SYUserInfoTofuModel new];
    tf1.isSelected = YES;
    SYUserInfoTofuModel *tf2 = [SYUserInfoTofuModel new];
    tf2.isSelected = YES;
    SYUserInfoTofuModel *tf3 = [SYUserInfoTofuModel new];
    tf3.isSelected = YES;
    SYUserInfoTofuModel *tf4 = [SYUserInfoTofuModel new];
    tf4.isSelected = YES;
    SYUserInfoTofuModel *tf5 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf6 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf7 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf8 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf9 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf10 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf11 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf12 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf13 = [SYUserInfoTofuModel new];
    SYUserInfoTofuModel *tf14 = [SYUserInfoTofuModel new];
    
    
    NSArray<SYUserInfoTofuModel *> *tofuTag1 = @[ tf1, tf2, tf3, tf4, tf5, tf6, tf7, tf8, tf9, tf10, tf11, tf12, tf13, tf14 ];
    
    SYUserInfoTofuTagModel *tofutag = [SYUserInfoTofuTagModel new];
    tofutag.tofus = tofuTag1;
    
    [_selectPopView showOnView:self.view withModels:@[ tofutag ]];
    
    
    
}

@end
