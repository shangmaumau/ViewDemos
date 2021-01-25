//
//  SYMeTagsEditViewCtrl.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYMeTagsTofuModel;

@interface MeTagsRowModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong, nullable) NSArray<SYMeTagsTofuModel *> *tags;

@end

@interface MeTagsSectionModel : NSObject

@property (nonatomic, strong) NSArray<MeTagsRowModel *> *rowModels;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (nonatomic, copy) NSString *iconName;

@end

@interface SYMeTagsEditViewCtrl : UIViewController

@end

NS_ASSUME_NONNULL_END
