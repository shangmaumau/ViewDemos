//
//  SYMeTagsSelectPopView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import <UIKit/UIKit.h>
#import "SYMeInfoBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMeTagsTofuModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface SYMeTagsTofuCell : UICollectionViewCell

@property (nonatomic, strong) SYMeTagsTofuModel *model;
@property (nonatomic, strong) CAGradientLayer *genderGLLayer;
@property (nonatomic, strong) UIButton *tofuButton;

@property (nonatomic, copy) void (^selectedCallback)(BOOL isSelected);

- (void)updateContentWithModel:(SYMeTagsTofuModel *)model;
- (void)configSelectedCallback:(void (^)(BOOL isSelected))callback;
- (void)changeSelectedButtonState:(BOOL)isSelected;

@end


@interface SYMeTagsModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, copy) NSArray<SYMeTagsTofuModel *> *tofus;

@end

@interface SYMeTagsSelectPopView : SYMeInfoBasePopView

- (void)showOnView:(__kindof UIView *)view withModels:(NSArray<SYMeTagsModel *> *)list;


@end

NS_ASSUME_NONNULL_END
