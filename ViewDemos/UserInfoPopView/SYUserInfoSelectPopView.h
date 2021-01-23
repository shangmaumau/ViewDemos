//
//  SYUserInfoSelectPopView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import <UIKit/UIKit.h>
#import "SYUserInfoBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUserInfoTofuModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface SYUserInfoTofuCell : UICollectionViewCell

@property (nonatomic, strong) SYUserInfoTofuModel *model;
@property (nonatomic, strong) CAGradientLayer *genderGLLayer;
@property (nonatomic, strong) UIButton *tofuButton;

@property (nonatomic, copy) void (^selectedCallback)(BOOL isSelected);

- (void)updateContentWithModel:(SYUserInfoTofuModel *)model;
- (void)configSelectedCallback:(void (^)(BOOL isSelected))callback;
- (void)changeSelectedButtonState:(BOOL)isSelected;

@end


@interface SYUserInfoTofuTagModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, copy) NSArray<SYUserInfoTofuModel *> *tofus;

@end

@interface SYUserInfoSelectPopView : SYUserInfoBasePopView

- (void)showOnView:(__kindof UIView *)view withModels:(NSArray<SYUserInfoTofuTagModel *> *)list;


@end

NS_ASSUME_NONNULL_END
