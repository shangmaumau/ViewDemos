//
//  MeUserEditModel.h
//  ViewDemos
//
//  Created by sam chojine on 2021/1/23.
//

#import <Foundation/Foundation.h>
#import "SYUserInfoEditPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeUserEditModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSString *headImage;

@property (nonatomic, assign) PopViewName popname;
@property (nonatomic, assign) PopContentType popctype;
@property (nonatomic, assign) PopTitleMode poptitlem;

@end

NS_ASSUME_NONNULL_END
