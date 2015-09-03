//
//  PBNavigationController.h
//  Demo
//
//  Created by Petr Bobak on 26.08.15.
//  Copyright (c) 2015 Aladdin Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBNavigationController : UINavigationController

- (void)addClassOfTransparentViewController:(Class)viewControllerClass;
- (void)setDefaultBackground;
- (void)setTransparentBackground;
- (BOOL)isTransparent;

-(CGRect)frameForGradientView;

@end
