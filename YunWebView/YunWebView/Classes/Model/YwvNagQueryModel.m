//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "YwvNagQueryModel.h"
#import <YunKits/YunGlobalDefine.h>
#import <YunBaseApp/YunLogHelper.h>
#import <YunKits/YunValueVerifier.h>

@implementation YwvNagQueryModel

+ (instancetype)modelWithData:(id)data {
    NSError *modelErr;
    YwvNagQueryModel *model = [[YwvNagQueryModel alloc] initWithDictionary:data error:&modelErr];

    if (modelErr) {
        [YunLogHelper logMsg:FORMAT(@"model_error:%@", modelErr)];
        return nil;
    }
    else {
        [model reform];
        return model;
    }
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (void)reform {
    if ([YunValueVerifier isValidStr:self.nagLeftItemName]) {
        self.nagLeftItemType = 1;
    }
    else {
        if (self.nagLeftItemType == 1) {
            self.nagLeftItemType = 0;
        }
    }

    if ([YunValueVerifier isValidStr:self.nagRightItemName]) {
        self.nagRightItemType = 1;
    }
    else {
        if (self.nagRightItemType == 1) {
            self.nagRightItemType = 0;
        }
    }
}

@end