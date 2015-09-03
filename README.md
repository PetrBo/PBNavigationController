# PBNavigationController
Custom `UINavigationController` with support for combination of transparent and default `UINavigationBar`.

## Screenshot

![example.gif](https://github.com/PetrBo/PBNavigationController/raw/master/Screenshots/example.gif)

## Installation
1. Copy `PBNavigationController` folder to your project.
2. Change class of navigation controller to `PBNavigationController`.

## Setup

2. Import `PBNavigationController.h` and all header files of transparent view controllers into `AppDelegate.m`.
3. Get the `rootViewController` and call `addClassOfTransparentViewController:`.

### Example

```objective-c
PBNavigationController *navController = (PBNavigationController *)self.window.rootViewController;
[navController addClassOfTransparentViewController:[SecondTableViewController class]];
[navController addClassOfTransparentViewController:[FourthTableViewController class]];
```

## Setting navigationBar manually to default or transparent

```objective-c
- (void)setDefaultBackground;
- (void)setTransparentBackground;
- (BOOL)isTransparent;
```

### Example

```objective-c
[(PBNavigationController *)self.navigationController setTransparentBackground];
```

## License

**Copyright (c) 2015 Petr Bobak (PetrBobak@me.com | @PeterBobak)**

`PBNavigationController` is available under the MIT license. See the LICENSE file for more info.
