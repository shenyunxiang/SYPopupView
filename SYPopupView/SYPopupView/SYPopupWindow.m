//
//  SYPopupWindow.m
//  SYPopupView
//
//  Created by 沈云翔 on 2016/12/19.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

#import "SYPopupWindow.h"
#import "SYPopupCategory.h"
#import "SYPopupView.h"
@interface SYPopupWindow () <UIGestureRecognizerDelegate>

@end

@implementation SYPopupWindow

+ (SYPopupWindow *)sharedWindow{
    
    static SYPopupWindow *window;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[SYPopupWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.rootViewController = [UIViewController new];
    });
    
    return window;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(actionTap:)];
        gesture.cancelsTouchesInView = NO;
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

#pragma mark - TapAction
- (void)actionTap:(UITapGestureRecognizer*)gesture
{
    if ( self.touchWildToHide && !self.popup_dimBackgroundAnimating )
    {
        for ( UIView *v in [self attachView].popup_dimBackgroundView.subviews )
        {
            if ( [v isKindOfClass:[SYPopupView class]] )
            {
                SYPopupView *popupView = (SYPopupView*)v;
                [popupView hide];
            }
        }
    }
        
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ( touch.view == self.attachView.popup_dimBackgroundView );
}

- (UIView *)attachView
{
    return self.rootViewController.view;
}
@end
