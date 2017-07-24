//
//  UIFont+CustomFont.m
//  JewelryStore
//
//  Created by wsk on 17/5/23.
//  Copyright © 2017年 com. All rights reserved.
//

#import "UIFont+CustomFont.h"
#import <objc/runtime.h>

#define exchangeClassMethod(class, sel, mysel) method_exchangeImplementations(class_getClassMethod((class), (sel)), class_getClassMethod((class), (mysel)));

#define exchangeInstanceMethod(class, sel, mysel) method_exchangeImplementations(class_getInstanceMethod((class), (sel)), class_getInstanceMethod((class), (mysel)));
@implementation UIFont (CustomFont)

+ (void)load {
    exchangeClassMethod(self, @selector(systemFontOfSize:), @selector(at_systemFontOfSize:));
    exchangeClassMethod(self, @selector(boldSystemFontOfSize:), @selector(at_boldSystemFontOfSize:));
    exchangeClassMethod(self, @selector(italicSystemFontOfSize:), @selector(at_italicSystemFontOfSize:));
}

+ (instancetype)at_systemFontOfSize:(CGFloat)fontSize {
    return [self systemFontOfSize:fontSize weight:UIFontWeightThin];
}

+ (instancetype)at_boldSystemFontOfSize:(CGFloat)fontSize {
    return [self systemFontOfSize:fontSize weight:UIFontWeightThin];
}

+ (instancetype)at_italicSystemFontOfSize:(CGFloat)fontSize {
    return [self systemFontOfSize:fontSize weight:UIFontWeightThin];
}

- (instancetype)appWeightFont {
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorByAddingAttributes:@{@"NSCTFontUIUsageAttribute" : @"CTFontThinUsage"}] size:self.pointSize];
}

@end


#define exchangeInstanceMethod__(fun) exchangeInstanceMethod([self class], @selector(fun), @selector(at_##fun))
#define implementationExchangeFont(class, obj) \
@implementation class (myFont)\
+ (void)load {\
exchangeInstanceMethod__(initWithCoder:);\
exchangeInstanceMethod__(initWithFrame:);\
}\
- (id)at_initWithCoder:(NSCoder*)aDecode {\
[self at_initWithCoder:aDecode];\
if (self) { obj.font = [obj.font appWeightFont]; }\
return self;\
}\
- (id)at_initWithFrame:(CGRect)frame {\
[self at_initWithFrame:frame];\
if (self) { obj.font = [obj.font appWeightFont]; }\
return self;\
}\
@end
#define getterHookOnce__(fun)  - (id<at_myFontprotocol>)at_##fun {\
id<at_myFontprotocol> obj = [self at_##fun];\
if (obj) { (obj).font = [(obj).font appWeightFont]; }\
exchangeInstanceMethod__(fun);\
return obj;\
}


implementationExchangeFont(UILabel, self)
implementationExchangeFont(UITextField, self)
implementationExchangeFont(UITextView, self)
implementationExchangeFont(UIButton, self.titleLabel)

@protocol at_myFontprotocol <NSObject>
@property (nonatomic, strong) UIFont *font;
@end

@implementation UITableViewCell (myFont)
+ (void)load {
    exchangeInstanceMethod__(textLabel);
    exchangeInstanceMethod__(detailTextLabel);
}
getterHookOnce__(textLabel)
getterHookOnce__(detailTextLabel)
@end
