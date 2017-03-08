//
//  SYPopupCategory.h
//  SYPopupView
//
//  Created by 沈云翔 on 2017/3/7.
//  Copyright © 2017年 shenyunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SYPopup)

+ (UIColor *)popup_colorWithHex:(NSUInteger)hex;

@end

@interface UIImage (SYPopup)

+ (UIImage *) popup_imageWithColor:(UIColor *)color;

+ (UIImage *) popup_imageWithColor:(UIColor *)color Size:(CGSize)size;

- (UIImage *) popup_stretched;

@end

@interface UIButton (SYPopup)

+ (id) popup_buttonWithTarget:(id)target action:(SEL)sel;

@end

@interface NSString (SYPopup)

- (NSString *)popup_truncateByCharLength:(NSUInteger)charLength;

@end

@interface UIView (SYPopup)

@property (nonatomic, strong, readonly ) UIView            *popup_dimBackgroundView;
@property (nonatomic, assign, readwrite) BOOL              popup_dimBackgroundAnimating;
@property (nonatomic, assign           ) NSTimeInterval    popup_dimAnimationDuration;

@property (nonatomic, strong, readonly ) UIView            *popup_dimBackgroundBlurView;
@property (nonatomic, assign           ) BOOL              popup_dimBackgroundBlurEnabled;
@property (nonatomic, assign           ) UIBlurEffectStyle popup_dimBackgroundBlurEffectStyle;

- (void) popup_showDimBackground;
- (void) popup_hideDimBackground;

- (void) popup_distributeSpacingHorizontallyWith:(NSArray*)view;
- (void) popup_distributeSpacingVerticallyWith:(NSArray*)view;


@end
