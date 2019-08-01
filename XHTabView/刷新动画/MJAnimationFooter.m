//
//  MJAnimationFooter.m
//  XHTabView
//
//  Created by shao xionghua on 2019/7/31.
//  Copyright © 2019 shao xionghua. All rights reserved.
//

#import "MJAnimationFooter.h"

@implementation MJAnimationFooter
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    // 隐藏状态
    self.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    self.refreshingTitleHidden = YES;
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ld", i]];
        [refreshingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
