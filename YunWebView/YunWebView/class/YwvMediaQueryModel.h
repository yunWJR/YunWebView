//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <Mantle/Mantle.h>

@interface YwvMediaQueryModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *mdPhone;

@property (nonatomic, copy) NSString *mdUrl;

+ (instancetype)modelWithData:(id)data;

@end