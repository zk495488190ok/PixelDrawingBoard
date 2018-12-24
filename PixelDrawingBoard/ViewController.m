//
//  ViewController.m
//  PixelDrawingBoard
//
//  Created by yanhuanpei on 2018/11/23.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "ViewController.h"

#import "PixelDrawingBoard.h"
#import "DivoomCustomPixelRrawView.h"

@interface ViewController ()

@property (nonatomic, strong) PixelDrawingBoard *pixelView;
@property (nonatomic, strong) DivoomCustomPixelRrawView *pixelCanvas;
@property (nonatomic, strong) UISlider          *slider;
@property (nonatomic, strong) UIButton          *btnGridLine;
@property (nonatomic, strong) UIButton          *btnPen;
@property (nonatomic, strong) UIButton          *btnLine;
@property (nonatomic, strong) UIButton          *btnCir;
@property (nonatomic, strong) UIButton          *btnClearScreen;
@property (nonatomic, strong) UIButton          *btnRECT;
@property (nonatomic, strong) UIButton          *btnUndo;
@property (nonatomic, strong) UIButton          *btnResume;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat kScreenW = [UIScreen mainScreen].bounds.size.width;
//    self.pixelView = [[PixelDrawingBoard alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenW)];
//    [self.view addSubview:self.pixelView];
    
    self.pixelCanvas = [[DivoomCustomPixelRrawView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenW) row:32 col:32];
    self.pixelCanvas.userInteractionEnabled = YES;
    self.pixelCanvas.curColor = [UIColor yellowColor];              //黄色
    
    self.pixelCanvas.curToolType = DivoomPixelToolTypePen;          //铅笔
    //self.pixelCanvas.curToolType = DivoomPixelToolTypeLine;       //线条
    [self.view addSubview:self.pixelCanvas];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.pixelCanvas.frame) + 20, kScreenW - 40, 20)];
    self.slider.maximumValue = 10;
    self.slider.minimumValue = 1;
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    //网格线
    self.btnGridLine = [self createButtonWithFrame:CGRectMake(CGRectGetMinX(self.slider.frame), CGRectGetMaxY(self.slider.frame) + 10, 60, 25)
                                             title:@"网格线"
                                            action:@selector(btnGridLineAction)];
    [self.view addSubview:self.btnGridLine];
    
    //铅笔
    self.btnPen = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.btnGridLine.frame) + 10, CGRectGetMaxY(self.slider.frame) + 10, 60, 25)
                                        title:@"铅笔"
                                       action:@selector(btnPenAction)];
    [self.view addSubview:self.btnPen];
    
    //直线
    self.btnLine = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.btnPen.frame) + 10, CGRectGetMaxY(self.slider.frame) + 10, 60, 25)
                                         title:@"直线"
                                        action:@selector(btnLineAction)];
    [self.view addSubview:self.btnLine];
    
    //圆形
    self.btnCir = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.btnLine.frame) + 10, CGRectGetMaxY(self.slider.frame) + 10, 60, 25)
                                        title:@"圆形"
                                       action:@selector(btnCirAction)];
    [self.view addSubview:self.btnCir];
    
    //矩形
    self.btnRECT = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.btnCir.frame) + 10, CGRectGetMaxY(self.slider.frame) + 10, 60, 25)
                                        title:@"矩形"
                                       action:@selector(btnRECTAction)];
    [self.view addSubview:self.btnRECT];
    
    //清屏
    self.btnClearScreen = [self createButtonWithFrame:CGRectMake(CGRectGetMinX(self.slider.frame), CGRectGetMaxY(self.btnGridLine.frame) + 10, 60, 25)
                                         title:@"清屏"
                                        action:@selector(btnClearScreenAction)];
    [self.view addSubview:self.btnClearScreen];
    
    //撤销
    self.btnUndo = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.btnClearScreen.frame) + 10, CGRectGetMaxY(self.btnGridLine.frame) + 10, 60, 25)
                                                title:@"撤销"
                                               action:@selector(btnUndoAction)];
    [self.view addSubview:self.btnUndo];
    
    //恢复
    self.btnResume = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.btnUndo.frame) + 10, CGRectGetMaxY(self.btnGridLine.frame) + 10, 60, 25)
                                                title:@"恢复"
                                               action:@selector(btnResumeAction)];
    [self.view addSubview:self.btnResume];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = .5;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Actions

- (void)btnUndoAction {
    [self.pixelCanvas undo];
}

- (void)btnResumeAction {
    [self.pixelCanvas resume];
}

- (void)btnRECTAction {
    self.pixelCanvas.curToolType = DivoomPixelToolTypeRect;
}

- (void)btnCirAction {
    self.pixelCanvas.curToolType = DivoomPixelToolTypeCir;
}

- (void)btnClearScreenAction {
    [self.pixelCanvas clearScreen];
}

- (void)btnLineAction {
    self.pixelCanvas.curToolType = DivoomPixelToolTypeLine;
}

- (void)btnPenAction {
    self.pixelCanvas.curToolType = DivoomPixelToolTypePen;
}

- (void)btnGridLineAction {
    [self.pixelCanvas setShowGridLine:!self.pixelCanvas.showGridLine];
}

- (void)sliderAction:(UISlider *)slider {
    //CGFloat value = slider.value;
    //[self.pixelView setScale:value];
}

@end
