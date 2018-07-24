//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "YwvVcQueryModel.h"
#import <YunKits/YunGlobalDefine.h>
#import <YunBaseApp/YunLogHelper.h>

@implementation YwvVcQueryModel

+ (instancetype)modelWithData:(id)data {
    NSError *modelErr;
    YwvVcQueryModel *model = [[YwvVcQueryModel alloc] initWithDictionary:data error:&modelErr];

    if (modelErr) {
        [YunLogHelper logMsg:FORMAT(@"model_error:%@", modelErr)];
        return nil;
    }
    else {return model;}
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (BOOL)isShowLoadView {
    return _viewLoadType == 0;
}

@end