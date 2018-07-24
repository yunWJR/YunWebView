//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <YunImgView/YunImgDef.h>
#import "JSONModel.h"

@interface YwvImgQueryModel : JSONModel

// 选择图片的类型：
// 0-可以从相册/相机选择 --默认
// 1-只能从相册选择
// 2-只能从相机选择
@property (nonatomic, assign) NSInteger imgSelType;

// 可选择图片的数量：
// 0-默认值，表示选择一张，相当于1。
// 1-xx,可选择具体数量
@property (nonatomic, assign) NSInteger imgSelCount;

// 是否编辑图片：只适用于imgSelCount=1的情况
// 0-不编辑
// 1-可编辑
@property (nonatomic, assign) BOOL imgCanEdit;

// 照片压缩大小:kb
// 0-300kb--默认
// -1-不压缩，使用原图
// 其他(1->xx)-自定义值，单位 kb
@property (nonatomic, assign) NSInteger imgCompSize;

// 是否保存图片：
// 只适用于相册拍照的情况
// 0-不保存--默认
// 1-保存
@property (nonatomic, assign) BOOL imgSaveToAlbum;

// 是否生成缩略图
// 0-不生成--默认
// 1-生成缩略图
@property (nonatomic, assign) BOOL imgGetThumb;

+ (instancetype)modelWithData:(id)data;

- (YunSelectImgType)yunImgType;

- (NSInteger)yunImgCount;

- (BOOL)yunImgCmpr;

- (NSInteger)yunImgCmprLength;

@end