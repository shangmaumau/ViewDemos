//
//  KXHomeNewComerGiftsView.h
//  yuewan
//
//  Created by Michael on 2021/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface KXHomeNewComerGiftModel : NSObject

@property (nonatomic, copy, nullable) NSURL *iconURL;
@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger sortNum;
@property (nonatomic, assign) NSUInteger identifier;

- (nullable instancetype)initWithData:(id)data;

@end

@interface KXHomeNewComerGiftCell : UICollectionViewCell

@property (nonatomic, strong) UIView *contentView_c;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameAndQuantityText;

- (void)updateWithIconURL:(NSURL *)url giftName:(NSString *)name andQuantity:(NSUInteger)quantity;

@end

@interface KXHomeNewComerGiftsView : UIView
/// 新人礼包要进的房间号
@property (nonatomic, copy) NSString* roomId;

- (void)configDrawCallbackAction:(void (^)(void))callback;
- (void)showInView:(__kindof UIView *)view withList:(NSArray<KXHomeNewComerGiftModel *> *)list;
- (void)hide;


@end

NS_ASSUME_NONNULL_END
