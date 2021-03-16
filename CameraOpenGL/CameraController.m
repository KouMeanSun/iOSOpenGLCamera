//
//  CameraController.m
//  CameraOpenGL
//
//  Created by 高明阳 on 2021/3/16.
//

#import "CameraController.h"
#import "MyCameraView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface CameraController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) UILabel  *mLabel;
@property (nonatomic, strong) AVCaptureSession *mCaptureSession; //负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *mCaptureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput; //output

// OpenGL ES
@property (nonatomic, strong)  MyCameraView *mGLView;

@end

@implementation CameraController
{
    dispatch_queue_t mProcessQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initOpenGL];
    [self addMySubViews];
    [self addMyContraints];
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
    
    self.mCaptureSession = [[AVCaptureSession alloc] init];
    self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    
    mProcessQueue = dispatch_queue_create("mProcessQueue", DISPATCH_QUEUE_SERIAL);
    
    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionBack)
        {
            inputCamera = device;
        }
//        if ([device position] == AVCaptureDevicePositionFront)
//        {
//            inputCamera = device;
//        }
    }
    
    self.mCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    
    if ([self.mCaptureSession canAddInput:self.mCaptureDeviceInput]) {
        [self.mCaptureSession addInput:self.mCaptureDeviceInput];
    }
    
    
    self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    self.mGLView.isFullYUVRange = YES;
    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:mProcessQueue];
    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
    }
    
    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    switch ([[UIDevice currentDevice] orientation])
    {
            
        case UIInterfaceOrientationPortrait:
            [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            
            break;
        case UIInterfaceOrientationLandscapeRight:
            [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight]; //home button on right. Refer to .h not doc
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft]; //home button on left. Refer to .h not doc
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown]; //home button on left. Refer to .h not doc
            break;
        default:
            [connection setVideoOrientation:AVCaptureVideoOrientationPortrait]; //for portrait upside down. Refer to .h not doc
            break;
    }
    
    
    [self.mCaptureSession startRunning];
    
    
    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];
}
-(void)addMySubViews{
    
}
-(void)addMyContraints{
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    static long frameID = 0;
    ++frameID;
    CFRetain(sampleBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        [self.mGLView displayPixelBuffer:pixelBuffer];
        self.mLabel.text = [NSString stringWithFormat:@"%ld", frameID];
        CFRelease(sampleBuffer);
    });
}

@end
