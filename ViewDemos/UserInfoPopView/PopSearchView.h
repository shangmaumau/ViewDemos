//
//  PopSearchView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PopSearchFilterMode) {
    PopSearchFilterModeBeginsWith,
    PopSearchFilterModeContains
};

@interface PopSearchView : UIView

- (instancetype)initWithFrame:(CGRect)frame mode:(PopSearchFilterMode)mode andDataSource:(NSArray *)dataSource;

@end

NS_ASSUME_NONNULL_END
