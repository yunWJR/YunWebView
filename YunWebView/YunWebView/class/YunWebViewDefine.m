//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import "YunWebViewDefine.h"
#import "YunValueVerifier.h"

@interface YunWebViewDefine () {
}

@end

@implementation YunWebViewDefine

+ (YunWebViewHostType)getHostType:(NSString *)host {
    if ([YunValueVerifier isInvalidStr:host]) {
        return YwvHost_UnKnown;
    }

    // view

    if ([host isEqualToString:@"view_push"]) {
        return YwvHost_Vc_Push;
    }
    if ([host isEqualToString:@"view_pop"]) {
        return YwvHost_Vc_Pop;
    }

    if ([host isEqualToString:@"view_present"]) {
        return YwvHost_Vc_Present;
    }
    if ([host isEqualToString:@"view_presentHor"]) {
        return YwvHost_Vc_PresentHor;
    }
    if ([host isEqualToString:@"view_close"]) {
        return YwvHost_Vc_Close;
    }

    if ([host isEqualToString:@"view_updateId"]) {
        return YwvHost_Vc_UpdateId;
    }

    if ([host isEqualToString:@"view_loadCmp"]) {
        return YwvHost_Vc_LoadCmp;
    }

    if ([host isEqualToString:@"view_setUpdate"]) {
        return YwvHost_Vc_SetUpdate;
    }

    // nag

    if ([host isEqualToString:@"nag_updateStyle"]) {
        return YwvHost_Nag_UpdateStyle;
    }

    // error

    if ([host isEqualToString:@"error_setError"]) {
        return YwvHost_Error_setError;
    }

    // img

    if ([host isEqualToString:@"img_selectImg"]) {
        return YwvHost_Img_SelectImg;
    }

    // media

    if ([host isEqualToString:@"md_openPhone"]) {
        return YwvHost_md_openPhone;
    }

    if ([host isEqualToString:@"md_openSms"]) {
        return YwvHost_md_openSms;
    }

    if ([host isEqualToString:@"md_openMd"]) {
        return YwvHost_md_openMd;
    }

    return YwvHost_UnKnown;
}

@end