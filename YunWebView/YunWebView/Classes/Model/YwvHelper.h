//
// Created by yun on 2018/6/13.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YunWebViewController;

@interface YwvHelper : NSObject

+ (instancetype)instance;

- (YunWebViewController *)findByViewId:(NSString *)viewId;

- (NSMutableArray<YunWebViewController *> *)findAllByViewId:(NSString *)viewId;

@end