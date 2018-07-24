//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import "YunAppViewController.h"
#import "YunWebViewDefine.h"

@class YwvVcQueryModel;
@class YwvNagQueryModel;
@class WKWebView;

@interface YunWebViewController : YunAppViewController

@property (nonatomic, assign) BOOL isHState;

@property (nonatomic, assign) BOOL webShouldUpdateData;

@property (nonatomic, strong) YwvVcQueryModel *vcData;

@property (nonatomic, strong) YwvNagQueryModel *nagData;

// view
@property (nonatomic, strong) WKWebView *webView;

@property (weak, nonatomic) CALayer *progressLayer;

- (void)initViewState;

- (void)handleViewJs:(YunWebViewHostType)type;

@end