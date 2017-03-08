//
//  SYPopupWindow.h
//  SYPopupView
//
//  Created by 沈云翔 on 2016/12/19.
//  Copyright © 2016年 shenyunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPopupWindow : UIWindow

@property (nonatomic, assign) BOOL touchWildToHide; 

@property (nonatomic, readonly) UIView      *attachView;



+ (SYPopupWindow *)sharedWindow;


@end
