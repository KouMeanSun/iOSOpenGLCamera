//
//  ViewController.m
//  CameraOpenGL
//
//  Created by 高明阳 on 2021/3/16.
//

#import "ViewController.h"
#import "CameraController.h"
#import "FrontCameraController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong)UIButton *cameraBtn;
@property (nonatomic,strong)UIButton *frontCameraBtn;
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
    [self.view addSubview:self.frontCameraBtn];
}
-(void)addMyContraints{
    self.cameraBtn.frame = CGRectMake(20, ScreenHeight-90, ScreenWidth-40, 40);
    self.frontCameraBtn.frame = CGRectMake(20, ScreenHeight-140, ScreenWidth-40, 40);
}

#pragma mark -- click
-(void)cameraClick:(UIButton *)btn{
    [self.navigationController pushViewController:[CameraController new] animated:YES];
}
-(void)frontCameraClick:(UIButton *)btn{
    [self.navigationController pushViewController:[FrontCameraController new] animated:YES];

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
        [_cameraBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}
- (UIButton *)frontCameraBtn{
    if (_frontCameraBtn == nil) {
        _frontCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _frontCameraBtn.layer.borderWidth = 1;
        _frontCameraBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _frontCameraBtn.layer.cornerRadius = 5;
        [_frontCameraBtn setTitle:@"前置相机" forState:UIControlStateNormal];
        _frontCameraBtn.titleLabel.textColor = [UIColor redColor];
        _frontCameraBtn.backgroundColor = [UIColor greenColor];
        [_frontCameraBtn addTarget:self action:@selector(frontCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _frontCameraBtn;
}
@end
