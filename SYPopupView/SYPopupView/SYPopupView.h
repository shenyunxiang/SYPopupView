//
//  SYPopupView.h
//  SYPopupView
//
//  Created by 沈云翔 on 2016/12/19.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPopupView;
typedef NS_ENUM(NSUInteger, SYPopupType) {
    SYPopupTypeAlert,
    SYPopupTypeSheet,
    SYPopupTypeCustom,
};

typedef void(^SYPopupBlock)(SYPopupView *);
typedef void(^SYPopupCompletionBlock)(SYPopupView *, BOOL);

@interface SYPopupView : UIView

/**
 default is NO.
 */
@property (nonatomic, assign, readonly) BOOL           visible;

/**
 default is SYPopupWindow. You can attach SYPopupView to any UIView.
 */
@property (nonatomic, strong          ) UIView         *attachedView;

/**
 default is SYPopupTypeAlert.
 */
@property (nonatomic, assign          ) SYPopupType    type;

/**
  default is 0.3 sec.
 */
@property (nonatomic, assign          ) NSTimeInterval animationDuration;

/**
  default is NO. When YES, alert view with be shown with a center offset (only effect with SYPopupTypeAlert).
 */
@property (nonatomic, assign          ) BOOL           withKeyboard;

@property (nonatomic, copy            ) SYPopupCompletionBlock   showCompletionBlock; // show completion block.
@property (nonatomic, copy            ) SYPopupCompletionBlock   hideCompletionBlock; // hide completion block

@property (nonatomic, copy            ) SYPopupBlock   showAnimation;       // custom show animation block.
@property (nonatomic, copy            ) SYPopupBlock   hideAnimation;       // custom hide animation block.

/**
 *  override this method to show the keyboard if with a keyboard
 */
- (void) showKeyboard;

/**
 *  override this method to hide the keyboard if with a keyboard
 */
- (void) hideKeyboard;


/**
 *  show the popup view
 */
- (void) show;

/**
 *  show the popup view with completiom block
 *
 *  @param block show completion block
 */
- (void) showWithBlock:(SYPopupCompletionBlock)block;

/**
 *  hide the popup view
 */
- (void) hide;

/**
 *  hide the popup view with completiom block
 *
 *  @param block hide completion block
 */
- (void) hideWithBlock:(SYPopupCompletionBlock)block;

/**
 *  hide all popupview with current class, eg. [MMAlertview hideAll];
 */
+ (void) hideAll;


@end
