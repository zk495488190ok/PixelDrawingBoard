//
//  DivoomCustomPixelRrawView.h
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/18.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomPixelDrawView.h"
#import "DivoomPixel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DivoomCustomPixelRrawView : DivoomPixelDrawView

@property (nonatomic, assign) DivoomPixelToolType curToolType;      //当前使用工具类型

@end

NS_ASSUME_NONNULL_END
