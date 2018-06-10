//
//  UINavigationBar+CustomHeight.m
//  WXNavi
//
//  Created by Somiya on 07/06/2018.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "UINavigationBar+CustomHeight.h"
#import <objc/runtime.h>
#import "Constants.h"

static char const *const heightKey = "height";

@implementation UINavigationBar (CustomHeight)

- (void)setHeight:(CGFloat)height
{
    objc_setAssociatedObject(self, heightKey, @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)height
{
    return objc_getAssociatedObject(self, heightKey);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize;
    NSLog(@"%@", size);
    if (self.height) {
        newSize = CGSizeMake(self.superview.bounds.size.width, [self.height floatValue]);
    } else {
        newSize = [super sizeThatFits:size];
    }
    
    return newSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), [self.height floatValue]);
    NSLog(@"%@", self.frame);
    for (UIView *view in self.subviews) {
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
        } else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            CGRect frame = view.frame;
            frame.origin.y = 20;
            frame.size.height = self.bounds.size.height - frame.origin.y;
            view.frame = frame;
        }
    }
}
@end
