//
//  MyUserInfoPickerView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PopContentType) {
    PopContentTypePickerView,
    PopContentTypeDatePicker,
    PopContentTypeTextField,
    PopContentTypeTextView,
    PopContentTypeSearchBar
};

typedef NS_ENUM(NSUInteger, PopViewName) {
    PopViewNameNull,        // 默认
    PopViewNameBirthday,    // 要添加额外的视图
    PopViewNameAddress,     // 三级联动
    PopViewNameProfession,  // 二级联动
    PopViewNameUniversity   // 大学，搜索需要定位数据源
};

typedef NS_ENUM(NSUInteger, PopTitleMode) {
    PopTitleModeNull,
    PopTitleModeNormal,
    PopTitleModeOnlyTitle
};


@interface MyUserInfoPickerModel : NSObject

@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *doneTitle;

@property (nonatomic, assign) PopContentType contentType;
@property (nonatomic, assign) PopTitleMode titleMode;
@property (nonatomic, assign) PopViewName viewName;

@property (nonatomic, copy) NSArray *dataSource;

@end

@interface MyUserInfoPickerView : UIView

@property (nonatomic, strong) MyUserInfoPickerModel *model;

- (void)showOnView:(__kindof UIView *)view withData:(MyUserInfoPickerModel *)data;
- (void)dismiss;


@end

NS_ASSUME_NONNULL_END
