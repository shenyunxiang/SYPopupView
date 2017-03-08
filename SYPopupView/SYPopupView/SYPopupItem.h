//
//  SYPopupItem.h
//  SYPopupView
//
//  Created by 沈云翔 on 2017/3/7.
//  Copyright © 2017年 shenyunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^SYPopupItemHandler)(NSInteger index);
typedef NS_ENUM(NSUInteger, SYItemType) {
    SYItemTypeNormal,
    SYItemTypeHighlight,
    SYItemTypeDisabled
};
@interface SYPopupItem : NSObject

@property (nonatomic, assign) BOOL     highlight;
@property (nonatomic, assign) BOOL     disabled;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor  *color;

@property (nonatomic, copy)   SYPopupItemHandler handler;

@end
NS_INLINE SYPopupItem* MMItemMake(NSString* title, SYItemType type, SYPopupItemHandler handler)
{
    SYPopupItem *item = [SYPopupItem new];
    
    item.title = title;
    item.handler = handler;
    
    switch (type)
    {
        case SYItemTypeNormal:
        {
            break;
        }
        case SYItemTypeHighlight:
        {
            item.highlight = YES;
            break;
        }
        case SYItemTypeDisabled:
        {
            item.disabled = YES;
            break;
        }
        default:
            break;
    }
    
    return item;
}
