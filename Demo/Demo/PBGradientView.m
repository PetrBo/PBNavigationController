//
//  PBGradientView.m
//  Demo
//
//  Created by Petr Bobak on 03.09.15.
//  Copyright (c) 2015 Petr Bobak. All rights reserved.
//

#import "PBGradientView.h"

@interface PBGradientView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation PBGradientView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.gradientLayer = [CAGradientLayer layer];
        NSArray *colors = @[(id)[UIColor colorWithWhite:0.f alpha:0.25f].CGColor,
                            (id)[UIColor colorWithWhite:0.f alpha:0.0f].CGColor,
                            ];
        [self.gradientLayer setColors:colors];
        
        [self.gradientLayer setStartPoint:CGPointMake(0.0f, 0.20f)];
        [self.gradientLayer setEndPoint:CGPointMake(0.0f, 1.f)];
        self.gradientLayer.frame = self.bounds;
        
        self.backgroundColor = [UIColor clearColor];
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [CATransaction begin];
    [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        self.gradientLayer.frame = self.bounds;
    [CATransaction commit];
}

@end
