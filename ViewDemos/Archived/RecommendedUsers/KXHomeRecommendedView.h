//
//  KXHomeRecommendedView.h
//  yuewan
//
//  Created by Michael on 2021/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KXHomeRecommendedModel : NSObject

@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, copy) NSURL *avatarURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger gender;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) BOOL isSelected;

- (nullable instancetype)initWithData:(id)data;

@end

@interface KXHomeRecommendedCell : UICollectionViewCell

- (void)updateInfoWithModel:(KXHomeRecommendedModel *)model;
- (void)configSelectedCallback:(void(^)(BOOL isSelected))callback;
- (void)changeSelectedButtonState:(BOOL)isSelected;

@end

@interface KXHomeRecommendedView : UIView

- (void)showInView:(__kindof UIView *)view withList:(NSArray<KXHomeRecommendedModel *> *)list;
- (void)hide;
- (void)configFollowButtonCallback:(void(^)(NSArray<NSNumber *> *ids))callback;

@end

NS_ASSUME_NONNULL_END
