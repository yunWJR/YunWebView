//
//  Created by yun on 2018/6/11.
//  Copyright © 2018年 yun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/Mantle.h>

@interface YwvVcQueryModel : MTLModel <MTLJSONSerializing>

// ---view---

// view的id：
// 默认为 null
// 由web设置。当需要对特定 view 操作时，可以加入id
@property (nonatomic, copy) NSString *viewId;

// 页面加载动画设置：
// 0-app显示加载动画--默认。web 加载完成后，调用 loadCmp 方法
// 1-app不显示加载动画
@property (nonatomic, assign) NSInteger viewLoadType;

// 页面加载的url：
// view的Push、Present方法，必须设置该值
@property (nonatomic, copy) NSString *viewUrl;

+ (instancetype)modelWithData:(id)data;

@end