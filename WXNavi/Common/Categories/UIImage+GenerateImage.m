//
// Created by Somiya on 08/06/2018.
// Copyright (c) 2018 Somiya. All rights reserved.
//

#import "UIImage+GenerateImage.h"


@implementation UIImage (GenerateImage)
+ (UIImage *)generateImageWithColor:(UIColor *)color size:(CGSize)size  {
    CGRect rect = (CGRect) {{0, 0}, size};
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end