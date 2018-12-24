//
//  DivoomPixelCanvas.m
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/15.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomPixelCanvas.h"


@interface DivoomPixelCanvas()

@end

@implementation DivoomPixelCanvas{
    CGFloat             _pixelSize;
    CAShapeLayer        *_gridLayer;    //网格层
    BOOL                _isLayerMode;   //是否是图层模式
}

- (instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col
{
    self = [self initWithRow:row col:col];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (instancetype)initWithRow:(NSInteger)row col:(NSInteger)col
{
    self = [super init];
    if (self) {
        _row = row;
        _col = col;
        _showGridLine = YES;
        _isLayerMode = NO;
        _gridLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_gridLayer];
        [self calcPixelSize];
        [self resetGridLine];
    }
    return self;
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self resetGridLine];
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"开始绘图");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(ctx, NO);
    for (NSInteger x = 0; x < _row; x++) {
        for (NSInteger y = 0; y < _col; y++) {
            UIColor *color = [self.pixelAdapter getColorWithPoint:CGPointMake(x, y)];
            if (x == 3 && y == 3) {
                color = [UIColor yellowColor];
            }
            if (color) {
                [color setFill];
                CGRect pixelRect = CGRectMake(x * _pixelSize, y * _pixelSize, _pixelSize, _pixelSize);
                CGContextAddRect(ctx, pixelRect);
                CGContextFillPath(ctx);
            }
        }
    }
}

// TODO: 重制网格线
- (void)resetGridLine {
    _gridLayer.frame = self.bounds;
    _gridLayer.lineWidth = .3;
    _gridLayer.strokeColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_showGridLine) {
        //row
        for (int i = 0; i < _row; i++) {
            [path moveToPoint:CGPointMake(0, i * _pixelSize)];
            [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), i * _pixelSize)];
        }
        //col
        for (int i = 0; i < _col; i++) {
            if (i > 0) {
                [path moveToPoint:CGPointMake(i * _pixelSize, 0)];
                [path addLineToPoint:CGPointMake(i * _pixelSize,CGRectGetHeight(self.frame))];
            }
        }
    }
    _gridLayer.path = path.CGPath;
}

#pragma mark - Getter / Setter

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self calcPixelSize];
    [self resetGridLine];
    [self setNeedsDisplay];
}

// TODO: 获取像素点宽度
-(CGFloat)getPixelWidth{
    return _pixelSize;
}


// TODO: 设置网格线
-(void)setShowGridLine:(BOOL)showGridLine{
    _showGridLine = showGridLine;
    [self resetGridLine];
}

// TODO: 像素适配器
- (DivoomPixelAdapter *)pixelAdapter{
    if (!_pixelAdapter) {
        _pixelAdapter = [[DivoomPixelAdapter alloc] initWithSize:CGSizeMake(_row, _col)];
    }
    return _pixelAdapter;
}

#pragma mark - Private

- (void)calcPixelSize {
    NSInteger maxPixelCount = _row;
    if (_row < _col) {
        maxPixelCount = _col;
    }
    _pixelSize = CGRectGetWidth(self.frame) / maxPixelCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
