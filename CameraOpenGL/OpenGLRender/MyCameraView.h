//
//  MyCameraView.h
//  CameraOpenGL
//
//  Created by 高明阳 on 2021/3/16.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCameraView : UIView
@property (nonatomic , assign) BOOL isFullYUVRange;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
