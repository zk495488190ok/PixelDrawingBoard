//
//  DivoomCustomPixelRrawView.m
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/18.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomCustomPixelRrawView.h"

@implementation DivoomCustomPixelRrawView{
    BOOL            _isPress;           //是否按下
    CGPoint         _beginPixelLoc;     //绘画时像素首坐标
}


#pragma mark - 绘画手势

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint touchPoint = [touch locationInView:self];
    _beginPixelLoc = [self locationWithTouchPoint:touchPoint];
    [self touchDown];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count > 1) {
        return;
    }
    if (_isPress) {
        UITouch *touch = [[touches allObjects] firstObject];
        CGPoint touchPoint = [touch locationInView:self];
        CGPoint curMovePoint = [self locationWithTouchPoint:touchPoint];
        switch (self.curToolType) {
                // TODO: 铅笔
            case DivoomPixelToolTypePen:{
                [super drawLineAtBegin:_beginPixelLoc endPoint:curMovePoint];
                _beginPixelLoc = curMovePoint;
            }
                break;
                // TODO: 直线
            case DivoomPixelToolTypeLine:{
                [super drawLineAtBegin:_beginPixelLoc endPoint:curMovePoint isPreview:YES];
            }
                break;
                // TODO: 空心圆 & 实心圆
            case DivoomPixelToolTypeCir:
            case DivoomPixelToolTypeSolidCir:{
                NSInteger r = sqrt(pow(_beginPixelLoc.x - curMovePoint.x, 2) + pow(_beginPixelLoc.y - curMovePoint.y, 2));
                BOOL isFill = self.curToolType == DivoomPixelToolTypeSolidCir;
                [super drawCirAtCenterPoint:_beginPixelLoc r:r isFill:isFill];
            }
                break;
                // TODO: 空心矩形 & 实心矩形
            case DivoomPixelToolTypeRect:
            case DivoomPixelToolTypeSolidRect:{
                BOOL isFill = self.curToolType == DivoomPixelToolTypeSolidRect;
                [super drawRectPixelAt:_beginPixelLoc endPoint:curMovePoint isFill:isFill];
            }
                break;
            default:
                break;
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchUp];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchUp];
}

// TODO: 按下
- (void)touchDown {
    [super pushToUndoQueue];
    _isPress = YES;
    switch (self.curToolType) {
        case DivoomPixelToolTypePen:{
            [super drawPixelAt:_beginPixelLoc.x y:_beginPixelLoc.y];
        }
            break;
            
        default:
            break;
    }
}

// TODO: 抬起
- (void)touchUp {
    _isPress = NO;
    switch (self.curToolType) {
        case DivoomPixelToolTypeLine:
        case DivoomPixelToolTypeCir:
        case DivoomPixelToolTypeSolidCir:
        case DivoomPixelToolTypeRect:
        case DivoomPixelToolTypeSolidRect:{
            [super submitDrawingPixel];
        }
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
