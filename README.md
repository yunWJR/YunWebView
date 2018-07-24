# YunWebView

使用Objective-C 实现的自定义 WebView，封装了 App 接口提供给 Web 前端使用，适用于 App 内嵌功能网页。


# YunWebView 接口定义说明

## 一、交互模式

> web与 app通过scheme 与 js 方法交互：

* web->app：通过 scheme 发起命令

* app->web：通过调用 web 的js函数响应数据

##  二、接口定义

### 1、view 模块

#### APP接口参数

> **viewId (string)**

```
// view的id：
// 默认为 null
// 由web设置。当需要对特定 view 操作时，可以加入id
```

> **viewLoadType (int)**

```
// 页面加载动画设置：
// 0-app显示加载动画--默认。web 加载完成后，调用 loadCmp 方法
// 1-app不显示加载动画
```

> **viewUrl (string)**

```
// 页面加载的url：
// view的Push、Present方法，必须设置该值
```

> **disableKick (bool)**

```
// 禁用页面回弹：
// 默认 NO
```

#### APP接口方法

> **view_push()**

```
// 功能：push 进入新页面
// 参数：viewUrl必须指定、其他两个参数可以不指定(使用默认)。
//          注意：有viewUrl参数时，viewUrl必须放在最后。
// 示例：skkj://view_push?viewId=asdasd&viewLoadType=1&viewUrl=https://www.baidu.com
```

> **view_pop()**

```
// 功能：pop 返回上一页面
// 参数：无
// 示例：skkj://view_pop
```

> **view_present()**

```
// 功能：打开模态页面
// 参数：viewUrl必须指定、其他两个参数可以不指定(使用默认)。
//          注意：有viewUrl参数时，viewUrl必须放在最后。
// 示例：skkj://view_present?viewId=asdasd&viewLoadType=1&viewUrl=https://www.baidu.com
```

> **view_presentHor()**

```
// 功能：打开横屏的模态页面
// 参数：viewUrl必须指定、其他两个参数可以不指定(使用默认)。
//          注意：有viewUrl参数时，viewUrl必须放在最后。
// 示例：skkj://view_presentHor?viewId=asdasd&viewLoadType=1&viewUrl=https://www.baidu.com
```

> **view_close()**

```
// 功能：关闭模态页面
// 参数：无
// 示例：skkj://view_close
```

> **view_updateId()**

```
// 功能：设置 viewId
// 参数：viewId
// 示例：skkj://view_updateId?viewId=asdasd
```

> **view_showLoad()**

```
// 功能：显示加载页面
// 参数：无
// 示例：skkj://view_showLoad
```

> **view_loadCmp()**

```
// 功能：页面加载完成
// 参数：无
// 示例：skkj://view_loadCmp
```

> **view_setUpdate()**

```
// 功能：设置页面需要更新，如果viewId为 null或不设置viewId，则更新当前页面。如果viewId为指定值，则更新指定viewId页面
//           当页面显示时，调用 js方法skkj_should_update()，通知 web 更新。
// 参数：viewId
// 示例：skkj://view_setUpdate?viewId=asdasd
```

> **view_setViewKick()**

```
// 功能：设置页面回弹效果。
// 参数：disableKick
// 示例：skkj://view_setViewKick?disableKick=1
```


#### js接口方法

> **skkj\_should\_update()**

```
// 功能：当设定了view_setUpdate，当显示改页面时，调用该方法，web 页面处理更新
// 参数：无
// 示例：skkj_should_update()
```

### 2、导航栏模块

#### APP接口参数

> **nagIsHidden (bool)**

```
// 是否隐藏导航栏：
// 0-不隐藏--默认
// 1-隐藏
```

> **nagTitle (string)**

```
// 导航栏标题：
// 必须设置，不设置值则为null
```

> **nagLeftItemType (int)**

```
// 导航栏左侧按钮类型：
// 0-返回--默认
// 1-文字： 需要设置nagLeftItemName的值
// 2-隐藏：
// 3、4、5...自定义类型。
```

> **nagLeftItemName (string)**

```
// 导航栏左侧按钮名称：
// nagLeftItemType为1时，该值有效
// 如只设置该值，未设置nagLeftItemType，则默认为nagLeftItemType=1
```

> **nagLeftItemHandleType (int)**

```
// 导航栏左侧按钮响应类型：
// 0-自动导航：默认（检测是否可以返回上一页，可以则返回上一页，不可以则退出页面）
// 1-直接退出：直接退出页面
// 2-js响应：点击左侧按钮时，调用 js，由页面处理响应方法
```

> **nagRightItemType (int)**

```
// 导航栏右侧按钮类型：
// 0-隐藏--默认
// 1-文字： 需要设置nagRightItemName的值
// 2、3、4、5...自定义类型。
```

> **nagRightItemName (string)**

```
// 导航栏右侧按钮名称：
// nagRightItemType为1时，该值有效
// 如只设置该值，未设置nagRightItemType，则默认为nagRightItemType =1
```

> *注意：以上参数都可以添加在打开页面的函数中，包括：view_push()、view_present()、view_presentHor()。*

#### APP接口方法

> **nag_updateStyle()**

```
// 功能：更新导航栏状态
// 参数：以上参数够可以指定，不指定则使用默认值。
// 示例：skkj://nag_updateStyle?nagTitle=标题
```

#### js接口方法

> **skkj\_nag\_leftItemOn()**

```
// 功能：点击导航栏左侧按钮，当nagLeftItemHandleType=2时，才会触发
// 参数：无
// 示例：skkj_nag_leftItemOn()
```

> **skkj\_nag\_rightItemOn()**

```
// 功能：点击导航栏右侧按钮，当nagRightItemType不为0时，才会触发
// 参数：无
// 示例：skkj_nag_rightItemOn()
```

### 3、错误模块

#### APP接口参数

> **errorCode (int)**

```
// 错误类型：
// 0-显示错误信息-默认：需要设置：errorMsg
// 1-重新登录：适用于token失效等，需要重新登录的情况
```

> **errorMsg (string)**

```
// app显示的错误信息：
// errorMsg-错误内容。
```

#### APP接口方法

> **error_setError()**

```
// 功能：设置错误
// 参数：errorCode和errorMsg
// 示例：skkj://error_setError?errorCode=1&errorMsg=登录已失效，请重新登录
```

#### js接口方法

> 无

### 4、媒体模块

#### APP接口参数

> **mdPhone (string)**

```
// 电话号码：
// 使用电话/短信的时候需要指定
```

> **mdUrl (string)**

```
// 媒体 URL：
// 适用于特定的情况（如 iOS 跳转到 appstore），根据具体情况设定。
```

#### APP接口方法

> **md_openPhone()**

```
// 功能：拨打电话
// 参数：mdPhone
// 示例：skkj://md_openPhone?mdPhone=13000000000
```

> **md_openSms()**

```
// 功能：发送短信
// 参数：mdPhone
// 示例：skkj://md_openSms?mdPhone=13000000000
```

> **md_openMd()**

```
// 功能：打开媒体
// 参数：mdUrl
// 示例：skkj://md_openMd? mdUrl=item://asdasd
```

#### js接口方法

> 无

### 5、图片模块

#### APP接口参数

> **imgSelType (int)**

```
// 选择图片的类型：
// 0-可以从相册/相机选择 --默认
// 1-只能从相册选择
// 2-只能从相机选择
```

> **imgSelCount (int)**

```
// 可选择图片的数量：
// 0-默认值，表示选择一张，相当于1。
// 1-xx,可选择具体数量。
```

> **imgCanEdit (bool)**

```
// 是否编辑图片：只适用于imgSelCount=1的情况
// 0-不编辑--默认
// 1-可编辑
```

> **imgCompSize (int)**

```
// 照片压缩大小:kb
// 0-300kb--默认
// -1-不压缩，使用原图
// 其他(1->xx)-自定义值，单位 kb
```

> **imgSaveToAlbum (bool)**

```
// 是否保存图片：
// 只适用于拍照的情况
// 0-不保存--默认
// 1-保存
```

> **imgGetThumb (bool)**

```
// 是否生成缩略图
// 0-不生成--默认
// 1-生成缩略图
```

#### APP接口方法

> **img_selectImg()**

```
// 功能：选择图片
// 参数：以上参数够可以指定，不指定则使用默认值。
// 示例：skkj://img_selectImg?imgSelType=1&imgSelCount=3
```

#### js接口方法

> **skkj\_img\_selCmp(imgList)**

```
// 功能：选择图片完成
// 参数：imgList：图片列表,每个item包括img和thumb两个成员
			     img:图片(为 Base64格式)
        	     thumb：缩略图(图片为 Base64格式)
        	     
        	     {imgList:[{img="",thumb=""},{img="",thumb=""}]}
// 示例：skkj_img_selCmp(imgList)
```

### 6、录音模块

#### APP接口参数

> **recordTime (int)**

```
// 开始录音：
// 0-无时长限制 --默认
// 1、2、3...时长限制，单位 s
```

#### APP接口方法

> **record_start()**

```
// 功能：开始录音
// 参数：以上参数够可以指定，不指定则使用默认值。
// 示例：skkj://record_start?record_time=30
```

> **record_cmp()**

```
// 功能：完成录音
//            APP 处理完成后，调用 js 方法通知 web
// 参数：无。
// 示例：skkj://record_cmp
```

> **record_stop()**

```
// 功能：停止录音
// 参数：无。
// 示例：skkj://record_stop
```

#### js接口方法

> **skkj\_record\_cmp(url)**

```
// 功能：录音完成
// 参数：url：录音 url
// 示例：skkj_record_cmp(url)
```


### 7、字体模块

#### APP接口参数

> **fontType (int)**

```
// 字体类型：
// 1 -- 细体
// 2 -- 粗体
```

#### APP接口方法

> **font_getAppFontName()**

```
// 功能：获取 APP 字体名称
// 参数：fontType，指定字体类型
// 示例：skkj://font_getAppFontName
```

#### js接口方法

> **skkj\_font\_name(name, type)**

```
// 功能：提供字体名称
// 参数：name： 字体名称
//      type： 字体类型
// 示例：skkj_font_name(name,type)
```














































