//
//  SYPopupView.m
//  SYPopupView
//
//  Created by 沈云翔 on 2016/12/19.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

#import "SYPopupView.h"
#import "SYPopupItem.h"
#import "SYPopupWindow.h"
#import <Masonry.h>
#import "SYPopupCategory.h"
#import "SYPopup_Macro.h"
static NSString * const SYPopupViewHideAllNotification = @"SYPopupViewHideAllNotification";

@implementation SYPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.type = SYPopupTypeAlert;
    self.animationDuration = 0.3f;
    self.attachedView = [SYPopupWindow sharedWindow].attachView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHideAll:) name:SYPopupViewHideAllNotification object:nil];
}

- (void)notifyHideAll:(NSNotification*)n
{
    if ( [self isKindOfClass:n.object] )
    {
//        [self hide];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYPopupViewHideAllNotification object:nil];
}

- (void)setType:(SYPopupType)type {
    _type = type;
    
    switch (type)
    {
        case SYPopupTypeAlert:
        {
            self.showAnimation = [self alertShowAnimation];
            self.hideAnimation = [self alertHideAnimation];
            break;
        }
        case SYPopupTypeSheet:
        {
            self.showAnimation = [self sheetShowAnimation];
            self.hideAnimation = [self sheetHideAnimation];
            break;
        }
        case SYPopupTypeCustom:
        {
            self.showAnimation = [self customShowAnimation];
            self.hideAnimation = [self customHideAnimation];
            break;
        }
            
        default:
            break;
    }
}

- (void)show{
    [self showWithBlock:nil];
}

- (void)showWithBlock:(SYPopupCompletionBlock)block {
    if (block) {
        self.showCompletionBlock = block;
    }
    
    if (!self.attachedView) {
        self.attachedView = [SYPopupWindow sharedWindow].attachView;
    }
    //加入背景view
    [self.attachedView popup_showDimBackground];
    
    SYPopupBlock showAnimation = self.showAnimation;
    
    NSAssert(showAnimation, @"show animation must be there");
    
    showAnimation(self);
    
    if (self.withKeyboard) {
        [self showKeyboard];
    }
}

- (void)hide {
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(SYPopupCompletionBlock)block {
    
    if (block) {
        self.hideCompletionBlock = block;
    }
    if (!self.attachedView) {
        self.attachedView = [SYPopupWindow sharedWindow].attachView;
    }
    //去除背景view
    [self.attachedView popup_hideDimBackground];
    
    if (self.withKeyboard) {
        [self hideKeyboard];
    }
    
    SYPopupBlock hideAnimation = self.hideAnimation;
    
    NSAssert(hideAnimation, @"hide animation must be there");
    
    hideAnimation(self);
    
    
}

- (SYPopupBlock)alertShowAnimation {
    PopupWeakify(self)
    SYPopupBlock block = ^(SYPopupView *popupView) {
        PopupStrongify(self)
        if (!self.superview) {
            [self.attachedView.popup_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
            }];
            [self layoutIfNeeded];
        }
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         } completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                         }];
    };
    
    return block;
}

- (SYPopupBlock)alertHideAnimation {
    PopupWeakify(self)
    SYPopupBlock block = ^(SYPopupView *popupView) {
        PopupStrongify(self)
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    
    return block;
}



- (SYPopupBlock)sheetShowAnimation {
    
    SYPopupBlock block = ^(SYPopupView *popupView) {
        
    };
    
    
    return block;
}

- (SYPopupBlock)sheetHideAnimation {
    
    SYPopupBlock block = ^(SYPopupView *popupView) {
        
    };
    
    
    return block;
}

- (SYPopupBlock)customShowAnimation {
    
    SYPopupBlock block = ^(SYPopupView *popupView) {
        
    };
    
    
    return block;
}

- (SYPopupBlock)customHideAnimation {
    
    SYPopupBlock block = ^(SYPopupView *popupView) {
        
    };
    
    
    return block;
}

+ (void)hideAll {
    
}

#pragma mark 弹出键盘或隐藏键盘
- (void)showKeyboard {
    
}

- (void)hideKeyboard {
    
}

@end
