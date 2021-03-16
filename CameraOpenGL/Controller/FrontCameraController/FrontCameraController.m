//
//  FrontCameraController.m
//  CameraOpenGL
//
//  Created by 高明阳 on 2021/3/16.
//

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "FrontCameraController.h"
#import "MyCameraView.h"
#import "MyCamera.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FrontCameraController ()<MyCameraDelegate>
@property (nonatomic, strong) UILabel  *mLabel;
@property (nonatomic, strong) MyCamera *camera;
// OpenGL ES
@property (nonatomic, strong)  MyCameraView *mGLView;

@end

@implementation FrontCameraController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_camera startCapture];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initCamera];
    [self initOpenGL];
    [self addMySubViews];
    [self addMyContraints];
}
-(void)initCamera{
    _camera = [[MyCamera alloc] initWithCameraPosition:AVCaptureDevicePositionFront captureFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    _camera.delegate = self;
     self.camera.videoOrientation = AVCaptureVideoOrientationPortrait;
}
-(void)initOpenGL{
    //self.mCaptureSession.sessionPreset = AVCaptureSessionPreset640x480; frame 要和 分辨率比例对应，否则会拉伸和不可预见的异常
    
    self.mGLView = [[MyCameraView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (float)(1280/720.f)*ScreenWidth)];
    float scale = MAX(ScreenHeight / 1280, ScreenWidth / 720);
    float leftMargin = (720 * scale - ScreenWidth) / 2;
    float topMargin = (1280 * scale - ScreenHeight) / 2;
    self.mGLView.bounds = CGRectMake(-leftMargin, 0, ScreenWidth + leftMargin * 2, ScreenHeight + topMargin * 2);
    self.mGLView.center = self.view.center;
    [self.view addSubview:self.mGLView];
    self.mGLView.isFullYUVRange = YES;

    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];
}
-(void)addMySubViews{
    
}
-(void)addMyContraints{
    
}

/// MyCameraDelegate
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    static long frameID = 0;
    ++frameID;
    CFRetain(sampleBuffer);
    typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        typeof(weakSelf) strongSelf = weakSelf;
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        [strongSelf.mGLView displayPixelBuffer:pixelBuffer];
        strongSelf.mLabel.text = [NSString stringWithFormat:@"%ld", frameID];
        CFRelease(sampleBuffer);
    });
}

@end
