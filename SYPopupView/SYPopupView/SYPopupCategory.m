//
//  SYPopupCategory.m
//  SYPopupView
//
//  Created by 沈云翔 on 2017/3/7.
//  Copyright © 2017年 shenyunxiang. All rights reserved.
//

#import "SYPopupCategory.h"
#import <objc/runtime.h>
#import <Masonry.h>
#import "SYPopup_Macro.h"
#import "SYPopupWindow.h"
@implementation UIColor (SYPopup)

+ (UIColor *) popup_colorWithHex:(NSUInteger)hex {
    
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
    
}

@end

@implementation UIImage (SYPopup)

+ (UIImage *) popup_imageWithColor:(UIColor *)color {
    return [UIImage popup_imageWithColor:color Size:CGSizeMake(4.0f, 4.0f)];
}

+ (UIImage *) popup_imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image popup_stretched];
}

- (UIImage *) popup_stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}

@end

@implementation UIButton (SYPopup)

+ (id)popup_buttonWithTarget:(id)target action:(SEL)sel {
    
    id btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    return btn;
}

@end

@implementation NSString (SYPopup)

- (NSString *)popup_truncateByCharLength:(NSUInteger)charLength {
    __block NSUInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              
                              if ( length+substringRange.length > charLength )
                              {
                                  *stop = YES;
                                  return;
                              }
                              
                              length+=substringRange.length;
                          }];
    
    return [self substringToIndex:length];
}

@end


static const void *popup_dimReferenceCountKey            = &popup_dimReferenceCountKey;

static const void *popup_dimBackgroundViewKey            = &popup_dimBackgroundViewKey;
static const void *popup_dimAnimationDurationKey         = &popup_dimAnimationDurationKey;
static const void *popup_dimBackgroundAnimatingKey       = &popup_dimBackgroundAnimatingKey;

static const void *popup_dimBackgroundBlurViewKey        = &popup_dimBackgroundBlurViewKey;
static const void *popup_dimBackgroundBlurEnabledKey     = &popup_dimBackgroundBlurEnabledKey;
static const void *popup_dimBackgroundBlurEffectStyleKey = &popup_dimBackgroundBlurEffectStyleKey;

@interface UIView (SYPopupInner)
@property (nonatomic, assign, readwrite) NSInteger popup_dimReferenceCount;
@end

@implementation UIView (SYPopupInner)
@dynamic popup_dimReferenceCount;

- (NSInteger)popup_dimReferenceCount {
    return [objc_getAssociatedObject(self, popup_dimReferenceCountKey) integerValue];
}

- (void)setMm_dimReferenceCount:(NSInteger)popup_dimReferenceCount
{
    objc_setAssociatedObject(self, popup_dimReferenceCountKey, @(popup_dimReferenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIView (SYPopup)

@dynamic popup_dimBackgroundView;
@dynamic popup_dimAnimationDuration;
@dynamic popup_dimBackgroundAnimating;
@dynamic popup_dimBackgroundBlurView;

- (UIView *)popup_dimBackgroundView {
    UIView *dimView = objc_getAssociatedObject(self, popup_dimBackgroundViewKey);
    
    if ( !dimView )
    {
        dimView = [UIView new];
        [self addSubview:dimView];
        [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        dimView.alpha = 0.0f;
        dimView.backgroundColor = PopupHexColor(0x0000007F);
        dimView.layer.zPosition = FLT_MAX;
        
        self.popup_dimAnimationDuration = 0.3f;
        
        objc_setAssociatedObject(self, popup_dimBackgroundViewKey, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dimView;
}

- (BOOL)popup_dimBackgroundAnimating
{
    return [objc_getAssociatedObject(self, popup_dimBackgroundAnimatingKey) boolValue];
}

- (void)setMm_dimBackgroundAnimating:(BOOL)popup_dimBackgroundAnimating
{
    objc_setAssociatedObject(self, popup_dimBackgroundAnimatingKey, @(popup_dimBackgroundAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)popup_showDimBackground {
    ++self.popup_dimReferenceCount;
    
    if (self.popup_dimReferenceCount > 1) {
        return;
    }
    
    self.popup_dimBackgroundView.hidden = NO;
    self.popup_dimBackgroundAnimating   = YES;
    
    if (self == [SYPopupWindow sharedWindow].attachView) {
        
        [SYPopupWindow sharedWindow].hidden = NO;
        [[SYPopupWindow sharedWindow] makeKeyAndVisible];
        
    } else if ([self isKindOfClass:[UIWindow class]]) {
        
        self.hidden = NO;
        [(UIWindow*)self makeKeyAndVisible];
        
    } else {
     
        [self bringSubviewToFront:self.popup_dimBackgroundView];
        
    }
    
    [UIView animateWithDuration:self.popup_dimAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.popup_dimBackgroundView.alpha = 1.0f;
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.mm_dimBackgroundAnimating = NO;
                         }
                         
                     }];
    
}

- (void)popup_hideDimBackground{
    --self.popup_dimReferenceCount;
    
    if (self.popup_dimReferenceCount > 0) {
        return;
    }
    
    self.popup_dimBackgroundAnimating = YES;
    [UIView animateWithDuration:self.popup_dimAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.popup_dimBackgroundView.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.popup_dimBackgroundAnimating = NO;
                             
                             if ( self == [SYPopupWindow sharedWindow].attachView )
                             {
                                 [SYPopupWindow sharedWindow].hidden = YES;
                                 [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
                             }
                             else if ( self == [SYPopupWindow sharedWindow] )
                             {
                                 self.hidden = YES;
                                 [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
                             }
                         }
                     }];
}


@end

