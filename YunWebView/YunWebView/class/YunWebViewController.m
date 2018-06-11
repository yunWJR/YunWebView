//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import "YunWebViewController.h"
#import "BdWebVc.h"
#import "BdScanWebModel.h"
#import "YwvVcQueryModel.h"
#import "YunSystemMediaHelper.h"
#import "YunURLHelper.h"
#import "BdFmlFxL1Vc.h"
#import "BdFmlFxL2AmtVc.h"
#import "BdFmlFxL2NorVc.h"
#import "BdFmlFxL3Vc.h"
#import "YunSelectImgHelper.h"
#import "BdActionListSelectHelper.h"
#import "UIImage+YYAdd.h"
#import "BdHomeVcHelper.h"
#import "BdAcctMg.h"
#import "AlertHelper.h"
#import "BdAppDelegate.h"
#import "BdFmlFxAddBdBtn2.h"
#import "BdScanVc.h"
#import "BdShareRqt.h"
#import "YunAppViewController+BlankView.h"
#import "YunAppViewController+ErrorHlp.h"
#import "BdShareHelper.h"
#import "BdUserModel.h"
#import "BdFmlFxHelper.h"
#import "BdBlankView.h"
#import "BdDefine.h"
#import "BdShowDebugMsgHudView.h"
#import "BdHomeNv.h"
#import "BdFamilyDetailsVc.h"
#import "BdHNv.h"
#import "YunSizeHelper.h"

// 超时时间
NSInteger const rqtTimeOut = 10;

#define isLocUrl NO

@interface YunWebViewController () <WKNavigationDelegate, WKUIDelegate, YunSelectImgDelegate> {
    YunSelectImgHelper *_selHelper;

    BdFmlFxAddBdBtn2 *_scanBtn;

    UIButton *shareBtn;
    UIButton *closeBtn;

    BOOL _pageLoadCmp;
    BdBlankView *_rqtTimeOutView;

    UIButton *testBtn;

    BOOL _isLastVc;
}

@end

@implementation YunWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNagBackItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.isDemon) {
        if (self.urlHost == YwvHost_L1Nor) {
            [BdFmlFxHelper.instance hiddenAd];

            if (_isLastVc) {
                [BdFmlFxHelper.instance terminalAd];
            }
        }
    }
}

- (void)dealloc {
    if (_webView) {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark - yun app

// 初始化数据
- (void)initVcData {
    [super initVcData];

    self.hideNagBarBtmLine = YES;
}

// 初始化 view
- (void)initVcSubViews {
    [super initVcSubViews];

    [self initDefBlankView];

    WKWebViewConfiguration *webCfg = [[WKWebViewConfiguration alloc] init];
    webCfg.userContentController = [WKUserContentController new];

    WKPreferences *webPre = [WKPreferences new];
    webPre.javaScriptCanOpenWindowsAutomatically = YES;
    webCfg.preferences = webPre;

    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webCfg];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;

    [self.view addSubview:_webView];

    //self.view.backgroundColor = UIColor.greenColor;
    //_webView.backgroundColor = UIColor.blueColor;

    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(@(YunSizeHelper.screenWidth));
        make.bottom.equalTo(self.view);
    }];

    //添加属性监听
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    //进度条
    UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];

    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = YunAppTheme.colorBaseHl.CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;

    WEAK_SELF
    _scanBtn = [BdFmlFxAddBdBtn2 new];
    _scanBtn.hidden = YES;
    _scanBtn.didItemOn = ^(AddBdType type) {
        [weakSelf handleFunItemOn:type];
    };

    [self.view addSubview:_scanBtn];

    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-self.topOff);
        make.right.equalTo(self.view).offset(-self.sideOff);
    }];
}

// ViewWillAppear
- (void)handleViewWillAppear {
    [super handleViewWillAppear];

    //return; // todo 暂时屏蔽
    if (self.firstLoad) {
        [self showLoadView:YES];
        DP_AFTER_MAIN_QUEUE(rqtTimeOut, ^{
            [self showRqtTimeOutView];
        })
    }
}

// ViewDidAppear
- (void)handleViewDidAppear {
    [super handleViewDidAppear];
}

// ViewDidDisappear
- (void)handleViewDidDisappear {
    [super handleViewDidDisappear];
}

// 从服务器加载数据
- (void)loadDataFromServer {
    [super loadDataFromServer];
}

// 从服务器加载更多数据
- (void)loadMoreDataFromServer {
    [super loadMoreDataFromServer];
}

// 更新 Vc 的状态（可以在加载完成时调用）
- (void)updateVcState {
    [super updateVcState];
}

// 开始更新 Vc 状态（实现该方法，updateVcState 时会触发）
- (void)updateVcStateOn {
    [super updateVcStateOn];

    if (_isDemon) {
        [self initDemonBtn];
    }

    if (!_isLoc && _urlHost == YwvHost_L1Nor) {
        return;
    }

    if (_urlHost == YwvHost_L1Nor && _isLoc) {
        if (isLocUrl) {
            NSString *deUrl =
                    @"http://192.168.0.136/?familyReportId=17110317560451&token=5f2f90a87f123b3676eb196f6ba7aa11279347101b8dd3986363c42d4adee9a4902e09dc7539d25e&memberId=null";
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:deUrl]]];
        }
        else {
            // 可以在HTML内通过相对目录的方式加载js,css,img等文件
            NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"jtfxdemon" ofType:@"bundle"];
            NSBundle *bd = [NSBundle bundleWithPath:strResourcesBundle];

            NSString *htmlPath = [bd pathForResource:@"index.min" ofType:@"html"];
            NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            NSString *path = [bd bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];  // 通过baseURL的方式加载的HTML

            [_webView loadHTMLString:appHtml baseURL:baseURL];
        }
    }
    else {
        if (_isLoc) {
            if (isLocUrl) {
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_queryData.viewUrl]]];
            }
            else {
                NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"jtfxdemon" ofType:@"bundle"];
                NSBundle *bd = [NSBundle bundleWithPath:strResourcesBundle];

                NSString *fileName = [self getLocFile:_queryData.viewUrl];
                NSString *htmlPath = [bd pathForResource:fileName ofType:@"html"];

                NSString *query = [self getLocQuery:_queryData.viewUrl];
                NSURL *url = [NSURL URLWithString:query relativeToURL:[NSURL fileURLWithPath:htmlPath]];

                [_webView loadRequest:[NSURLRequest requestWithURL:url]];
            }
        }
        else {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_queryData.viewUrl]]];
        }
    }

    [self setNavTitle:_queryData.nagTitle];

    if (_queryData.backTitle) {
        [self setLeftBarItemName:_queryData.backTitle];
        [self setNagItemIsLeft:YES cl:nil ft:nil];
    }

    [self initViewState];
}

// 状态更新完成（隐藏一些加载框等）（实现该方法，updateVcState 时会触发）
- (void)updateVcStateCmp {
    [super updateVcStateCmp];
}

// 是否加载数据
- (BOOL)shouldLoadData {
    [self setShareStyle];

    [self showDmAd];

    [self setTest];

    // self.needUpdateData = YES; 一直都加载
    return [super shouldLoadData];
}

#pragma mark - handle

- (void)didClickNagLeftItem {
    if (_queryData && _queryData.goBackModel && _webView.canGoBack) {
        [_webView goBack];
    }
    else {
        [self gotoBackVc];
    }
}

- (void)didClickNagRightItem {
    // share
    if ([YunValueVerifier isValidStr:self.queryData.familyId]) {
        BdShareRqt *rqt = [BdShareRqt new];
        [self showLoadView:NO];

        if ([YunValueVerifier isValidStr:self.queryData.memberId]) {
            [rqt getMemberExcelShareConfig:self.queryData.familyId
                                     mebId:self.queryData.memberId
                                   success:^(BdShareComModel *data) {
                                       [self hideLoadView];

                                       [BdShareHelper.instance shareByType:BdShareFamilyRpExcel
                                                                     busId:self.queryData.familyId
                                                                      data:data
                                                                       cmp:^(BOOL suc) {
                                                                       }];
                                   }
                                   failure:^(YunErrorHelper *error) {
                                       [self showRqtError:error];
                                   }];
        }
        else {
            [rqt getFamilyExcelShareConfig:self.queryData.familyId
                                   success:^(BdShareComModel *data) {
                                       [self hideLoadView];

                                       [BdShareHelper.instance shareByType:BdShareFamilyRpExcel
                                                                     busId:self.queryData.familyId
                                                                      data:data
                                                                       cmp:^(BOOL suc) {
                                                                       }];
                                   }
                                   failure:^(YunErrorHelper *error) {
                                       [self showRqtError:error];
                                   }];
        }

        return;
    }

    [AlertHelper.instance showYesMsg:@"分析参数错误"];
}

- (void)gotoBackVc {
    if (!self.isHState) {
        [self loadOther];
    }

    if (self.isHState) {
        _webView.hidden = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        if (self.isDemon) {
            [super didClickNagLeftItem];

            [BdFmlFxHelper.instance hiddenAd];

            _isLastVc = YES;
            [BdFmlFxHelper.instance terminalAd];
        }
        else {
            [super didClickNagLeftItem];
        }
    }
}

- (void)loadOther {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%@", change);
        self.progressLayer.opacity = 1;
        self.progressLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width *
                                                    [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (.2 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(),
                           ^{
                               self.progressLayer.opacity = 0;
                           });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (.8 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(),
                           ^{
                               self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
                           });
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handleLocUrl:(NSString *)url {
    NSLog(@"LocUrl:%@", url);
}

- (void)handleCustomAction:(NSURL *)url {
    NSString *host = [url host];
    YunWebViewHostType hType = [YunWebViewDefine getHostType:host];
    if (hType == YwvHost_UnKnown) {
        return;
    }

    if (hType == YwvHost_shareFml) {
        [self didClickNagRightItem];

        return;
    }

    if (hType == YwvHost_closeView) {
        [self gotoBackVc];

        return;
    }

    if (hType == YwvHost_setDataUpdate) {
        [BdHomeVcHelper.instance updateBdFmlNeedUpdate];

        return;
    }

    if (hType == YwvHost_Img_SelectImg) {
        [self startSelectImg];

        return;
    }

    if (hType == YwvHost_js_setBackViewUpdate) {
        //self.shouldCallWebUpdate = YES;
        if (self.backFxVc) {
            [self.backFxVc handleViewJs:YwvHost_js_setBackViewUpdate];
        }

        return;
    }

    if (hType == YwvHost_js_setBackSecChange) {
        //self.shouldCallWebUpdate = YES;
        if (self.backFxVc) {
            [self.backFxVc handleViewJs:YwvHost_js_setBackSecChange];
        }

        [self gotoBackVc];

        return;
    }

    if (hType == YwvHost_setLeftNagOn) {
        self.navigationItem.leftBarButtonItem = self.leftNagItem;

        return;
    }

    if (hType == YwvHost_setLeftNagHidden) {
        UIBarButtonItem *nItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = nItem;

        return;
    }

    NSString *urlStr;
    NSString *query = [url query];
    NSRange range = [query rangeOfString:@"goUrl"];

    NSString *newQr = nil;
    if (range.location != NSNotFound) {
        NSString *urlQr = [query substringFromIndex:range.location];

        urlStr = [urlQr substringFromIndex:6];

        newQr = [query substringToIndex:range.location];
    }
    else {
        NSLog(@"Not Found");
        newQr = query;
    }

    NSDictionary *qDic = [YunURLHelper dicFromQuery:newQr];
    id hasShare = qDic[@"hasShare"];
    if (hasShare) {
        if ([hasShare isKindOfClass:NSString.class]) {
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:qDic];

            BOOL hasV = [hasShare isEqualToString:@"1"];

            newDic[@"hasShare"] = @(hasV);

            qDic = newDic;
        }
    }

    YwvVcQueryModel *qData = [YwvVcQueryModel modelWithData:qDic];
    if (urlStr) {
        qData.viewUrl = urlStr;
    }

    YunWebViewController *vc = [YunWebViewController new];
    switch (hType) {
        case YwvHost_L1Nor: {
            vc = [BdFmlFxL1Vc new];
            qData.hasShare = YES;
        }
            break;
        case YwvHost_L2Nor: {
            vc = [BdFmlFxL2NorVc new];
            vc.hasFunBtn = YES;
        }
            break;
        case YwvHost_L2Share: {
            vc = [BdFmlFxL2NorVc new];
            vc.hasFunBtn = YES;
            qData.hasShare = YES;
        }
            break;
        case YwvHost_L2DhEdit: {
            vc = [BdFmlFxL3Vc new];
            qData.backTitle = @"<保存并退出";
        }
            break;
        case YwvHost_L2DhPre: {
            vc = [BdFmlFxL2AmtVc new];
        }
            break;
        case YwvHost_L3Nor: {
            vc = [BdFmlFxL3Vc new];
        }
            break;
        case YwvHost_Max:
            break;
        case YwvHost_SetTitle: {
            [self setNavTitle:qData.nagTitle];
            return;
        }
        case YwvHost_SetSharePara: {
            self.queryData.familyId = qData.familyId;
            self.queryData.memberId = qData.memberId;

            [self setShareStyle];

            return;
        }
        case YwvHost_setErrorCode: {
            if (qData.errorCode == YunErrTypeOutOfLogin) {
                [BdAcctMg.instance remove];

                [[AlertHelper instance] showYesMsg:@"登录已过期，请重新登录" result:^{
                    [BdAppDelegate.appDelegate initRootVc];
                }];
                return;
            }
        }
            break;
        case YwvHost_func_btn_on: {
            [self setFuncBtnOn:[qData.isOn isEqualToString:@"1"]];
            return;
        }
        case YwvHost_open_fml_bd: {
            BdFamilyDetailsVc *fmlDtVc = [BdFamilyDetailsVc new];
            fmlDtVc.familyId = qData.familyId;
            fmlDtVc.mebId = qData.memberId;
            fmlDtVc.bdInfoId = qData.bdInfoId;
            fmlDtVc.isModalVc = YES;

            BdHomeNv *nv = [BdHomeNv nvWithVc:fmlDtVc];

            [self presentViewController:nv
                               animated:YES
                             completion:nil];

            return;
        }
        case YwvHost_UnKnown:
            break;
        case YwvHost_Img_SelectImg:
            break;
        case YwvHost_js_setBackViewUpdate:
            break;
        case YwvHost_setDataUpdate:
            break;
        case YwvHost_js_setBackSecChange:
            break;
        case YwvHost_setLeftNagOn:
            break;
        case YwvHost_setLeftNagHidden:
            break;
        case YwvHost_L3H:
            vc = [BdFmlFxL3Vc new];
            vc.isHState = YES;
            vc.hasFunBtn = YES;
            break;
        case YwvHost_closeView:
            break;
        case YwvHost_shareFml:
            break;
        case YwvHome_load_cmp:
            [self pageLoadCmp];
            return;
    }

    vc.urlHost = hType;
    vc.queryData = qData;
    vc.isLoc = self.isLoc;
    vc.isDemon = self.isDemon;
    vc.backVC = self;

    vc.backFxVc = self;
    if (vc.isHState) {
        vc.hideNagBar = YES;
        //BdH2Nv *hNv = [BdH2Nv nvWithVc:vc]; // 输入键盘问题 暂时由网页弹出键盘

        BdHNv *hNv = [BdHNv nvWithVc:vc]; // 输入键盘问题 暂时由网页弹出键盘

        [BdHomeVcHelper.instance.getCurrentVC presentViewController:hNv
                                                           animated:YES
                                                         completion:nil];
    }
    else {
        if (self.isHState) {
            vc.isModalVc = YES;
            BdHomeNv *hNv = [BdHomeNv nvWithVc:vc]; // 输入键盘问题 暂时由网页弹出键盘
            [self presentViewController:hNv
                               animated:YES
                             completion:nil];
        }
        else {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)setFuncBtnOn:(BOOL)on {
    closeBtn.hidden = !on;
    shareBtn.hidden = !on;
}

- (void)setShareStyle {
    BOOL hasS = _queryData.hasShare && [YunValueVerifier isValidStr:_queryData.familyId];

    if (self.isHState) {
        shareBtn.hidden = !hasS;
    }
    else {
        [self setNagItemIsLeft:NO type:hasS ? NagItemShare : NagItemNone];
    }
}

// add btn
- (void)handleFunItemOn:(AddBdType)type {
    switch (type) {
        case AddBdTypeNone:
            break;
        case AddBdTypeScan:
            if (self.isHState) { // 横屏模式
                [BdScanVc gotoScanVc:self];
                return;
            }
            else {
                [BdScanVc gotoScanVc:self];
            }
            break;
        case AddBdTypeScanWeb:
            //[BdScanWebVc gotoScanWebVc:self.navigationController];
            break;
        case AddBdTypeSip:
            //[BdAddSimpleBdVc gotoAddSipVc:self.navigationController];
            break;
    }
}

// page load

- (void)pageLoadCmp {
    _pageLoadCmp = YES;

    if (_rqtTimeOutView) {
        [_rqtTimeOutView removeFromSuperview];
        _rqtTimeOutView.hidden = YES;
    }

    [self hideLoadView];
}

- (void)showRqtTimeOutView {
    if (_pageLoadCmp) {
        [self pageLoadCmp];
        return;
    }

    if (_rqtTimeOutView == nil) {
        _rqtTimeOutView = [BdBlankView itemWithMsg:@"加载数据失败，请检查网络后重试！"
                                               img:@"blank_nor_error" // todo
                                          btnTitle:@"点击重试" btnTag:1];
        _rqtTimeOutView.backgroundColor = YunAppTheme.colorBaseWhite;
        [_rqtTimeOutView setBgColor:YunAppTheme.colorBaseWhite];
        WEAK_SELF
        _rqtTimeOutView.didBtnClick = ^(NSInteger btnTag) {
            [weakSelf updateVcState];
        };
    }

    [self.view addSubview:_rqtTimeOutView];

    [_rqtTimeOutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}

#pragma mark - request functions

#pragma mark - public functions

- (void)initViewState {
    if (self.isHState) {
        [self initHState];
    }

    [self setShareStyle];

    _scanBtn.hidden = !self.hasFunBtn;
    _scanBtn.hidden = YES; // 扫描按钮暂时不需要
}

- (void)initHState {
    if ([self.class isKindOfClass:BdFmlFxL2AmtVc.class]) {
        return;
    }

    CGFloat btnW = 60;
    CGFloat topO = 80;

    [_scanBtn removeFromSuperview];

    [self.view addSubview:_scanBtn];

    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.right.equalTo(self.view).offset(-80);
        make.height.and.width.equalTo(@(_scanBtn.btnW));
    }];

    if (closeBtn == nil) {
        closeBtn = [YunUIButtonFactory btnWithImg:@"jtfx_b_关闭"
                                            scale:0.8
                                           target:self
                                           action:@selector(didClickNagLeftItem)];

        [self.view addSubview:closeBtn];

        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-topO);
            make.right.equalTo(self.view).offset(-40);
            make.height.equalTo(@(btnW));
            make.width.equalTo(@(btnW));
        }];
    }

    if (shareBtn == nil) {
        shareBtn = [YunUIButtonFactory btnWithImg:@"jtfx_b_分享"
                                            scale:0.8
                                           target:self
                                           action:@selector(didClickNagRightItem)];
        shareBtn.hidden = YES;

        [self.view addSubview:shareBtn];

        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(closeBtn);
            make.right.equalTo(closeBtn.mas_left).offset(-40);
            make.size.equalTo(closeBtn);
        }];
    }

    //closeBtn.backgroundColor = UIColor.orangeColor;
    //shareBtn.backgroundColor = UIColor.orangeColor;

    [self.view layoutIfNeeded];
}

- (void)handleViewJs:(YunWebViewHostType)type {
    NSString *jsGet = nil;

    if (type == YwvHost_js_setBackViewUpdate) {
        jsGet = @"should_update_data()";
    }
    else if (type == YwvHost_js_setBackSecChange) {
        jsGet = @"goSlideToPage()";
    }

    if (jsGet) {
        [_webView evaluateJavaScript:jsGet
                   completionHandler:^(id _Nullable htmlStr, NSError *_Nullable error) {
                       if (error) {
                           [YunLogHelper logMsg:FORMAT(@"JSError:%@", error)];
                       }
                   }];
    }
}

- (void)setMyPhone {
    NSString *p = BdAcctMg.instance.fetch.phone;
    NSString *name = BdAcctMg.instance.fetch.name;

    NSString *jsS = FORMAT(@"bdzg_set_my_info(%@,'%@')", [YunValueVerifier isInvalidStr:p] ? @"''" : p, name);
    //jsS= @"bdzg_set_my_info(12,'云')";
    //jsS = [jsS stringByRemovingPercentEncoding];

    [_webView evaluateJavaScript:jsS
               completionHandler:^(id _Nullable htmlStr, NSError *_Nullable error) {
                   if (error) {
                       [YunLogHelper logMsg:FORMAT(@"JSError:%@", error)];
                   }
               }];
}

#pragma mark - private functions

- (void)startSelectImg {
    if (_selHelper == nil) {
        _selHelper = [YunSelectImgHelper new];
        _selHelper.delegate = self;
        _selHelper.superVC = self;
        _selHelper.maxCount = 1;
        _selHelper.isCompression = YES;
        _selHelper.disAmt = NO;
        _selHelper.imgLength = 200;
        _selHelper.imgBoundary = 1280;
        //_selHelper.editImg = YES;
    }

    _selHelper.selType = YunImgSelByCameraAndPhotoAlbum;
    [_selHelper selectImg:0];
}

- (NSString *)getLocFile:(NSString *)url {
    NSRange r = [url rangeOfString:@"?"];

    NSString *file;
    if (r.location != NSNotFound) {
        file = [url substringToIndex:r.location];
    }
    else {
        file = url;
    }

    if ([file hasSuffix:@".html"]) {
        file = [file substringToIndex:file.length - 5];
    }

    return file;
}

- (NSString *)getLocQuery:(NSString *)url {
    NSRange r = [url rangeOfString:@"?"];

    NSString *query = @"";
    if (r.location != NSNotFound) {
        query = [url substringFromIndex:r.location];
    }

    return query;
}

#pragma mark - demon

- (void)initDemonBtn {
    return; // 不需要
}

- (void)didClickDemon {
    // 开始使用
    [BdHomeVcHelper initRootForHomeVc];
}

- (void)showDmAd {
    if (_isDemon) {
        if (self.urlHost == YwvHost_L2DhEdit ||
            self.urlHost == YwvHost_L2DhPre) {
            [BdFmlFxHelper.instance hiddenAd];
        }
        else {[BdFmlFxHelper.instance showMjAd];}
    }
    else {
        [BdFmlFxHelper.instance terminalAd];
    }
}

#pragma mark - protocol

#pragma mark - YunSelectImgDelegate

- (void)selectImgByType:(void (^)(YunSelectImgType type))cmp {
    [BdActionListSelectHelper selectPicType:cmp];
}

- (void)didCmp:(BOOL)cmp imgs:(NSArray *)imgs selType:(YunSelectImgType)selType {
    if (imgs.count == 1) {
        UIImage *image = [UIImage imgWithObj:imgs[0]];

        if (image == nil) {
            return;
        }

        if (image.imageOrientation == 3) {
            image = [image imageByRotateRight90];
        }

        NSString *imgB64 = [UIImagePNGRepresentation(image)
                base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *imgInfo = FORMAT(@"data:image/png;base64,%@", imgB64);
        NSString *jsGet = FORMAT(@"bdzg_select_img('%@','%@')", imgInfo, @"");
        [_webView evaluateJavaScript:jsGet
                   completionHandler:^(id _Nullable htmlStr, NSError *_Nullable error) {
                       if (error) {
                           [YunLogHelper logMsg:FORMAT(@"JSError:%@", error)];
                       }
                   }];
    }
}

#pragma mark - UIWebViewDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [YunLogHelper logMsg:@"didStartProvisionalNavigation"];

    NSString *path = [webView.URL absoluteString];
    NSString *newPath = [path lowercaseString];
    if ([newPath hasPrefix:@"sms:"]) {
        NSMutableString *mPhone = [[NSMutableString alloc] initWithString:newPath];
        NSString *phone = [mPhone substringWithRange:NSMakeRange(4, newPath.length - 4)];
        [YunSystemMediaHelper openSms:phone];

        return;
    }

    if ([newPath hasPrefix:@"tel:"]) {
        NSMutableString *mPhone = [[NSMutableString alloc] initWithString:newPath];
        NSString *phone = [mPhone substringWithRange:NSMakeRange(4, newPath.length - 4)];
        [YunSystemMediaHelper openPhone:phone];

        return;
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    [YunLogHelper logMsg:@"didCommitNavigation"];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [YunLogHelper logMsg:@"didFinishNavigation"];

    [self setMyPhone];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error {
    [YunLogHelper logMsg:@"didFailNavigation"];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [YunLogHelper logMsg:@"decidePolicyForNavigationAction"];

    if (navigationAction == nil) {
        [webView loadRequest:navigationAction.request];
    }

    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"bdzg"]) {
        [self handleCustomAction:URL];

        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    [YunLogHelper logMsg:@"decidePolicyForNavigationResponse"];

    if ([webView.URL.absoluteString hasPrefix:@"itms-services"]) {
        decisionHandler(WKNavigationResponsePolicyCancel);

        return;
    }

    if ([webView.URL.absoluteString hasPrefix:@"bdzg_view:"]) {
        decisionHandler(WKNavigationResponsePolicyCancel);

        [self handleLocUrl:webView.URL.absoluteString];

        return;
    }

    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 接收到服务器跳转请求之后调用
- (void)                                 webView:(WKWebView *)webView
didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [YunLogHelper logMsg:@"didReceiveServerRedirectForProvisionalNavigation"];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error {
    [YunLogHelper logMsg:@"didFailProvisionalNavigation"];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [YunLogHelper logMsg:@"webViewWebContentProcessDidTerminate"];
}

#pragma mark - private WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
   forNavigationAction:(WKNavigationAction *)navigationAction
        windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }

    return nil;
}

- (BOOL)prefersStatusBarHidden {
    return self.isHState;
}

// test

- (void)setTest {
    if (FML_FX_TEST) {
        if (testBtn == nil) {
            testBtn = [YunUIButtonFactory btnWithTitle:@"测试按钮"
                                            titleColor:UIColor.whiteColor
                                               bgColor:YunAppTheme.colorBaseAlert
                                                target:self
                                                action:@selector(didClickTest)];

            [self.view addSubview:testBtn];

            [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view).offset(-10);
                make.centerY.equalTo(self.view);
                make.width.height.equalTo(@80);
            }];
        }
    }
}

- (void)didClickTest {
    [BdShowDebugMsgHudView show:@"页面内容" ctn:_webView.URL.absoluteString];

    return;

    NSString *jsGet = @"document.body.outerHTML";

    [_webView evaluateJavaScript:jsGet
               completionHandler:^(id _Nullable htmlStr, NSError *_Nullable error) {
                   if (error) {
                       [YunLogHelper logMsg:FORMAT(@"JSError:%@", error)];
                   }
                   [YunLogHelper logMsg:FORMAT(@"html:%@", htmlStr)];

                   [BdShowDebugMsgHudView show:@"页面内容" ctn:htmlStr];
               }];
}

@end