//
//  ViewController.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "ViewController.h"

#import "SYUserInfoEditPopView.h"
#import "SYMeTagsSelectPopView.h"
#import "MeInfoEditController.h"

#import "SYMeTagsEditViewCtrl.h"

#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) SYUserInfoEditPopView *editPopView;

@property (nonatomic, strong) SYMeTagsSelectPopView *selectPopView;

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
    _selectPopView = [[SYMeTagsSelectPopView alloc] initWithFrame:self.view.bounds];
}

- (IBAction)showViewCtrl:(UIButton *)sender {
    
    
    SYMeTagsEditViewCtrl *tagsCtrl = [SYMeTagsEditViewCtrl new];
    tagsCtrl.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:tagsCtrl animated:YES completion:nil];
    
}

- (IBAction)showView:(UIButton *)sender {
    [self __showEditPopView];
    // [self __showSelectPopView];
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

    model.contentType = PopContentTypeSearchView;
    model.viewName = PopViewNameUniversity;
    
    [_editPopView showOnView:self.view withData:model];
    
    [_editPopView configDoneCallback:^(id  _Nonnull data) {
        NSLog(@"data %@", data);
    }];
}

- (void)__showSelectPopView {
    
    SYMeTagsTofuModel *tf1 = [SYMeTagsTofuModel new];
    tf1.isSelected = YES;
    SYMeTagsTofuModel *tf2 = [SYMeTagsTofuModel new];
    tf2.isSelected = YES;
    SYMeTagsTofuModel *tf3 = [SYMeTagsTofuModel new];
    tf3.isSelected = YES;
    SYMeTagsTofuModel *tf4 = [SYMeTagsTofuModel new];
    tf4.isSelected = YES;
    SYMeTagsTofuModel *tf5 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf6 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf7 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf8 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf9 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf10 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf11 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf12 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf13 = [SYMeTagsTofuModel new];
    SYMeTagsTofuModel *tf14 = [SYMeTagsTofuModel new];
    
    
    NSArray<SYMeTagsTofuModel *> *tofuTag1 = @[ tf1, tf2, tf3, tf4, tf5, tf6, tf7, tf8, tf9, tf10, tf11, tf12, tf13, tf14 ];
    
    SYMeTagsModel *tofutag = [SYMeTagsModel new];
    tofutag.tofus = tofuTag1;
    
    [_selectPopView showOnView:self.view withModels:@[ tofutag ]];
    
    
    
}

@end
