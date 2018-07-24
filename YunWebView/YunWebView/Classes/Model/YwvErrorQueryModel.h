//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import "JSONModel.h"

@interface YwvErrorQueryModel : JSONModel

// ---Error---

// app 处理的错误
// 0-显示错误信息-默认：需要设置：errorMsg
// 1-重新登录：适用于token失效等，需要重新登录的情况
@property (nonatomic, assign) NSInteger errorCode;

// app 显示的错误
// errorMsg-错误内容。
@property (nonatomic, copy) NSString *errorMsg;

+ (instancetype)modelWithData:(id)data;

@end