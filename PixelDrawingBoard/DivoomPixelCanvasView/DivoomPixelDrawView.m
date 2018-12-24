//
//  DivoomPixelView.m
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/17.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomPixelDrawView.h"

@implementation DivoomPixelDrawView{
    NSMutableArray      *_courseDrawPixels;     //绘画过程中的预览点数
}

- (instancetype)initWithRow:(NSInteger)row col:(NSInteger)col{
    if (self = [super initWithRow:row col:col]) {
        _courseDrawPixels = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //预览过程绘制
    if (_courseDrawPixels.count > 0) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(ctx, NO);
        [self.curColor setFill];
        for (NSInteger i = 0; i < _courseDrawPixels.count; i++) {
            CGPoint p = [[_courseDrawPixels objectAtIndex:i] CGPointValue];
            CGRect rect = CGRectMake(p.x * self.getPixelWidth, p.y * self.getPixelWidth, self.getPixelWidth, self.getPixelWidth);
            CGContextAddRect(ctx, rect);
            CGContextFillPath(ctx);
        }
    }
}

#pragma mark - Public

// TODO: 提交预览像素点到实际画布
- (void)submitDrawingPixel {
    if (_courseDrawPixels.count > 0) {
        [self.pixelAdapter replacePointColor:self.curColor pointArr:[_courseDrawPixels copy]];
        [_courseDrawPixels removeAllObjects];
        [self setNeedsDisplay];
    }
}

#pragma mark - 工具

// TODO: 清屏
- (void)clearScreen {
    [self.pixelAdapter pushToUndoQueue];
    [self.pixelAdapter initDefaultDataSource];
    [_courseDrawPixels removeAllObjects];
    [self setNeedsDisplay];
}

// TODO: 通过触摸View坐标转化像素坐标
- (CGPoint)locationWithTouchPoint:(CGPoint)point {
    int x = point.x / self.getPixelWidth;
    int y = point.y / self.getPixelWidth;
    return CGPointMake(x,y);
}

// TODO: 添加一个点的绘制
- (void)drawPixelAt:(NSInteger)x y:(NSInteger)y {
    [self.pixelAdapter replacePointColor:self.curColor pointArr:@[@(CGPointMake(x, y))]];
    [self setNeedDisplayInLoc:CGPointMake(x, y)];
}

// TODO: 绘制预览像素点 不做最终结果显示
- (void)previewPixelAt:(NSInteger)x y:(NSInteger)y {
    [_courseDrawPixels addObject:@(CGPointMake(x, y))];
}

// TODO: 绘制一条直线
- (void)drawLineAtBegin:(CGPoint)p1 endPoint:(CGPoint)p2{
    [self drawLineAtBegin:p1 endPoint:p2 isPreview:NO];
}

- (void)drawLineAtBegin:(CGPoint)p1 endPoint:(CGPoint)p2 isPreview:(NSInteger)isPreview{
    if (isPreview) {
        [_courseDrawPixels removeAllObjects];
    }
    int x0 = p1.x;
    int y0 = p1.y;
    int x1 = p2.x;
    int y1 = p2.y;
    BOOL steep;
    short t, deltaX, deltaY, error;
    CGFloat x,y,ystep;
    
    steep = (ABS(y1 - y0)  >  ABS(x1 - x0));
    if (steep) {
        t = x0;
        x0 = y0;
        y0 = t;
        
        t = x1;
        x1 = y1;
        y1 = t;
    }
    
    if (x0 > x1) {
        t = x0;
        x0 = x1;
        x1 = t;
        
        t = y0;
        y0 = y1;
        y1 = t;
    }
    
    deltaX = x1 - x0;
    deltaY = ABS(y1 - y0);
    error = 0;
    y = y0;
    
    if (y0 < y1) {
        ystep = 1;
    }else{
        ystep = -1;
    }
    for (x=x0; x <= x1; x++) {
        if (steep) {
            if (isPreview) {
                [self previewPixelAt:y y:x];
            }else{
                [self drawPixelAt:y y:x];
            }
        }else{
            if (isPreview) {
                [self previewPixelAt:x y:y];
            }else{
                [self drawPixelAt:x y:y];
            }
        }
        error += deltaY;
        if ((error << 1) >= deltaX ){
            y += ystep;
            error -= deltaX;
        }
    }
    if (isPreview) {
        [self setNeedsDisplay];
    }
}

- (void)_drawRectLineAtBegin:(CGPoint)p1 endPoint:(CGPoint)p2{
    int x0 = p1.x;
    int y0 = p1.y;
    int x1 = p2.x;
    int y1 = p2.y;
    BOOL steep;
    short t, deltaX, deltaY, error;
    CGFloat x,y,ystep;
    
    steep = (ABS(y1 - y0)  >  ABS(x1 - x0));
    if (steep) {
        t = x0;
        x0 = y0;
        y0 = t;
        
        t = x1;
        x1 = y1;
        y1 = t;
    }
    
    if (x0 > x1) {
        t = x0;
        x0 = x1;
        x1 = t;
        
        t = y0;
        y0 = y1;
        y1 = t;
    }
    
    deltaX = x1 - x0;
    deltaY = ABS(y1 - y0);
    error = 0;
    y = y0;
    
    if (y0 < y1) {
        ystep = 1;
    }else{
        ystep = -1;
    }
    for (x=x0; x <= x1; x++) {
        if (steep) {
            [self previewPixelAt:y y:x];
        }else{
            [self previewPixelAt:x y:y];
        }
        error += deltaY;
        if ((error << 1) >= deltaX ){
            y += ystep;
            error -= deltaX;
        }
    }
}



// TODO: 绘制一个圆形
- (void)drawCirAtCenterPoint:(CGPoint)centerPoint r:(NSInteger)r isFill:(BOOL)isFill{
    //过滤可见范围
    if (centerPoint.x + r < 0 || centerPoint.y + r < 0 ||
        centerPoint.x - r > self.row || centerPoint.y - r > self.col) {
        return;
    }
    [_courseDrawPixels removeAllObjects];
    NSInteger x = 0,y = r,yi = 0,d = 0;
    d = 3 - 2 * r;
    if (isFill) {
        //实心圆
        while (x <= y) {
            for (yi = x; yi <= y; yi++) {
                [self _drawCirPixelAt:centerPoint.x yc:centerPoint.y x:x y:yi];
            }
            if (d < 0) {
                d = d + 4 * x + 6;
            }else{
                d = d + 4 * (x - y) + 10;
                y--;
            }
            x++;
        }
    }else{
        //空心圆
        while (x <= y) {
            [self _drawCirPixelAt:centerPoint.x yc:centerPoint.y x:x y:y];
            if (d < 0) {
                d = d + 4 * x + 6;
            }else{
                d = d + 4 * (x - y) + 10;
                y--;
            }
            x++;
        }
    }
    [self setNeedsDisplay];
}

- (void)_drawCirPixelAt:(NSInteger)xc yc:(NSInteger)yc x:(NSInteger)x y:(NSInteger)y {
    [self previewPixelAt:xc + x y:yc + y];
    [self previewPixelAt:xc - x y:yc + y];
    [self previewPixelAt:xc + x y:yc - y];
    [self previewPixelAt:xc - x y:yc - y];
    [self previewPixelAt:xc + y y:yc + x];
    [self previewPixelAt:xc - y y:yc + x];
    [self previewPixelAt:xc + y y:yc - x];
    [self previewPixelAt:xc - y y:yc - x];
}

// TODO: 绘制一个矩形
- (void)drawRectPixelAt:(CGPoint)p1 endPoint:(CGPoint)p2 isFill:(BOOL)isFill {
    [_courseDrawPixels removeAllObjects];
    [self _drawRectLineAtBegin:CGPointMake(p1.x, p1.y) endPoint:CGPointMake(p2.x, p1.y)];
    [self _drawRectLineAtBegin:CGPointMake(p1.x, p2.y) endPoint:CGPointMake(p2.x, p2.y)];
    [self _drawRectLineAtBegin:CGPointMake(p1.x, p1.y) endPoint:CGPointMake(p1.x, p2.y)];
    [self _drawRectLineAtBegin:CGPointMake(p2.x, p1.y) endPoint:CGPointMake(p2.x, p2.y)];
    [self setNeedsDisplay];
}

#pragma mark -

/**
 当前操作到撤销队列
 */
- (void)pushToUndoQueue{
    [self.pixelAdapter pushToUndoQueue];
}

/**
 撤销
 */
- (void)undo{
    [self.pixelAdapter undo];
    [self setNeedsDisplay];
}

/**
 恢复
 */
- (void)resume{
    [self.pixelAdapter resume];
    [self setNeedsDisplay];
}

#pragma mark - Private

-(UIColor *)curColor{
    if (!_curColor) {
        _curColor = [UIColor whiteColor];
    }
    return _curColor;
}

- (void)setNeedDisplayInLoc:(CGPoint)point {
    [self setNeedsDisplayInRect:CGRectMake(point.x * self.getPixelWidth, point.y * self.getPixelWidth, self.getPixelWidth, self.getPixelWidth)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
