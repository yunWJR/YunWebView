//
// Created by yun on 2018/6/13.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YwvImgItem.h"

@interface YwvImgList : JSONModel

@property (nonatomic, strong) NSArray <YwvImgItem *> *imgList;

@end