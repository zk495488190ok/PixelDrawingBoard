//
//  DivoomPixelAdapter.m
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/15.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomPixelAdapter.h"

@implementation DivoomPixelAdapter{
    NSMutableArray  *_undoQueue;        //撤销队列
    NSMutableArray  *_resumeQueue;      //恢复队列
}

- (instancetype)initWithSize:(CGSize)size{
    if (self = [super init]) {
        self.maxUndoCount = 30;
        self.size = size;
        self.dict = [[NSMutableDictionary alloc] init];
        _undoQueue = [[NSMutableArray alloc] init];
        _resumeQueue = [[NSMutableArray alloc] init];
        self.defaultColor = [UIColor blackColor];
        [self initDefaultDataSource];
    }
    return self;
}

- (void)initDefaultDataSource {
    [self fillColor:_defaultColor];
}

#pragma mark -

// TODO: 当前操作到撤销队列
- (void)pushToUndoQueue {
    if (_undoQueue.count > self.maxUndoCount) {
        [_undoQueue removeObjectAtIndex:0];
    }
    [_undoQueue addObject:[self.dict mutableCopy]];
}

// TODO: 当前操作到恢复队列
- (void)pushToResumeQueue {
    if (_resumeQueue.count > self.maxUndoCount) {
        [_resumeQueue removeObjectAtIndex:0];
    }
    [_resumeQueue addObject:[self.dict mutableCopy]];
}

// TODO: 撤销
- (void)undo {
    if (_undoQueue.count > 0) {
        [self pushToResumeQueue];
        self.dict = _undoQueue.lastObject;
        [_undoQueue removeLastObject];
    }
}

// TODO: 恢复
- (void)resume {
    if (_resumeQueue.count > 0) {
        [self pushToUndoQueue];
        self.dict = _resumeQueue.lastObject;
        [_resumeQueue removeLastObject];
    }
}

#pragma mark - Public

- (UIColor *)getColorWithPoint:(CGPoint)point {
    if (self.dict.count == 0) {
        return self.defaultColor;
    }
    id pointVal = [self.dict objectForKey:[NSValue valueWithCGPoint:point]];
    if (pointVal != nil) {
        return (UIColor *)pointVal;
    }
    return self.defaultColor;
}

- (void)replacePointColor:(UIColor *)color pointArr:(NSArray *)pointArr{
    if (color == nil || pointArr.count == 0) {
        assert(0);
        return;
    }
    if (pointArr.count > 0) {
        for (NSInteger i = 0; i < pointArr.count; i++) {
            CGPoint itemPoint = [[pointArr objectAtIndex:i] CGPointValue];
            [self.dict setObject:color forKey:[NSValue valueWithCGPoint:itemPoint]];
        }
    }
}

-(void)fillColor:(UIColor *)color{
    for (NSInteger x = 0; x < _size.width; x++) {
        for (NSInteger y = 0; y < _size.height; y++) {
            [self.dict setObject:[color copy] forKey:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
    }
}


- (void)fillColor:(UIColor *)color pointArr:(NSArray *)pointArr{
    if (pointArr.count > 0) {
        for (NSInteger i = 0; i < pointArr.count; i++) {
            CGPoint p = [[pointArr objectAtIndex:i] CGPointValue];
            [self.dict setObject:[color copy] forKey:[NSValue valueWithCGPoint:p]];
        }
    }
}

- (void)removePointArr:(NSArray *)pointArr{
    if (pointArr.count > 0) {
        for (NSInteger i = 0; i < pointArr.count; i++) {
            CGPoint p = [[pointArr objectAtIndex:i] CGPointValue];
            [self.dict setObject:_defaultColor forKey:[NSValue valueWithCGPoint:p]];
        }
    }
}

@end
