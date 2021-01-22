//
//  UserInfoSelectPopView.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/22.
//

#import <UIKit/UIKit.h>
#import "UserInfoBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoTofuModel : NSObject

@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface UserInfoTofuCell : UICollectionViewCell

@property (nonatomic, strong) UserInfoTofuModel *model;
@property (nonatomic, strong) CAGradientLayer *genderGLLayer;
@property (nonatomic, strong) UIButton *tofuButton;

@property (nonatomic, copy) void (^selectedCallback)(BOOL isSelected);

- (void)updateContentWithModel:(UserInfoTofuModel *)model;
- (void)configSelectedCallback:(void (^)(BOOL isSelected))callback;
- (void)changeSelectedButtonState:(BOOL)isSelected;

@end

@interface UserInfoSelectPopView : UserInfoBasePopView

- (void)showOnView:(__kindof UIView *)view withModels:(NSArray<UserInfoTofuModel *> *)list;
- (void)updateWithModels:(NSArray<UserInfoTofuModel *> *)list;

@end

NS_ASSUME_NONNULL_END
