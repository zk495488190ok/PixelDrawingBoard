//
//  DivoomPixelCanvas.h
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/12/15.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DivoomPixelAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface DivoomPixelCanvas : UIView

@property (nonatomic, assign) NSInteger             row;
@property (nonatomic, assign) NSInteger             col;
@property (nonatomic, assign) BOOL                  showGridLine;
@property (nonatomic, strong) DivoomPixelAdapter    *pixelAdapter;

- (instancetype)initWithRow:(NSInteger)row col:(NSInteger)col;
- (instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col;

- (CGFloat)getPixelWidth;

@end

NS_ASSUME_NONNULL_END
