//
//  UIViewController+Util.h
//  AT
//
//  Created by Apple on 14-9-6.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIViewController (Util)

@property(nonatomic, weak)UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, weak)UIView *currentInput;
@property(nonatomic, weak)UIView *currentFocus;
@property(nonatomic, weak)UIView *currentTextFiledChangeView;
@property(nonatomic, assign)CGRect currentFocusRect;
@property(nonatomic, assign, readonly)CGRect currentTextFailedChangeViewOldFrame;

- (void)currentInputResignFirstResponder;
- (void)didTapAnywhere:(UITapGestureRecognizer*) recognizer;

/**
 *  设置导航栏标题
 */
- (void)setNavTitle:(NSString *)title;
/**
 *  导航栏 按钮，color为空时，标示默认颜色
 */

/**
 *  返回上一个界面
 */
- (void)goBack;
- (void)goBack:(BOOL)animated;
- (void)dismissOrPopToRootControlelr;
- (void)dismissOrPopToRootController:(BOOL)animated;

- (instancetype)topPresentedVC;
+ (instancetype)rootTopPresentedVC;

/**
 *  控制器数组中 仅存在一个实例
 */
- (NSArray<UIViewController *> *)optimizeVcs:(NSArray<UIViewController *> *)vcs;
@end
