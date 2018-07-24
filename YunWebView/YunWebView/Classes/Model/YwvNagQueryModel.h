//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import "JSONModel.h"

@interface YwvNagQueryModel : JSONModel

// ---nag---

// 是否隐藏导航栏：
// 0-不隐藏--默认
// 1-隐藏
@property (nonatomic, assign) BOOL nagIsHidden;

// 导航栏标题：
// 必须设置，不设置值则为null
@property (nonatomic, copy) NSString *nagTitle;

// 导航栏左侧按钮类型：
// 0-返回--默认
// 1-文字： 需要设置nagLeftItemName的值
// 2-隐藏：
// 3、4、5...自定义类型。
@property (nonatomic, assign) NSInteger nagLeftItemType;

// 导航栏左侧按钮名称：类型需要设置为1
@property (nonatomic, copy) NSString *nagLeftItemName;

// 导航栏左侧按钮响应类型：
// 0-自动导航：默认（检测是否可以返回上一页，可以则返回上一页，不可以则退出页面）
// 1-直接退出：直接退出页面
// 2-js响应：点击左侧按钮时，调用 js，由页面处理响应方法
@property (nonatomic, assign) NSInteger nagLeftItemHandleType;

// 导航栏右侧按钮类型：
// 0-隐藏--默认
// 1-文字： 需要设置nagRightItemName的值
// 2、3、4、5...自定义类型。
@property (nonatomic, assign) NSInteger nagRightItemType;

// 导航栏右侧按钮名称：类型需要设置为1
@property (nonatomic, copy) NSString *nagRightItemName;

+ (instancetype)modelWithData:(id)data;

- (void)reform;

@end

