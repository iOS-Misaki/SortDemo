//
//  SortView.m
//  SortDemo
//
//  Created by 余意 on 2018/4/13.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "SortView.h"

@implementation SortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat y = self.superview.frame.size.height - self.frame.size.height;
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
    CGFloat weight = frame.size.height / self.superview.frame.size.height;
    UIColor * color = [UIColor colorWithHue:weight saturation:1 brightness:1 alpha:1];
    self.backgroundColor = color;
}

- (void)updateHeight:(CGFloat)height
{
    CGRect temp = self.frame;
    temp.size.height = height;
    self.frame = temp;
}

@end
