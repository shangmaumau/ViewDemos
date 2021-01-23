//
//  SYUserInfoEditPopView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "SYUserInfoBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

/// 内容类型。
typedef NS_ENUM(NSUInteger, PopContentType) {
    PopContentTypePickerView,
    PopContentTypeDatePicker,
    PopContentTypeTextField,
    PopContentTypeTextView,
    PopContentTypeSearchView
};

/// 标题类型。
typedef NS_ENUM(NSUInteger, PopTitleMode) {
    PopTitleModeNull,
    PopTitleModeNormal,
    PopTitleModeOnlyTitle
};

/// 标题名称，需要根据一些名称做特殊处理。
typedef NS_ENUM(NSUInteger, PopViewName) {
    PopViewNameNull,        // 默认
    PopViewNameGender,      // 性别
    PopViewNameBirthday,    // 要添加额外的视图
    PopViewNameAddress,     // 三级联动
    PopViewNameProfession,  // 二级联动
    PopViewNameUniversity   // 大学，搜索需要定位数据源
};

@interface SYUserInfoEditPopModel : NSObject

@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *doneTitle;

@property (nonatomic, assign) PopContentType contentType;
@property (nonatomic, assign) PopTitleMode titleMode;
@property (nonatomic, assign) PopViewName viewName;

/// 选择器需要配置，其他类型不用配置。选择器类，如果不是特殊的（特殊的内部已经做了处理），
/// 需要是字符串数组或可以通过 `name`、`title` 键获取值的模型。
/// @Note 注意：外部生成的选择器，只支持单列。
@property (nonatomic, copy, nullable) NSArray *dataSource;
/// 需要在内容视图上恢复的数据。 输入器类，传字符串。 日期需要以字符串形式 `yyyy-MM-dd` 给。
/// 其他选择器类的，使用默认滚动位置，不恢复。
@property (nonatomic, strong, nullable) id recoveryData;

@end

@interface SYUserInfoEditPopView : SYUserInfoBasePopView

@property (nonatomic, strong) SYUserInfoEditPopModel *model;

- (void)showOnView:(__kindof UIView *)view withData:(SYUserInfoEditPopModel *)data;
- (void)dismiss;
- (void)configDoneCallback:(void (^)(id _Nullable data))callback;

@end

NS_ASSUME_NONNULL_END
