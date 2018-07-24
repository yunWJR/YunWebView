//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "YwvImgQueryModel.h"
#import <YunKits/YunGlobalDefine.h>
#import <YunBaseApp/YunLogHelper.h>

@implementation YwvImgQueryModel

+ (instancetype)modelWithData:(id)data {
    NSError *modelErr;
    YwvImgQueryModel *model = [[YwvImgQueryModel alloc] initWithDictionary:data error:&modelErr];

    if (modelErr) {
        [YunLogHelper logMsg:FORMAT(@"model_error:%@", modelErr)];
        return nil;
    }
    else {return model;}
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (YunSelectImgType)yunImgType {
    if (_imgSelType == 0) {
        return YunImgSelByCameraAndPhotoAlbum;
    }
    else if (_imgSelType == 1) {
        return YunImgSelByPhotoAlbum;
    }

    else if (_imgSelType == 2) {
        return YunImgSelByCamera;
    }

    return YunImgSelByPhotoAlbum;
}

- (NSInteger)yunImgCount {
    if (_imgSelCount <= 0) {
        return 1;
    }

    return _imgSelCount;
}

- (BOOL)yunImgCmpr {
    return _imgCompSize >= 0;
}

- (NSInteger)yunImgCmprLength {
    if (_imgCompSize <= 0) {
        return 300;
    }

    return _imgCompSize;
}

@end