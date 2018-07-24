//
// Created by yun on 2018/6/13.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import "YwvHelper.h"
#import "YunWebViewController.h"
#import "YwvVcQueryModel.h"
#import "YunWebViewConfig.h"

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

@end