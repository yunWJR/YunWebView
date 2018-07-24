//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    YwvHost_UnKnown,

    // vc

    YwvHost_Vc_Push,
    YwvHost_Vc_Pop,

    YwvHost_Vc_Present,
    YwvHost_Vc_PresentHor,
    YwvHost_Vc_Close,

    YwvHost_Vc_UpdateId,

    YwvHost_Vc_ShowLoad,
    YwvHost_Vc_LoadCmp,

    YwvHost_Vc_SetViewKick,

    // msg view

    YwvHost_Vc_SetUpdate,
    YwvHost_Vc_SetWebUpdate,

    // nag

    YwvHost_Nag_UpdateStyle,

    // error

    YwvHost_Error_setError,

    // img

    YwvHost_Img_SelectImg,

    // media

    YwvHost_md_openPhone,

    YwvHost_md_openSms,

    YwvHost_md_openMd,

    // font

    YwvHost_font_getFontName,

    YwvHost_Max
} YunWebViewHostType;

@interface YunWebViewDefine : NSObject

+ (YunWebViewHostType)getHostType:(NSString *)host;

@end