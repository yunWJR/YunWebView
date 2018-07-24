//
// Created by yun on 2018/6/15.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import <YunBaseApp/YunLogHelper.h>
#import "YwvFontQueryModel.h"
#import "YunGlobalDefine.h"

@interface YwvFontQueryModel () {
}

@end

@implementation YwvFontQueryModel

+ (instancetype)modelWithData:(id)data {
    NSError *modelErr;
    YwvFontQueryModel *model = [[YwvFontQueryModel alloc] initWithDictionary:data error:&modelErr];

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