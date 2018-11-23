//
// Created by yun on 2018/6/13.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YwvHelper.h"
#import "YunWebViewController.h"
#import "YwvVcQueryModel.h"
#import "YunWebViewConfig.h"
#import "YwvNagQueryModel.h"

@interface YwvHelper () {
}

@end

@implementation YwvHelper

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
    }

    return self;
}

- (YunWebViewController *)findByViewId:(NSString *)viewId {
    NSArray *ywvList = self.curViewControllers;

    for (int i = 0; i < ywvList.count; ++i) {
        id item = ywvList[i];
        if ([item isKindOfClass:YunWebViewController.class]) {
            YunWebViewController *itemVc = item;

            if ([YunValueVerifier isValidStr:itemVc.vcData.viewId]) {
                if ([itemVc.vcData.viewId isEqualToString:viewId]) {
                    return itemVc;
                }
            }
        }
    }

    return nil;
}

- (NSMutableArray<YunWebViewController *> *)findAllByViewId:(NSString *)viewId {
    NSMutableArray<YunWebViewController *> *vcList = [NSMutableArray new];

    NSArray *ywvList = self.curViewControllers;

    for (int i = 0; i < ywvList.count; ++i) {
        id item = ywvList[i];
        if ([item isKindOfClass:YunWebViewController.class]) {
            YunWebViewController *itemVc = item;

            if ([YunValueVerifier isValidStr:itemVc.vcData.viewId]) {
                if ([itemVc.vcData.viewId isEqualToString:viewId]) {
                    [vcList addObject:itemVc];
                }
            }
        }
    }

    return vcList;
}

- (NSArray< UIViewController *> *)curViewControllers {
    if (YunWebViewConfig.instance.delegate &&
        [YunWebViewConfig.instance.delegate respondsToSelector:@selector(curViewControllers)]) {
        return [YunWebViewConfig.instance.delegate curViewControllers];
    }
    else {
        [YunLogHelper logMsg:@"YunWebViewController：需要实现curViewControllers协议" force:YES];
    }

    return nil;
}

+ (void)openWebViewByUrl:(NSString *)url title:(NSString *)title nag:(UINavigationController *)nag {
    YunWebViewController *webView = [YunWebViewController new];

    YwvVcQueryModel *vcData = [YwvVcQueryModel new];
    vcData.viewUrl = url;
    vcData.viewLoadType = 1;

    webView.vcData = vcData;

    YwvNagQueryModel *nagData = [YwvNagQueryModel new];
    nagData.nagTitle = title;

    webView.nagData = nagData;

    [nag pushViewController:webView animated:YES];
}

@end