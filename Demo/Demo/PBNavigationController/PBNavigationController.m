//
//  PBNavigationController.m
//  Demo
//
//  Created by Petr Bobak on 26.08.15.
//  Copyright (c) 2015 Aladdin Inc. All rights reserved.
//

#import "PBNavigationController.h"
#import <objc/runtime.h>

static char kNavigationBarKey;

@interface PBNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableSet *transparentViewControllers;
@property (nonatomic, weak) UIImageView *navigationBarShadowImageView;

@property (nonatomic, weak) UINavigationBar *fakeBarForSeque;
@property (nonatomic, strong) NSMutableArray *pushedControllersWithFakeNavigationBar;

@end

@implementation PBNavigationController

#pragma mark - Public methods

- (void)setDefaultBackground {
    // show navigation bar shadow
    self.navigationBarShadowImageView.hidden = NO;
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)isTransparent {
    
    return self.navigationBarShadowImageView.hidden;
}

- (void)setTransparentBackground {
    // make navigation bar transparent and hide navigation bar shadow
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBarShadowImageView.hidden = YES;
}

- (void)addClassOfTransparentViewController:(Class)viewControllerClass {
    [self.transparentViewControllers addObject:viewControllerClass];
}

-(CGRect)frameForGradientView {
    
    CGRect frame = self.navigationBar.frame;
    frame.size.height += 3 * [[UIApplication sharedApplication] statusBarFrame].size.height;
    frame.origin.y -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    return frame;
}

#pragma mark - Lazy Instantiation methods

-(NSMutableArray *)pushedControllersWithFakeNavigationBar {
    if (!_pushedControllersWithFakeNavigationBar) {
        _pushedControllersWithFakeNavigationBar = [[NSMutableArray alloc] init];
    }
    return _pushedControllersWithFakeNavigationBar;
}

- (NSMutableSet *)transparentViewControllers {
    if (!_transparentViewControllers) {
        _transparentViewControllers = [[NSMutableSet alloc] init];
    }
    return _transparentViewControllers;
}

#pragma mark - Helper methods

- (UIImageView *)findShadowImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findShadowImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (UINavigationBar *)navigationBarForViewController:(UIViewController *)viewController {
    
    CGRect frame = self.navigationBar.frame;
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:frame];
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        frame.origin = CGPointMake(0, -self.navigationBar.frame.size.height - statusHeight);
    } else {
        frame.origin = CGPointMake(0, 0);
    }
    
    frame.size.height += statusHeight;
    bar.frame = frame;
    
    return bar;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarShadowImageView = [self findShadowImageViewUnder:self.navigationBar];
    
    // this prevents the display of black shadow under right corner of navigation bar
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overrided methods

- (void)pushViewController:(UIViewController *)topVC animated:(BOOL)animated {
    
    // bottomVC is VC under the one that is currently being pushed
    UIViewController *bottomVC = [self.viewControllers lastObject];
    
    if ([self.transparentViewControllers containsObject:[topVC class]]) {
        
        if (bottomVC.navigationController.navigationBar
            && !bottomVC.navigationController.navigationBarHidden
            && ![self.transparentViewControllers containsObject:[bottomVC class]]) {
            
            UINavigationBar *bar = [self navigationBarForViewController:bottomVC];
            [bottomVC.view addSubview:bar];
            objc_setAssociatedObject(bottomVC, &kNavigationBarKey, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self.pushedControllersWithFakeNavigationBar addObject:bottomVC];
            NSLog(@"%@ : FAKE BAR ADDED!", [bottomVC class]);
            
            [self setTransparentBackground];
        }
    } else {
        UINavigationBar *bar = [self navigationBarForViewController:topVC];
        [topVC.view addSubview:bar];
        self.fakeBarForSeque = bar;
        
        NSLog(@"%@ : FAKE BAR ADDED!", [topVC class]);
    }
    
    [super pushViewController:topVC animated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)bottomVC animated:(BOOL)animated {
    
    UIViewController *topVC = [self.viewControllers lastObject];
    
    if (![self.transparentViewControllers containsObject:[topVC class]]
        && [self.transparentViewControllers containsObject:[bottomVC class]]) {
        
        [self setTransparentBackground];
        
        UINavigationBar *bar = [self navigationBarForViewController:topVC];
        [topVC.view addSubview:bar];
        self.fakeBarForSeque = bar;
        
        NSLog(@"%@ : FAKE BAR ADDED!", [topVC class]);
    }
    
    return [super popToViewController:bottomVC animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *bottomVC;
    if ([self.viewControllers count] >= 2) {
        bottomVC = [self.viewControllers objectAtIndex:[self.viewControllers count] - 2];
    }
    
    return [[self popToViewController:bottomVC animated:animated] firstObject];
}

#pragma mark - UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UINavigationBar *bar;
    if ([viewController isEqual:[self.pushedControllersWithFakeNavigationBar lastObject]]) {
        // after pop operation removes fake bars from VC with default navigation bar when another VC with transparent bar has been pushed
        
        bar = objc_getAssociatedObject(viewController, &kNavigationBarKey);
        [bar removeFromSuperview];
        
        [self setDefaultBackground];
        
        NSLog(@"%@ : FAKE BAR REMOVED!", [viewController class]);
        [self.pushedControllersWithFakeNavigationBar removeLastObject];
        
    } else if (self.fakeBarForSeque) {
        // removes fake bars from VC with default navigation bar after this VC has been popped to VC with transparent bar
        
        [self.fakeBarForSeque removeFromSuperview];
        
        NSLog(@"SEQUE BAR REMOVED!");
        self.fakeBarForSeque = nil;
        
        if (![self.transparentViewControllers containsObject:[viewController class]]) {
            [self setDefaultBackground];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = viewController.transitionCoordinator;
    [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            // pop gesture canceled
            
            if (self.fakeBarForSeque) {
                
                [self setDefaultBackground];
                [self.fakeBarForSeque removeFromSuperview];
                
                NSLog(@"SEQUE BAR REMOVED!");
                self.fakeBarForSeque = nil;
            }
        }
    }];
}

@end
