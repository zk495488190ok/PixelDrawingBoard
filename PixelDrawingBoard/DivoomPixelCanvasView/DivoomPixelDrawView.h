//
//  DivoomPixelView.h
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/17.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomPixelCanvas.h"

NS_ASSUME_NONNULL_BEGIN

@interface DivoomPixelDrawView : DivoomPixelCanvas

@property (nonatomic, assign) BOOL          isMirroringMode;    //是否镜像模式
@property (nonatomic, strong) UIColor       *curColor;          //当前画笔颜色

/**
 通过触摸View坐标转化像素坐标

 @param point 触摸坐标
 @return 像素坐标
 */
- (CGPoint)locationWithTouchPoint:(CGPoint)point;

#pragma mark - 绘制

/**
 清屏
 */
- (void)clearScreen;

/**
 添加一个点的绘制

 @param x x
 @param y y
 */
- (void)drawPixelAt:(NSInteger)x y:(NSInteger)y;

/**
 绘制一条直线

 @param p1 起点
 @param p2 终点
 */
- (void)drawLineAtBegin:(CGPoint)p1 endPoint:(CGPoint)p2;
- (void)drawLineAtBegin:(CGPoint)p1 endPoint:(CGPoint)p2 isPreview:(NSInteger)isPreview;    //@param isPreview 是否是预览的方式

/**
 绘制一个圆形

 @param centerPoint 中心点
 @param r 半径
 @param isFill 是否填充
 */
- (void)drawCirAtCenterPoint:(CGPoint)centerPoint r:(NSInteger)r isFill:(BOOL)isFill;

/**
 绘制一个矩形

 @param p1 起点
 @param p2 终点
 @param isFill 是否填充
 */
- (void)drawRectPixelAt:(CGPoint)p1 endPoint:(CGPoint)p2 isFill:(BOOL)isFill;

/**
 提交预览像素点到实际画布
 */
- (void)submitDrawingPixel;


#pragma mark -

/**
 当前操作到撤销队列
 */
- (void)pushToUndoQueue;


/**
 当前操作到恢复队列
 */
- (void)pushToResumeQueue;

/**
 撤销
 */
- (void)undo;

/**
 恢复
 */
- (void)resume;

@end

NS_ASSUME_NONNULL_END
