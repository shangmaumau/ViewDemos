//
//  PopSearchView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 搜索结果匹配模式。
typedef NS_ENUM(NSUInteger, PopSearchFilterMode) {
    /// 匹配开头。
    PopSearchFilterModeBeginsWith,
    /// 匹配包含。
    PopSearchFilterModeContains
};

/// 默认的搜索是大学，默认的模式是匹配开头。如需自定义，请使用下面的初始化方法。
@interface PopSearchView : UIView

/// @Note 注意这里的 dataSource 中的元素，要么直接是字符串，要么是可以通过 `title` `name` 键
/// 获取到值的模型。
- (instancetype)initWithFrame:(CGRect)frame mode:(PopSearchFilterMode)mode andDataSource:(NSArray *)dataSource;

@end

NS_ASSUME_NONNULL_END
