//
//  UIViewController+Util.m
//  AT
//
//  Created by Apple on 14-9-6.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "UIViewController+Util.h"
#import "UIColor+Util.h"
//#import "ATBarButton.h"

static char currentInputKey;
static char currentFocusKey;
static char tapGestureRecognizerKey;
static char currentTextFiledChangeViewKey;
static CGRect currentTextFailedChangeViewOldFrameKey;
static CGRect currentFocusRectKey;


@implementation UIViewController (Util)
- (void)setNavTitle:(NSString *)title {
    self.navigationItem.title = title;
}


- (void)goBack
{
    [self goBack:YES];
}
- (void)goBack:(BOOL)animated
{
    @try {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:animated];
        }
        else if (self.presentingViewController) {
            [self dismissViewControllerAnimated:animated completion:nil];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
- (void)dismissOrPopToRootControlelr {
    [self dismissOrPopToRootController:YES];
}
- (void)dismissOrPopToRootController:(BOOL)animated {
    @try {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:animated completion:nil];
        }
        else if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popToRootViewControllerAnimated:animated];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (UIView *)currentInput {
    return objc_getAssociatedObject(self, &currentInputKey);
}
- (void)setCurrentInput:(UIView *)currentInput {
    objc_setAssociatedObject(self, &currentInputKey, currentInput, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)currentFocus {
    return objc_getAssociatedObject(self, &currentFocusKey);
}
- (void)setCurrentFocus:(UIView *)currentFocus {
    if (currentFocus == nil) {
        self.currentFocusRect = CGRectZero;
    }
    else if (currentFocus && CGRectIsEmpty(self.currentFocusRect)) {
        self.currentFocusRect = currentFocus.bounds;
    }
    objc_setAssociatedObject(self, &currentFocusKey, currentFocus, OBJC_ASSOCIATION_ASSIGN);
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    return objc_getAssociatedObject(self, &tapGestureRecognizerKey);
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    objc_setAssociatedObject(self, &tapGestureRecognizerKey, tapGestureRecognizer, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)currentTextFiledChangeView {
    return objc_getAssociatedObject(self, &currentTextFiledChangeViewKey);
}

- (void)setCurrentTextFiledChangeView:(UIView *)currentTextFiledChangeView {
    
    if (self.currentTextFiledChangeView != currentTextFiledChangeView) {
        if (self.currentTextFiledChangeView) {
            self.currentTextFiledChangeView.frame = self.currentTextFailedChangeViewOldFrame;
        }
        if (currentTextFiledChangeView) {
            self.currentTextFailedChangeViewOldFrame = currentTextFiledChangeView.frame;
        }
        else {
            self.currentTextFailedChangeViewOldFrame = CGRectZero;
        }
    }
    objc_setAssociatedObject(self, &currentTextFiledChangeViewKey, currentTextFiledChangeView, OBJC_ASSOCIATION_ASSIGN);
}

- (CGRect)currentTextFailedChangeViewOldFrame {
    return currentTextFailedChangeViewOldFrameKey;
}
- (void)setCurrentTextFailedChangeViewOldFrame:(CGRect)currentTextFailedChangeViewOldFrame {
    currentTextFailedChangeViewOldFrameKey = currentTextFailedChangeViewOldFrame;
}

- (CGRect)currentFocusRect {
    return currentFocusRectKey;
}
- (void)setCurrentFocusRect:(CGRect)currentFocusRect {
    currentFocusRectKey = currentFocusRect;
}

- (void)didTapAnywhere:(UITapGestureRecognizer*) recognizer {
    [self currentInputResignFirstResponder];
}

- (void)currentInputResignFirstResponder
{
    if (self.currentInput && [self.currentInput isFirstResponder]) {
        [self.currentInput resignFirstResponder];
    }
    self.currentInput = nil;
}

- (instancetype)topPresentedVC {
    UIViewController *rootVC = self;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        rootVC = ((UITabBarController *)rootVC).selectedViewController;
    }
    return rootVC;
}
+ (instancetype)rootTopPresentedVC {
    return [[[UIApplication sharedApplication] delegate] window].rootViewController.topPresentedVC;
}

- (NSArray<UIViewController *> *)optimizeVcs:(NSArray<UIViewController *> *)vcs {
    NSMutableArray *vcArray = [NSMutableArray array];
    [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[self class]]) {
            [vcArray addObject:obj];
        }
    }];
    [vcArray addObject:self];
    return vcArray;
}
@end
