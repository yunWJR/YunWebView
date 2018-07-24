//
// Created by yun on 2018/7/24.
// Copyright (c) 2018 yun. All rights reserved.
//

#import "UIImage+Rotate.h"

@implementation UIImage (Rotate)

static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180.0f;
}

- (UIImage *)imageByRotateLeft90 {
    return [self imageByRotate:DegreesToRadians(90) fitSize:YES];
}

- (UIImage *)imageByRotateRight90 {
    return [self imageByRotate:DegreesToRadians(-90) fitSize:YES];
}

- (UIImage *)imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    size_t width = (size_t) CGImageGetWidth(self.CGImage);
    size_t height = (size_t) CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ?
                                                CGAffineTransformMakeRotation(radians) :
                                                CGAffineTransformIdentity);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t) newRect.size.width,
                                                 (size_t) newRect.size.height,
                                                 8,
                                                 (size_t) newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;

    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);

    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);

    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

@end