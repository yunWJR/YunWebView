//
// Created by yun on 2018/6/13.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import <YunKits/YunSizeHelper.h>
#import "YwvImgItem.h"
#import "UIImage+YunAdd.h"
#import "UIImage+Rotate.h"

@interface YwvImgItem () {
}

@end

@implementation YwvImgItem

+ (instancetype)itemWithImgSrc:(UIImage *)img thumb:(BOOL)thumb {
    YwvImgItem *item = [YwvImgItem new];

    if (img.imageOrientation == 3) {
        img = [img imageByRotateRight90];
    }

    NSString *imgB64 = [UIImagePNGRepresentation(img)
            base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    item.img = imgB64;

    if (thumb) {
        UIImage *thumbImg = [img resizeByMaxBd:YunSizeHelper.screenWidth * 0.5f];
        NSString *thumbImgB64 = [UIImagePNGRepresentation(thumbImg)
                base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

        item.thumb = thumbImgB64;
    }

    return item;
}


@end