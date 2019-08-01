//
//  XHTabView.h
//  XHTabView
//
//  Created by shao xionghua on 2019/7/31.
//  Copyright © 2019 shao xionghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHTabView,DefaultView;
@protocol XHTabViewRequestDelegate <NSObject>
@optional
/**
 返回请求到的数据
 @param XHTabView 返回自己
 @param PullDown   返回bool 表明  YES－－下拉刷新  NO －－－ 上拉记载
 @param SuccessData  返回的数据
 */
- (void)XHTabView:(XHTabView *)XHTabView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData;

/**
 返回网络错误的状态
 @param XHTabView self
 @param error 错误error
 */
@optional
- (void)XHTabView:(XHTabView *)XHTabView requestFailed:(NSError *)error;

@end

@interface XHTabView : UITableView<UIGestureRecognizerDelegate>

/**
 是否使用默认的刷新控件
 */
@property (nonatomic , assign) BOOL  isRefreshNormal;


@property (assign,nonatomic) id<XHTabViewRequestDelegate> RequestDelegate;
//配合MCHoveringView使用的属性/
//**获取tableView偏移量的Block*/
@property (nonatomic , copy) void(^scrollViewDidScroll)(UIScrollView * scrollView);

//配合MCHoveringView使用的属性/
/**是否同时响应多个手势 默认NO*/
@property (nonatomic , assign) BOOL  canResponseMutiGesture;

/*传递controller进来展示loadding状态只能是weak不会引用*/
@property (weak, nonatomic)UIViewController *TempController;

/**
 空白页、网络错误页  页面的内容可用此属性去更改
 */
@property (nonatomic , strong)  DefaultView * defaultView;

/**
 是否有头部刷新  默认YES
 */
@property (nonatomic,assign) BOOL isHasHeaderRefresh;

/**
 获取总的数据
 */
@property (nonatomic , assign) NSInteger getTotal;

/**
 请求的网址
 */
@property (nonatomic , copy) NSString * requestUrl;

/**
 请求的参数
 */
@property (nonatomic , strong) NSMutableDictionary * requestParam;


/**
 刷新 无下拉动作
 */
- (void)requestData;

/**
 开始下载任务  网络数据用此开始  本地数据则不用使用本方法
 @param url        请求的网址
 @param Parameters 携带的参数 （一定要把分页参数放在这里）
 */

- (void)setUpWithUrl:(NSString *)url Parameters:(NSDictionary *)Parameters formController:(UIViewController *)controler;

@end

/***************************  以下是空白界面的View  **************************************************/
@interface DefaultView : UIView

/**
 图片名称
 */
@property (nonatomic , copy) NSString * imageName;
/**
 默认图片大小显示居中
 */
@property (nonatomic , assign) CGSize  imageSize;

/**
 提示文字
 */
@property (nonatomic , copy) NSString * tostText;

/**
 提示文字字体
 */
@property (nonatomic , strong) UIFont * tostTextFont;

/**
 提示文字颜色
 */
@property (nonatomic , strong) UIColor * tostTextColor;

/**
 提示文字富文本
 */
@property (nonatomic , strong) NSAttributedString * tostAttributedText;


@end

