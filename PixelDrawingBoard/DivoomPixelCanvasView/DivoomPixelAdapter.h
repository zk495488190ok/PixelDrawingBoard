//
//  DivoomPixelAdapter.h
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/15.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DivoomPixelAdapter : NSObject

@property (nonatomic, assign) CGSize                size;               //画布大小
@property (nonatomic, strong) UIColor               *defaultColor;      //默认填充色
@property (nonatomic, assign) NSInteger             maxUndoCount;       //撤销的最大次数
@property (nonatomic, strong) NSMutableDictionary   *dict;              //点数据存放

- (instancetype)initWithSize:(CGSize)size;

/**
 初始化默认数据
 */
- (void)initDefaultDataSource;

/**
 获取点颜色

 @param point 点
 @return 颜色
 */
- (UIColor *)getColorWithPoint:(CGPoint)point;

/**
 填充颜色

 @param color 颜色
 */
- (void)fillColor:(UIColor *)color;
- (void)fillColor:(UIColor *)color pointArr:(NSArray *)pointArr;


/**
 替换颜色

 @param color 颜色
 @param pointArr 点数组
 */
- (void)replacePointColor:(UIColor *)color pointArr:(NSArray *)pointArr;

/**
 清除颜色点

 @param pointArr 点数组
 */
- (void)removePointArr:(NSArray *)pointArr;


#pragma mark -

/**
 当前操作到撤销队列
 */
- (void)pushToUndoQueue;

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
