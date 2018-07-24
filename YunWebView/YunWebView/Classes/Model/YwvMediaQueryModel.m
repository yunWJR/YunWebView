//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "YwvMediaQueryModel.h"
#import <YunKits/YunGlobalDefine.h>
#import <YunBaseApp/YunLogHelper.h>

@implementation YwvMediaQueryModel

+ (instancetype)modelWithData:(id)data {
    NSError *modelErr;
    YwvMediaQueryModel *model = [[YwvMediaQueryModel alloc] initWithDictionary:data error:&modelErr];

    if (modelErr) {
        [YunLogHelper logMsg:FORMAT(@"model_error:%@", modelErr)];
        return nil;
    }
    else {return model;}
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end