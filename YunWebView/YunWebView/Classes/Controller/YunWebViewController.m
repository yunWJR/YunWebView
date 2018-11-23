//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import <YunKits/YunConfig.h>
#import <WebKit/WebKit.h>
#import <YunBaseApp/YunAccountMgHelper.h>
#import "YunWebViewController.h"
#import "YwvVcQueryModel.h"
#import "YunSystemMediaHelper.h"
#import "YunURLHelper.h"
#import "YunSelectImgHelper.h"
#import "YunAppViewController+CoverView.h"
#import "YunCoverView.h"
#import "YwvNagQueryModel.h"
#import "YunHomeNv.h"
#import "YunHNv.h"
#import "YunSizeHelper.h"
#import "YunWebViewConfig.h"
#import "YwvMediaQueryModel.h"
#import "YwvImgQueryModel.h"
#import "YwvImgItem.h"
#import "YwvImgList.h"
#import "YwvErrorQueryModel.h"
#import "YwvHelper.h"
#import "YwvFontQueryModel.h"
#import "YunAlertViewHelper.h"
#import "YunAccountMg.h"

@interface YunWebViewController () <WKNavigationDelegate, WKUIDelegate, YunSelectImgDelegate> {
    YunSelectImgHelper *_selHelper;

    BOOL _pageLoadCmp;
    YunCoverView *_rqtTimeOutView;

    UIButton *testBtn;

    YwvImgQueryModel *_imgData;
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

    [self setWebVcNagBackItem];
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

    //[self initDefBlankView];

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

    if (YunWebViewConfig.instance.showProg) {
        //进度条
        UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
        progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:progress];

        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 3);
        layer.backgroundColor = YunAppTheme.colorBaseHl.CGColor;
        [progress.layer addSublayer:layer];
        self.progressLayer = layer;
    }
}

// ViewWillAppear
- (void)handleViewWillAppear {
    [super handleViewWillAppear];

    if (self.firstLoad && _vcData.isShowLoadView) {
        [self showLoadView:YES];
        DP_AFTER_MAIN_QUEUE(YunWebViewConfig.instance.rqtTimeOut, ^{
            [self showRqtTimeOutView];
        })
    }

    if (_webShouldUpdateData) {
        [self handleViewJs:YwvHost_Vc_SetUpdate];
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

    [self updateVcState];
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

    [self updateNagStyle];

    [self loadRequest];
    //[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_vcData.viewUrl]]];

    [self initViewState];
}

// 状态更新完成（隐藏一些加载框等）（实现该方法，updateVcState 时会触发）
- (void)updateVcStateCmp {
    [super updateVcStateCmp];
}

// 是否加载数据
- (BOOL)shouldLoadData {
    [self setTest];

    // self.needUpdateData = YES; 一直都加载
    return [super shouldLoadData];
}

#pragma mark - handle

- (void)didClickNagLeftItem {
    if (_nagData.nagLeftItemHandleType == 0) {
        if (_webView.canGoBack) {
            [_webView goBack];
        }
        else {
            [self gotoBackVc];
        }
    }
    else if (_nagData.nagLeftItemHandleType == 1) {
        [self gotoBackVc];
    }
    else if (_nagData.nagLeftItemHandleType == 2) {
        NSString *jsGet = FORMAT(@"%@nag_leftItemOn()", YunWebViewConfig.instance.jsNamePre);

        [self jsFuncOn:jsGet];
    }
}

- (void)didClickNagRightItem {
    NSString *jsGet = FORMAT(@"%@nag_rightItemOn()", YunWebViewConfig.instance.jsNamePre);

    [self jsFuncOn:jsGet];
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
        [super didClickNagLeftItem];
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
        //NSLog(@"%@", change);
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
    [YunLogHelper logMsg:FORMAT(@"handleCustomAction:%@", url.absoluteString)];

    NSString *host = [url host];
    YunWebViewHostType hType = [YunWebViewDefine getHostType:host];
    if (hType == YwvHost_UnKnown) {
        return;
    }

    if (hType == YwvHost_Vc_Pop) {
        [super didClickNagLeftItem];
        return;
    }

    if (hType == YwvHost_Vc_Close) {
        [super didClickNagLeftItem];
        //[self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    if (hType == YwvHost_Vc_ShowLoad) {
        [self showLoadView:YES];
        return;
    }

    if (hType == YwvHost_Vc_LoadCmp) {
        [self handlePageLoadCmp];
        return;
    }

    NSString *urlStr;
    NSString *query = [url query];
    NSRange range = [query rangeOfString:YunWebViewConfig.instance.webUrlName];

    NSString *newQr = nil;
    if (range.location != NSNotFound) {
        NSString *urlQr = [query substringFromIndex:range.location];

        // +1 加上=
        urlStr = [urlQr substringFromIndex:YunWebViewConfig.instance.webUrlName.length + 1];

        // -1 去除&
        newQr = [query substringToIndex:range.location - 1];
    }
    else {
        NSLog(@"Not Found");
        newQr = query;
    }

    NSDictionary *qDic = [YunURLHelper dicFromQuery:newQr];

    //
    if (hType == YwvHost_md_openPhone ||
        hType == YwvHost_md_openSms ||
        hType == YwvHost_md_openMd) {
        YwvMediaQueryModel *mdData = [YwvMediaQueryModel modelWithData:qDic];

        [self handleMdType:hType mdDat:mdData];
        return;
    }

    if (hType == YwvHost_Img_SelectImg) {
        YwvImgQueryModel *imgData = [YwvImgQueryModel modelWithData:qDic];

        [self handleSelImg:imgData];
        return;
    }

    if (hType == YwvHost_Error_setError) {
        YwvErrorQueryModel *errData = [YwvErrorQueryModel modelWithData:qDic];

        [self handleErr:errData];
        return;
    }

    if (hType == YwvHost_Vc_UpdateId) {
        YwvVcQueryModel *imgData = [YwvVcQueryModel modelWithData:qDic];

        self.vcData.viewId = imgData.viewId;
        return;
    }

    if (hType == YwvHost_font_getFontName) {
        YwvFontQueryModel *fontData = [YwvFontQueryModel modelWithData:qDic];

        [self handleFont:hType fontData:fontData];

        return;
    }

    if (hType == YwvHost_Vc_SetUpdate) {
        YwvVcQueryModel *imgData = [YwvVcQueryModel modelWithData:qDic];

        if ([YunValueVerifier isValidStr:imgData.viewId]) {
            NSMutableArray<YunWebViewController *> *vcList = [YwvHelper.instance findAllByViewId:imgData.viewId];
            for (int i = 0; i < vcList.count; ++i) {
                YunWebViewController *vc = vcList[i];
                if (vc) {
                    vc.needUpdateData = YES;
                    if (vc.isAppear) {
                        [vc loadDataFromServer];
                    }
                }
            }
        }
        else {
            self.needUpdateData = YES;
            if (self.isAppear) {
                [self loadDataFromServer];
            }
        }

        return;
    }

    if (hType == YwvHost_Vc_SetWebUpdate) {
        YwvVcQueryModel *imgData = [YwvVcQueryModel modelWithData:qDic];

        if ([YunValueVerifier isValidStr:imgData.viewId]) {
            NSMutableArray<YunWebViewController *> *vcList = [YwvHelper.instance findAllByViewId:imgData.viewId];
            for (int i = 0; i < vcList.count; ++i) {
                YunWebViewController *vc = vcList[i];
                if (vc) {
                    vc.webShouldUpdateData = YES;
                    if (vc.isAppear) {
                        [vc handleViewJs:YwvHost_Vc_SetUpdate];
                    }
                }
            }
        }
        else {
            self.webShouldUpdateData = YES;
            if (self.isAppear) {
                [self handleViewJs:YwvHost_Vc_SetUpdate];
            }
        }

        return;
    }

    if (hType == YwvHost_Nag_UpdateStyle) {
        YwvNagQueryModel *nagData = [YwvNagQueryModel modelWithData:qDic];

        [self handleUpdateNag:nagData];
        return;
    }

    YwvVcQueryModel *vcData = [YwvVcQueryModel modelWithData:qDic];
    if (hType == YwvHost_Vc_SetViewKick) {
        _vcData.disableKick = vcData.disableKick;
        _vcData.disableScroll = vcData.disableScroll;

        _webView.scrollView.bounces = !_vcData.disableKick;
        _webView.scrollView.scrollEnabled = !_vcData.disableScroll;
        return;
    }

    if ([YunValueVerifier isValidStr:urlStr]) {
        vcData.viewUrl = urlStr;
    }
    else {
        [YunAlertViewHelper.instance showYes:@"跳转错误"];
        return;
    }

    YwvNagQueryModel *nagData = [YwvNagQueryModel modelWithData:qDic];

    YunWebViewController *vc = [YunWebViewController new];
    switch (hType) {
        case YwvHost_UnKnown:
            break;
        case YwvHost_Vc_Push:
            break;
        case YwvHost_Vc_Pop:
            break;
        case YwvHost_Vc_Present:
            break;
        case YwvHost_Vc_PresentHor: {
            vc.isHState = YES;
        }
            break;
        case YwvHost_Vc_Close:
            break;
        case YwvHost_Vc_UpdateId:
            break;
        case YwvHost_Vc_LoadCmp:
            break;
        case YwvHost_Vc_SetUpdate:
            break;
        case YwvHost_Nag_UpdateStyle:
            break;
        case YwvHost_Error_setError:
            break;
        case YwvHost_Img_SelectImg:
            break;
        case YwvHost_md_openPhone:
            break;
        case YwvHost_md_openSms:
            break;
        case YwvHost_md_openMd:
            break;
        case YwvHost_Vc_ShowLoad:
            break;
        case YwvHost_Vc_SetViewKick:
            break;
        case YwvHost_Vc_SetWebUpdate:
            break;
        case YwvHost_font_getFontName:
            break;
        case YwvHost_Max:
            break;
    }

    vc.vcData = vcData;
    vc.nagData = nagData;
    vc.backVC = self;

    if (vc.isHState) {
        vc.hideNagBar = YES;
        //BdH2Nv *hNv = [BdH2Nv nvWithVc:vc]; // 输入键盘问题 暂时由网页弹出键盘

        YunHNv *hNv = [YunHNv nvWithVc:vc]; // 输入键盘问题 暂时由网页弹出键盘

        UIViewController *curVc = nil;
        if (YunWebViewConfig.instance.delegate &&
            [YunWebViewConfig.instance.delegate respondsToSelector:@selector(getCurrentVc)]) {
            curVc = [YunWebViewConfig.instance.delegate getCurrentVc];
        }

        if (curVc) {
            [curVc presentViewController:hNv
                                animated:YES
                              completion:nil];
        }
    }
    else {
        if (self.isHState) {
            vc.isModalVc = YES;
            YunHomeNv *hNv = [YunHomeNv nvWithVc:vc]; // 输入键盘问题 暂时由网页弹出键盘
            [self presentViewController:hNv
                               animated:YES
                             completion:nil];
        }
        else {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)handleFont:(YunWebViewHostType)type fontData:(YwvFontQueryModel *)data {
    NSString *jsGet = nil;
    if (type == YwvHost_font_getFontName) {
        NSString *fN = nil;
        if (data.fontType == 1) {
            fN = YunAppTheme.instance.fontNName;
        }
        else if (data.fontType == 2) {
            fN = YunAppTheme.instance.fontBName;
        }

        if (fN == nil) {return;}

        jsGet = FORMAT(@"%@font_name(%@,%@)",
                       YunWebViewConfig.instance.jsNamePre,
                       fN,
                       [YunValueHelper intStr:data.fontType]);
    }

    [self jsFuncOn:jsGet];
}

- (void)handleUpdateNag:(YwvNagQueryModel *)nagData {
    if (nagData.nagIsHidden != _nagData.nagIsHidden) {
        _nagData.nagIsHidden = nagData.nagIsHidden;
        self.hideNagBar = _nagData.nagIsHidden;
        [self updateNagHideState];
    }

    if ([YunValueVerifier isValidStr:nagData.nagTitle] &&
        ![nagData.nagTitle isEqualToString:_nagData.nagTitle]) {
        _nagData.nagTitle = nagData.nagTitle;
        [self setNavTitle:_nagData.nagTitle];
    }

    if (nagData.nagLeftItemType != _nagData.nagLeftItemType) {
        _nagData.nagLeftItemType = nagData.nagLeftItemType;
        _nagData.nagLeftItemName = nagData.nagLeftItemName;
        [self updateNagLeftItem];
    }

    if (nagData.nagRightItemType != _nagData.nagRightItemType) {
        _nagData.nagRightItemType = nagData.nagRightItemType;
        _nagData.nagRightItemName = nagData.nagRightItemName;
        [self updateNagRightItem];
    }
}

- (void)handleErr:(YwvErrorQueryModel *)errData {
    if (errData.errorCode == 1) {
        if ([YunValueVerifier isValidStr:errData.errorMsg]) {
            [YunAlertViewHelper.instance showYes:errData.errorMsg result:^(BOOL yes) {
                [YunAccountMgHelper.mg removeAcct];

                if (YunWebViewConfig.instance.delegate &&
                    [YunWebViewConfig.instance.delegate respondsToSelector:@selector(shouldInitRootVc)]) {
                    [YunWebViewConfig.instance.delegate shouldInitRootVc];
                }
            }];
        }
        else {
            [YunAccountMgHelper.mg removeAcct];

            if (YunWebViewConfig.instance.delegate &&
                [YunWebViewConfig.instance.delegate respondsToSelector:@selector(shouldInitRootVc)]) {
                [YunWebViewConfig.instance.delegate shouldInitRootVc];
            }
        }
    }

    if (errData.errorCode == 0) {
        if ([YunValueVerifier isValidStr:errData.errorMsg]) {
            [YunAlertViewHelper.instance showYes:errData.errorMsg result:^(BOOL yes) {
            }];
        }
    }
}

- (void)handleMdType:(YunWebViewHostType)hType mdDat:(YwvMediaQueryModel *)mdDat {
    if (hType == YwvHost_md_openMd && [YunValueVerifier isValidStr:mdDat.mdUrl]) {
        [YunSystemMediaHelper openURL:mdDat.mdUrl];
        return;
    }

    if ([YunValueVerifier isInvalidStr:mdDat.mdPhone]) {
        [YunAlertViewHelper.instance showYes:@"电话号码错误！"];
        return;
    }

    if (hType == YwvHost_md_openPhone) {
        [YunSystemMediaHelper openPhone:mdDat.mdPhone];
        return;

        [YunAlertViewHelper.instance showYesNo:FORMAT(@"确认拨打电话:%@", mdDat.mdPhone) result:^(BOOL yes) {
            if (yes) {
                [YunSystemMediaHelper openPhone:mdDat.mdPhone];
            }
        }];

        return;
    }

    if (hType == YwvHost_md_openSms) {
        [YunSystemMediaHelper openSms:mdDat.mdPhone];

        return;
    }
}

- (void)handleSelImg:(YwvImgQueryModel *)imgData {
    _imgData = imgData;

    _selHelper = [YunSelectImgHelper new];
    _selHelper.delegate = self;
    _selHelper.superVC = self;
    _selHelper.maxCount = imgData.yunImgCount;
    _selHelper.editImg = imgData.imgCanEdit;
    _selHelper.disAmt = NO;
    _selHelper.isCompression = imgData.yunImgCmpr;
    _selHelper.imgLength = imgData.yunImgCmprLength;

    _selHelper.imgBoundary = 1280;

    _selHelper.selType = imgData.yunImgType;
    [_selHelper selectImg:0];
}

// page load

- (void)handlePageLoadCmp {
    _pageLoadCmp = YES;

    if (_rqtTimeOutView) {
        [_rqtTimeOutView removeFromSuperview];
        _rqtTimeOutView.hidden = YES;
    }

    [self hideLoadView];
}

- (void)showRqtTimeOutView {
    if (_pageLoadCmp) {
        [self handlePageLoadCmp];
        return;
    }

    if (_rqtTimeOutView == nil) {
        _rqtTimeOutView = [YunCoverView itemWithMsg:@"加载数据失败，请检查网络后重试！"
                                                img:YunConfig.instance.imgViewNoNetName
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

- (void)setVcData:(YwvVcQueryModel *)vcData {
    _vcData = vcData;
}

- (void)setNagData:(YwvNagQueryModel *)nagData {
    _nagData = nagData;

    self.hideNagBar = _nagData.nagIsHidden;

    [self setNavTitle:_nagData.nagTitle];

    //[self updateNagStyle];
}

- (void)initViewState {
    _webView.scrollView.bounces = !_vcData.disableKick;
    _webView.scrollView.scrollEnabled = !_vcData.disableScroll;

    if (self.isHState) {
        [self initHState];
    }
}

- (void)initHState {
    //if ([self.class isKindOfClass:BdFmlFxL2AmtVc.class]) {
    //    return;
    //}

    [self.view layoutIfNeeded];
}

// todo
- (void)handleViewJs:(YunWebViewHostType)type {
    NSString *jsGet = nil;

    if (type == YwvHost_Vc_SetUpdate) {
        jsGet = FORMAT(@"%@should_update()", YunWebViewConfig.instance.jsNamePre);

        _webShouldUpdateData = NO;
    }

    [self jsFuncOn:jsGet];
}

#pragma mark - private functions

#pragma mark - private functions  --nag

- (void)updateNagStyle {
    self.hideNagBar = _nagData.nagIsHidden;

    [self setNavTitle:_nagData.nagTitle];

    [self updateNagLeftItem];

    [self updateNagRightItem];
}

- (void)updateNagLeftItem {
    if (_nagData.nagLeftItemType == 2) {
        self.hideNagBarBackItem = YES;
        return;
    }
    else {
        self.hideNagBarBackItem = NO;
    }

    if (_nagData.nagLeftItemType == 0) {
        [self setWebVcNagBackItem];
        return;
    }

    if (_nagData.nagLeftItemType == 1) {
        [self setLeftBarItemName:_nagData.nagLeftItemName];
        return;
    }
}

- (void)updateNagRightItem {
    if (_nagData.nagRightItemType == 0) {
        [self setRightBarItem:nil];

        return;
    }
    else {
    }

    if (_nagData.nagRightItemType == 1) {
        [self setRightBarItemName:_nagData.nagRightItemName];
    }
}

- (void)loadRequest {
    // 添加必要的参数 appFont appFontB
    if (![_vcData.viewUrl containsString:@"appFont="]) {
        NSString
                *fontPara =
                FORMAT(@"appFont=%@&appFontB=%@", YunAppTheme.instance.fontNName, YunAppTheme.instance.fontBName);
        if ([_vcData.viewUrl containsString:@"?"]) {
            _vcData.viewUrl = FORMAT(@"%@&%@", _vcData.viewUrl, fontPara);
        }
        else {
            _vcData.viewUrl = FORMAT(@"%@?%@", _vcData.viewUrl, fontPara);
        }
    }

    NSString *encodedUrl = [_vcData.viewUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                    [NSCharacterSet URLQueryAllowedCharacterSet]];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]]];
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

- (void)setWebVcNagBackItem {
    if (YunWebViewConfig.instance.delegate &&
        [YunWebViewConfig.instance.delegate respondsToSelector:@selector(setNagBackItem:)]) {
        [YunWebViewConfig.instance.delegate setNagBackItem:self];
    }
}

#pragma mark - demon

#pragma mark - protocol

#pragma mark - YunSelectImgDelegate

// 需要Config设置
- (void)selectItemByType:(YunSelectImgType)type cmp:(void (^)(YunSelectImgType type))cmp {
    if (YunWebViewConfig.instance.selImgDelegate &&
        [YunWebViewConfig.instance.selImgDelegate respondsToSelector:@selector(selectImgByType:)]) {
        [YunWebViewConfig.instance.selImgDelegate selectItemByType:type cmp:cmp];
    }
    else {
        [YunLogHelper logMsg:@"YunWebViewController：需要实现selectImgByType协议" force:YES];
    }
}

- (void)didCmpWithItems:(NSArray *)items error:(NSError *)error selType:(YunSelectImgType)selType {
    if (error) {
        [YunLogHelper logMsg:error.getErrorMsg force:YES];
        return;
    }

    if (items == nil || items.count == 0) {
        return;
    }

    NSMutableArray *imgList = [NSMutableArray new];

    for (int i = 0; i < items.count; ++i) {
        UIImage *image;
        if ([items isKindOfClass:UIImage.class]) {
            image = items[i];
        }
        else if ([items isKindOfClass:NSData.class]) {
            image = [UIImage imgWithObj:items[i]];
        }

        if (image == nil) {
            continue;
        }

        [imgList addObject:[YwvImgItem itemWithImgSrc:image thumb:_imgData.imgGetThumb]];
    }

    YwvImgList *list = [YwvImgList new];
    list.imgList = imgList;

    NSString *imgListS = list.toJSONString;
    NSString *jsGet = FORMAT(@"%@img_selCmp(%@)", YunWebViewConfig.instance.jsNamePre, imgListS);

    [self jsFuncOn:jsGet];

    // 保存相册
    if (_imgData.imgSaveToAlbum && selType != YunImgSelByPhotoAlbum && items.count == 1) {
        [self savedPhotosToAlbum:items[0]];
    }
}

- (void)jsFuncOn:(NSString *)jsFunc {
    [_webView evaluateJavaScript:jsFunc
               completionHandler:^(id _Nullable htmlStr, NSError *_Nullable error) {
                   if (error) {
                       [YunLogHelper logMsg:FORMAT(@"JSError:%@", error)];
                   }
               }];
}

// 保存到相册
- (void)savedPhotosToAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   (__bridge void *) self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
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

    //[self setMyPhone];
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
    if ([scheme isEqualToString:YunWebViewConfig.instance.schemeName]) {
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

    if ([webView.URL.absoluteString hasPrefix:YunWebViewConfig.instance.schemeName]) {
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
    if (YunWebViewConfig.instance.testButton) {
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
    [YunAlertViewHelper.instance showYes:_webView.URL.absoluteString];
}

@end