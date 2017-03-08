//
//  SYPopup_Macro.h
//  SYPopupView
//
//  Created by 沈云翔 on 2017/3/7.
//  Copyright © 2017年 shenyunxiang. All rights reserved.
//

#ifndef SYPopup_Macro_h
#define SYPopup_Macro_h


#define PopupWeakify(o)        __weak   typeof(self) mmwo = o;
#define PopupStrongify(o)      __strong typeof(self) o = mmwo;
#define PopupHexColor(color)   [UIColor popup_colorWithHex:color]
#define Popup_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)


#endif /* SYPopup_Macro_h */
