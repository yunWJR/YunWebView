//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <YunImgView/YunSelectImgHelper.h>
#import "YunWebViewConfig.h"
#import "YunWebViewController.h"

@interface YunWebViewConfig () {
}

@end

@implementation YunWebViewConfig

+ (instancetype)instance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _schemeName = @"skkj";
        _jsNamePre = @"skkj_";

        _webUrlName = @"viewUrl";

        _rqtTimeOut = 8;
        _showProg = YES;
    }

    return self;
}

@end