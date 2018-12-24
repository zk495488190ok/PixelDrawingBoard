//
//  PixelDrawingBoard.m
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/11/23.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "PixelDrawingBoard.h"

@implementation PixelDrawingBoard{
    NSMutableArray                  *_pointDatas;
    NSMutableArray<CALayer *>       *_pixelItems;
    NSMutableArray<NSArray *>       *_historyDatas;
    UIView                          *_contentView;
}

#pragma mark - 初始化部分

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initConfig];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col
{
    self = [super initWithFrame:frame];
    if (self) {
        _row = row;
        _col = col;
        [self setupView];
    }
    return self;
}

- (void)initConfig {
    _row = 32;
    _col = 32;
    _curFillColor = [UIColor blackColor];
}

- (void)setupView {
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    
    _pointDatas = [[NSMutableArray alloc] init];
    _pixelItems = [[NSMutableArray alloc] init];
    _historyDatas = [[NSMutableArray alloc] init];
    _contentView.layer.borderColor = [UIColor blackColor].CGColor;
    _contentView.layer.borderWidth = .5f;
    
    _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat itemSpacing = .5f;
    CGFloat itemWH = ((width - ((_row - 2) * .5f)) / _row);
    for (int i = 0; i < _row; i++) {
        for (int j = 0; j < _col; j++) {
            CALayer *pixelItem = [CALayer layer];
            pixelItem.frame = CGRectMake(j * itemWH + j * itemSpacing, i * itemSpacing + i * itemWH, itemWH, itemWH);
            pixelItem.backgroundColor = [UIColor whiteColor].CGColor;
            [_contentView.layer addSublayer:pixelItem];
            [_pixelItems addObject:pixelItem];
        }
    }
}

#pragma mark - 手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    CALayer *curPixelLayer = [self getPixelItemLayerWithPoint:[touch locationInView:self]];
    if (curPixelLayer) {
        curPixelLayer.backgroundColor = self.curFillColor.CGColor;
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    CALayer *curPixelLayer = [self getPixelItemLayerWithPoint:[touch locationInView:self]];
    if (curPixelLayer) {
        curPixelLayer.backgroundColor = self.curFillColor.CGColor;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


#pragma mark - Actions

#pragma mark - Public

-(void)setScale:(CGFloat)scale{
    if (scale <= 0) {
        return;
    }
    _scale = scale;
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:.3 animations:^{
        __strong typeof(_weakSelf) _strongSelf = _weakSelf;
        _strongSelf->_contentView.layer.affineTransform = CGAffineTransformMakeScale(_strongSelf.scale, _strongSelf.scale);
    }];
}

#pragma mark - Private

- (CALayer *)getPixelItemLayerWithPoint:(CGPoint)point {
    for (CALayer *item in _pixelItems) {
        if (CGRectContainsPoint(item.frame, point)) {
            return item;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
