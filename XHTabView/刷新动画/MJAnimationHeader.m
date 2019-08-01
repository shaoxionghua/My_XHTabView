//
//  MJAnimationHeader.m
//  HOLA
//
//  Created by shao xionghua on 2019/5/22.
//  Copyright © 2019 danggui. All rights reserved.
//

#import "MJAnimationHeader.h"

@implementation MJAnimationHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    self.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<80; i++) {

        if (i>=70 && i<75) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"眨眼_%zd", i-70]];
            if (image !=nil) {
                [idleImages addObject:image];
            }
        }
        else{
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", 0]];
            [idleImages addObject:image];
        }
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ld", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}
@end
