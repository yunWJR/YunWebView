//
// Created by yun on 2018/6/11.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YunWebViewController;

@protocol YunSelectImgDelegate;

@protocol YunWebViewConfigDelegate <NSObject>

- (NSArray< UIViewController *> *)curViewControllers;

- (UIViewController *)getCurrentVc;

- (void)shouldInitRootVc;

// 临时
- (void)setNagBackItem:(YunWebViewController *)webView;

@end

@interface YunWebViewConfig : NSObject

@property (nonatomic, copy) NSString *schemeName;

@property (nonatomic, copy) NSString *jsNamePre;

@property (nonatomic, copy) NSString *webUrlName;

// 超时时间
@property (nonatomic, assign) NSInteger rqtTimeOut;

// 显示进度条
@property (nonatomic, assign) BOOL showProg;

@property (nonatomic, assign) BOOL testButton;

@property (nonatomic, weak) id <YunWebViewConfigDelegate> delegate;

// 选择图片 delegate，需要选择图片类型的时候需要实现
@property (nonatomic, weak) id <YunSelectImgDelegate> selImgDelegate;

+ (instancetype)instance;

@end