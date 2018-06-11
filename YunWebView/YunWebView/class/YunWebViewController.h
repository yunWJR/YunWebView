//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import "YunAppViewController.h"
#import "YunWebViewDefine.h"
#import <WebKit/WebKit.h>

@class YwvVcQueryModel;

@interface YunWebViewController : YunAppViewController

@property (nonatomic, assign) BOOL isHState;

@property (nonatomic, assign) BOOL isDemon;

@property (nonatomic, assign) BOOL shouldCallWebUpdate;

@property (nonatomic, assign) BOOL hasFunBtn;

// data
@property (nonatomic, assign) BOOL isLoc;

@property (nonatomic, assign) YunWebViewHostType urlHost;

@property (nonatomic, strong) YwvVcQueryModel *queryData;

@property (nonatomic, weak) YunWebViewController *backFxVc;

// view
@property (nonatomic, strong) WKWebView *webView;

@property (weak, nonatomic) CALayer *progressLayer;

// VC
@property (nonatomic, weak) UIViewController *preBaseVc;

- (void)setShareStyle;

- (void)initViewState;

- (void)handleViewJs:(YunWebViewHostType)type;

@end