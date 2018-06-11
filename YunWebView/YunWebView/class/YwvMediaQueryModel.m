//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "YwvMediaQueryModel.h"
#import <YunKits/YunGlobalDefine.h>
#import <YunBaseApp/YunLogHelper.h>

@implementation YwvMediaQueryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mapping = [[NSDictionary mtl_identityPropertyMapWithModel:self] mutableCopy];
    return mapping;
}

+ (instancetype)modelWithData:(id)data {
    NSError *modelErr;
    YwvMediaQueryModel *model =  [MTLJSONAdapter modelOfClass:YwvMediaQueryModel.class
                                           fromJSONDictionary:data
                                                        error:&modelErr];

    if (modelErr) {
        [YunLogHelper logMsg:FORMAT(@"model_error:%@", modelErr)];
        return nil;
    }
    else {return model;}
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;

    return self;
}

@end