//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YunWebViewConfig : NSObject

@property (nonatomic, copy) NSString *schemeName;

@property (nonatomic, copy) NSString *jsNamePre;

+ (instancetype)sharedInstance;

@end