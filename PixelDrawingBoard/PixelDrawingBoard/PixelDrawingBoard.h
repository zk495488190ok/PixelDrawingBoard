//
//  PixelDrawingBoard.h
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/11/23.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PixelDrawingBoard : UIView

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger col;

@property (nonatomic, assign, readonly) CGFloat scale;

@property (nonatomic, strong) UIColor *curFillColor;


#pragma mark - 功能列表

-(void)setScale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
