//
//  XHTabView.m
//  XHTabView
//
//  Created by shao xionghua on 2019/7/31.
//  Copyright © 2019 shao xionghua. All rights reserved.
//

#import "XHTabView.h"
#import "MJRefresh.h"
#import "MJAnimationHeader.h"
#import "MJAnimationFooter.h"

static NSString * const pageIndex = @"pageNum";//获取第几页的根据自己的需求替换
@interface XHTabView ()
{
    /**纪录当前页数*/
    NSInteger _pageNum;
    /**出现网络失败*/
    BOOL _isNetError;
}
/**添加的footView*/
@property (nonatomic , strong) UIView *footerView;
@end
@implementation XHTabView
+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(reloadData));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(mc_reloadData));
    BOOL didAddMethod =
    class_addMethod(self,
                    @selector(reloadData),
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            @selector(mc_reloadData),
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style] ) {
        [self initTableView];
    }
    return self;
}

- (void)initTableView{

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.estimatedRowHeight  = 0;
    self.estimatedSectionFooterHeight  = 0;
    self.estimatedSectionFooterHeight = 0;
    self.footerView = [UIView new];
    [self setTableFooterView:self.footerView];
    _isNetError = NO;
    self.canResponseMutiGesture = NO;
}

- (void)mc_reloadData
{
    [self mc_reloadData];
    if (self.getTotal == 0 && _isNetError) {
        //这里是网络出错的数据为空
        self.tableFooterView = self.defaultView;
        self.mj_footer.hidden =YES;
    }else if (self.getTotal == 0 ){
        //就是数据为空
        self.tableFooterView =  self.defaultView;
        self.mj_footer.hidden =YES;
    }else{
        [self setTableFooterView:self.footerView];
        self.mj_footer.hidden =NO;
    }
}

- (NSInteger)getTotal
{
    NSInteger sections = 0;
    sections = [self numberOfSections];
    NSInteger items = 0;
    for (NSInteger section = 0; section < sections; section++) {
        items += [self numberOfRowsInSection:section];
    }
    return items;
}

- (void)setUpWithUrl:(NSString *)url Parameters:(NSDictionary *)Parameters formController:(UIViewController *)controler
{
    _requestUrl = url;
    _TempController = controler;
    _requestParam= Parameters.mutableCopy;
    if ([Parameters.allKeys containsObject:pageIndex]) {
        if (self.isRefreshNormal == YES) {
            self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        }
        else{
            self.mj_footer = [MJAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        }
    }
    [self.mj_header beginRefreshing];
}

//**请求方法*/
- (void)SetUpNetWorkParamters:(NSDictionary *)paramters isPullDown:(BOOL)isPullDown
{
    
    //暂时是模仿数据请求h返回数据 替换下面的数据请求 这里就可以删除
    if ([[paramters objectForKey:pageIndex] integerValue] < 5) {
        if ([self.RequestDelegate respondsToSelector:@selector(XHTabView:isPullDown:SuccessData:)]) {
            [self.RequestDelegate XHTabView:self isPullDown:isPullDown SuccessData:@[@"",@"",@""]];
        }
    }
    else{
        if ([self.RequestDelegate respondsToSelector:@selector(XHTabView:isPullDown:SuccessData:)]) {
            [self.RequestDelegate XHTabView:self isPullDown:isPullDown SuccessData:@[]];
            [self NoDataFooter];
        }
    }
    
    self->_isNetError = NO;
    [self EndRefrseh];
    
    //这里替换成自己的网络请求方法就好了
    //自己的网络请求数据
    //这里替换成自己的网络请求方法就好了
}

- (void)setIsHasHeaderRefresh:(BOOL)isHasHeaderRefresh
{
    if (!isHasHeaderRefresh) {
        self.mj_header = nil;
    }else{
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    }
}
- (void)requestData
{
    if (_requestUrl.length ==0) {
        [self.mj_header endRefreshing];
        return;
    }
    if ([_requestParam.allKeys containsObject:pageIndex]) {
        [self changeIndexWithStatus:1];
    }
    [self SetUpNetWorkParamters:_requestParam isPullDown:YES];
}

- (void)footerRefresh
{
    [self changeIndexWithStatus:2];
    [self SetUpNetWorkParamters:_requestParam isPullDown:NO];
}

- (void)changeIndexWithStatus:(NSInteger)Status//1  下拉  2上拉  3减一
{
    _pageNum = [_requestParam[pageIndex] integerValue];
    if (Status == 1) {
        _pageNum = 1;
    }else if (Status == 2){
        _pageNum ++;
    }else{
        _pageNum --;
    }
    [_requestParam setObject:[NSNumber numberWithInteger:_pageNum] forKey:pageIndex];
}

- (void)EndRefrseh
{
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void)NoDataFooter
{
    [self.mj_footer endRefreshing];
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)setRequestParam:(NSDictionary *)requestParam
{
    if (_requestParam) {
        [_requestParam addEntriesFromDictionary:requestParam];
        return;
    }
    _requestParam = requestParam.mutableCopy;
}

- (void)setRequestUrl:(NSString *)requestUrl
{
    _requestUrl = requestUrl;
}
- (void)setIsRefreshNormal:(BOOL)isRefreshNormal
{
    _isRefreshNormal = isRefreshNormal;
    
    if (self.isRefreshNormal == YES) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    }
    else{
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        self.mj_header = [MJAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    }
    
    
}
- (DefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [[DefaultView alloc]init];
        _defaultView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.tableHeaderView.frame.size.height);
        _defaultView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    }
    return _defaultView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.canResponseMutiGesture;
}
@end

/***************************  以下是空白界面的View  **************************************************/

@interface DefaultView ()
@property (nonatomic , strong) UILabel * tostLab;
@property (nonatomic , strong) UIImageView * imageView;
@end

@implementation DefaultView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initEmptyView];
    }
    return self;
}
- (void)initEmptyView
{
    self.imageView = [[UIImageView alloc]init];
    [self.imageView sizeToFit];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
    
    self.tostLab = [[UILabel alloc]init];
    self.tostLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.tostLab.textColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
    [self.tostLab setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.tostLab.textAlignment = NSTextAlignmentCenter;
    self.tostLab.numberOfLines = 0;
    [self addSubview:self.tostLab];
    
    self.imageView.center = self.center;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tostLab attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tostLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tostLab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-20]];
    
}
- (void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:imageSize.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:imageSize.height]];
}
- (void)setImageName:(NSString *)imageName
{
    self.imageView.image = [UIImage imageNamed:imageName];
}
- (void)setTostText:(NSString *)tostText
{
    self.tostLab.text = tostText;
}
- (void)setTostTextFont:(UIFont *)tostTextFont
{
    self.tostLab.font = tostTextFont;
}
- (void)setTostTextColor:(UIColor *)tostTextColor
{
    self.tostLab.textColor = tostTextColor;
}
- (void)setTostAttributedText:(NSAttributedString *)tostAttributedText
{
    self.tostLab.attributedText = tostAttributedText;
}


@end
