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

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger identifier;
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


@interface UserInfoTofuTagModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, copy) NSArray<UserInfoTofuModel *> *tofus;

@end

@interface UserInfoSelectPopView : UserInfoBasePopView

- (void)showOnView:(__kindof UIView *)view withModels:(NSArray<UserInfoTofuTagModel *> *)list;


@end

NS_ASSUME_NONNULL_END
