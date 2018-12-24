//
//  Header.h
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/17.
//  Copyright © 2018 zhuk. All rights reserved.
//

#ifndef DivoomPixel_h
#define DivoomPixel_h

// TODO:移动方向枚举
typedef enum : NSUInteger {
    DivoomPixelMoveTypeUP,
    DivoomPixelMoveTypeRight,
    DivoomPixelMoveTypeBottom,
    DivoomPixelMoveTypeLeft
} DivoomPixelMoveType;

// TODO:画板工具枚举
typedef enum : NSUInteger {
    DivoomPixelToolTypePen,         //铅笔
    DivoomPixelToolTypeLine,        //线条
    DivoomPixelToolTypeCir,         //圆
    DivoomPixelToolTypeSolidCir,    //实心圆
    DivoomPixelToolTypeRect,         //矩形
    DivoomPixelToolTypeSolidRect,    //实心矩形
    DivoomPixelToolTypeMove,        //移动
    DivoomPixelToolTypePaintBucket  //油漆桶
} DivoomPixelToolType;

#endif /* DivoomPixel */
