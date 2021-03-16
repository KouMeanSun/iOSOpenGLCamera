//
//  ViewController.m
//  CameraOpenGL
//
//  Created by 高明阳 on 2021/3/16.
//

#import "ViewController.h"
#import "CameraController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong)UIButton *cameraBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit{
    self.title = @"OpenGL预览相机";
    self.view.backgroundColor  = [UIColor whiteColor];
    [self addMySubViews];
    [self addMyContraints];
}

-(void)addMySubViews{
    [self.view addSubview:self.cameraBtn];
}
-(void)addMyContraints{
    self.cameraBtn.frame = CGRectMake(20, ScreenHeight-90, ScreenWidth-40, 40);
}

#pragma mark -- click
-(void)camreaClick:(UIButton *)btn{
    [self.navigationController pushViewController:[CameraController new] animated:YES];
}

#pragma mark -- lazy load
- (UIButton *)cameraBtn{
    if (_cameraBtn == nil) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraBtn.layer.borderWidth = 1;
        _cameraBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _cameraBtn.layer.cornerRadius = 5;
        [_cameraBtn setTitle:@"后置相机" forState:UIControlStateNormal];
        _cameraBtn.titleLabel.textColor = [UIColor redColor];
        _cameraBtn.backgroundColor = [UIColor greenColor];
        [_cameraBtn addTarget:self action:@selector(camreaClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}
@end
