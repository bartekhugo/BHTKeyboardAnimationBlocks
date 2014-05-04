//
//  UIViewController+BHTKeyboardNotifications.m
//
//  Created by Bartek Hugo Trzcinski on 16/04/14.
//  Copyright (c) 2014 Untitled Kingdom. All rights reserved.
//

#import "UIViewController+BHTKeyboardNotifications.h"
#import <objc/runtime.h>

static void * const kWillShowBlockKey   = (void*)&kWillShowBlockKey;
static void * const kWillHideBlockKey   = (void*)&kWillHideBlockKey;
static void * const kDidShowBlockKey    = (void*)&kDidShowBlockKey;
static void * const kDidHideBlockKey    = (void*)&kDidHideBlockKey;
static void * const kNotificationsOnKey = (void*)&kNotificationsOnKey;

/*
 Category responsible for storing block as associated objects as it's impossible to add properties in class categories
 */
@implementation UIViewController (BHTBlockProperties)

#pragma mark - willShow

- (void)bht_setWillShowAnimationBlock:(BHTKeyboardFrameAnimationBlock)willShowBlock
{
    objc_setAssociatedObject(self, kWillShowBlockKey, willShowBlock, OBJC_ASSOCIATION_COPY);
}

- (BHTKeyboardFrameAnimationBlock)bht_willShowAnimationBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kWillShowBlockKey);
}

#pragma mark - willHide

- (void)bht_setWillHideAnimationBlock:(BHTKeyboardFrameAnimationBlock)willHideBlock
{
    objc_setAssociatedObject(self, kWillHideBlockKey, willHideBlock, OBJC_ASSOCIATION_COPY);
}

- (BHTKeyboardFrameAnimationBlock)bht_willHideAnimationBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kWillHideBlockKey);
}

#pragma mark - didShow

- (void)bht_setDidShowActionBlock:(BHTKeyboardFrameAnimationBlock)didShowBlock
{
    objc_setAssociatedObject(self, kDidShowBlockKey, didShowBlock, OBJC_ASSOCIATION_COPY);
}

- (BHTKeyboardFrameAnimationBlock)bht_didShowActionBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kDidShowBlockKey);
}

#pragma mark - didHide

- (void)bht_setDidHideActionBlock:(BHTKeyboardFrameAnimationBlock)didHideBlock
{
    objc_setAssociatedObject(self, kDidHideBlockKey, didHideBlock, OBJC_ASSOCIATION_COPY);
}

- (BHTKeyboardFrameAnimationBlock)bht_didHideActionBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kDidHideBlockKey);
}

#pragma mark - areNotificationsOn

- (void)bht_setNotificationsOn:(BOOL)notificationsOn
{
    objc_setAssociatedObject(self, kNotificationsOnKey, @(notificationsOn), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)bht_areNotificationsOn
{
    return [(NSNumber *)objc_getAssociatedObject(self, kNotificationsOnKey) boolValue];
}

@end



#pragma mark -

@implementation UIViewController (BHTKeyboardNotifications)

#pragma mark - public

- (void)setKeyboardWillShowAnimationBlock:(BHTKeyboardFrameAnimationBlock)showBlock
{
    if ([self bht_areNotificationsOn])
    {
        BHTKeyboardFrameAnimationBlock prevWillShowBlock = [self bht_willShowAnimationBlock];

        if (!showBlock && prevWillShowBlock)
            [self unregisterWillShowNotification];
        else if (showBlock && !prevWillShowBlock)
            [self registerWillShowNotification];
    }
    
    [self bht_setWillShowAnimationBlock:showBlock];
}

- (void)setKeyboardWillHideAnimationBlock:(BHTKeyboardFrameAnimationBlock)hideBlock
{
    if ([self bht_areNotificationsOn])
    {
        BHTKeyboardFrameAnimationBlock prevWillHideBlock = [self bht_willHideAnimationBlock];

        if (!hideBlock && prevWillHideBlock)
            [self unregisterWillHideNotification];
        else if (hideBlock && !prevWillHideBlock)
            [self registerWillHideNotification];
    }
    
    [self bht_setWillHideAnimationBlock:hideBlock];
}

- (void)setKeyboardDidShowActionBlock:(BHTKeyboardFrameAnimationBlock)didShowBlock
{
    if ([self bht_areNotificationsOn])
    {
        BHTKeyboardFrameAnimationBlock prevDidShowBlock = [self bht_didShowActionBlock];

        if (!didShowBlock && prevDidShowBlock)
            [self unregisterDidShowNotification];
        else if (didShowBlock && !prevDidShowBlock)
            [self registerDidShowNotification];
    }
    
    [self bht_setDidShowActionBlock:didShowBlock];
}

- (void)setKeyboardDidHideActionBlock:(BHTKeyboardFrameAnimationBlock)didHideBlock
{
    if ([self bht_areNotificationsOn])
    {
        BHTKeyboardFrameAnimationBlock prevDidHideBlock = [self bht_didHideActionBlock];

        if (!didHideBlock && prevDidHideBlock)
            [self unregisterDidHideNotification];
        else if (didHideBlock && !prevDidHideBlock)
            [self registerDidHideNotification];
    }
    
    [self bht_setDidHideActionBlock:didHideBlock];
}

#pragma mark - registering notifications

- (void)bht_registerForKeyboardNotifications
{
    [self bht_setNotificationsOn:YES];

    if ([self bht_willShowAnimationBlock])
        [self registerWillShowNotification];
    
    if ([self bht_willHideAnimationBlock])
        [self registerWillHideNotification];
    
    if ([self bht_didShowActionBlock])
        [self registerDidShowNotification];
    
    if ([self bht_didHideActionBlock])
        [self registerDidHideNotification];
}

- (void)registerWillShowNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)registerWillHideNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)registerDidShowNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
- (void)registerDidHideNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)bht_unregisterForKeyboardNotifications
{
    [self bht_setNotificationsOn:NO];
    
    if ([self bht_willShowAnimationBlock])
        [self unregisterWillShowNotification];
    
    if ([self bht_willHideAnimationBlock])
        [self unregisterWillHideNotification];
    
    if ([self bht_didShowActionBlock])
        [self unregisterDidShowNotification];
    
    if ([self bht_didHideActionBlock])
        [self unregisterDidHideNotification];
}

- (void)unregisterWillShowNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)unregisterWillHideNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)unregisterDidShowNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
- (void)unregisterDidHideNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - notification callbacks

- (void)bht_keyboardWillShow:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_willShowAnimationBlock]
               withNotification:notification];
}

- (void)bht_keyboardWillHide:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_willHideAnimationBlock]
               withNotification:notification];
}

- (void)bht_keyboardDidShow:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_didShowActionBlock]
               withNotification:notification];
}

- (void)bht_keyboardDidHide:(NSNotification *)notification
{
    [self bht_performAnimationBlock:[self bht_didHideActionBlock]
               withNotification:notification];
}

- (void)bht_performAnimationBlock:(BHTKeyboardFrameAnimationBlock)animationBlock withNotification:(NSNotification *)notification
{
    if (!animationBlock)
        return;
    
    NSDictionary *info = [notification userInfo];
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve                  = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    CGRect keyboardFrame             = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:curve
                     animations:^{ animationBlock(keyboardFrame); }
                     completion:nil];
}

#pragma mark - methods swizzling

+ (void)load
{
    [self bht_swizzleViewWillApper];
    [self bht_swizzleViewDidDisapper];
}

#pragma mark viewDidAppear

+ (void)bht_swizzleViewWillApper
{
    Method original, swizz;

    original = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    swizz = class_getInstanceMethod([self class], @selector(bht_viewWillAppear:));
    
    method_exchangeImplementations(original, swizz);
}

- (void)bht_viewWillAppear:(BOOL)animated
{
    [self bht_registerForKeyboardNotifications];
    
    [self bht_viewWillAppear:animated];
}

#pragma mark viewDidDisappear

+ (void)bht_swizzleViewDidDisapper
{
    Method original, swizz;
    
    original = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    swizz = class_getInstanceMethod([self class], @selector(bht_viewDidDisappear:));
    method_exchangeImplementations(original, swizz);
}

- (void)bht_viewDidDisappear:(BOOL)animated
{
    [self bht_unregisterForKeyboardNotifications];
    
    [self bht_viewDidDisappear:animated];
}

@end
