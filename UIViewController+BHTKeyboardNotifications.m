//
//  UIViewController+BHTKeyboardNotifications.m
//
//  Created by Bartek Hugo Trzcinski on 16/04/14.
//  Copyright (c) 2014 All rights reserved.
//

#import "UIViewController+BHTKeyboardNotifications.h"
#import <objc/runtime.h>

static void * const kWillShowBlockKey = (void*)&kWillShowBlockKey;
static void * const kWillHideBlockKey = (void*)&kWillHideBlockKey;
static void * const kDidShowBlockKey  = (void*)&kDidShowBlockKey;
static void * const kDidHideBlockKey  = (void*)&kDidHideBlockKey;

/*
 Category responsible for storing block as associated objects as it's impossible to add properties in class categories
 */
@implementation UIViewController (BHTBlockProperties)

#pragma mark - willShow

-(void)bht_setWillShowAnimationBlock:(BHTKeyboardFrameAnimationBlock)willShowBlock
{
    objc_setAssociatedObject(self, kWillShowBlockKey, willShowBlock, OBJC_ASSOCIATION_COPY);
}

-(BHTKeyboardFrameAnimationBlock)bht_willShowAnimationBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kWillShowBlockKey);
}

#pragma mark - willHide

-(void)bht_setWillHideAnimationBlock:(BHTKeyboardFrameAnimationBlock)willHideBlock
{
    objc_setAssociatedObject(self, kWillHideBlockKey, willHideBlock, OBJC_ASSOCIATION_COPY);
}

-(BHTKeyboardFrameAnimationBlock)bht_willHideAnimationBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kWillHideBlockKey);
}

#pragma mark - didShow

-(void)bht_setDidShowActionBlock:(BHTKeyboardFrameAnimationBlock)didShowBlock
{
    objc_setAssociatedObject(self, kDidShowBlockKey, didShowBlock, OBJC_ASSOCIATION_COPY);
}

-(BHTKeyboardFrameAnimationBlock)bht_didShowActionBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kDidShowBlockKey);
}

#pragma mark - didHide

-(void)bht_setDidHideActionBlock:(BHTKeyboardFrameAnimationBlock)didHideBlock
{
    objc_setAssociatedObject(self, kDidHideBlockKey, didHideBlock, OBJC_ASSOCIATION_COPY);
}

-(BHTKeyboardFrameAnimationBlock)bht_didHideActionBlock
{
    return (BHTKeyboardFrameAnimationBlock)objc_getAssociatedObject(self, kDidHideBlockKey);
}

@end



#pragma mark -

@implementation UIViewController (BHTKeyboardNotifications)

#pragma mark - public

- (void)setKeyboardWillShowAnimationBlock:(BHTKeyboardFrameAnimationBlock)showBlock
{
    [self bht_setWillShowAnimationBlock:showBlock];
}

- (void)setKeyboardWillHideAnimationBlock:(BHTKeyboardFrameAnimationBlock)hideBlock
{
    [self bht_setWillHideAnimationBlock:hideBlock];
}

- (void)setKeyboardDidShowActionBlock:(BHTKeyboardFrameAnimationBlock)didShowBlock
{
    [self bht_setDidShowActionBlock:didShowBlock];
}

- (void)setKeyboardDidHideActionBlock:(BHTKeyboardFrameAnimationBlock)didHideBlock
{
    [self bht_setDidHideActionBlock:didHideBlock];
}

#pragma mark - registering notifications

// TODO: make secure (unregister/register) when changing blocks during VC lifetime

- (void)bht_registerForKeyboardNotifications
{
    BHTKeyboardFrameAnimationBlock willShowBlock = [self bht_willShowAnimationBlock];
    BHTKeyboardFrameAnimationBlock willHideBlock = [self bht_willHideAnimationBlock];
    
    BHTKeyboardFrameAnimationBlock didShowBlock  = [self bht_didShowActionBlock];
    BHTKeyboardFrameAnimationBlock didHideBlock  = [self bht_didHideActionBlock];
    
    if (willShowBlock)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    if (willHideBlock)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (didShowBlock)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    if (didHideBlock)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bht_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)bht_unregisterForKeyboardNotifications
{
    BHTKeyboardFrameAnimationBlock willShowBlock = [self bht_willShowAnimationBlock];
    BHTKeyboardFrameAnimationBlock willHideBlock = [self bht_willHideAnimationBlock];
    
    BHTKeyboardFrameAnimationBlock didShowBlock  = [self bht_didShowActionBlock];
    BHTKeyboardFrameAnimationBlock didHideBlock  = [self bht_didHideActionBlock];

    if (willShowBlock)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    if (willHideBlock)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (didShowBlock)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    if (didHideBlock)
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
    
    original = class_getInstanceMethod([self class], @selector(viewDidDisappear::));
    swizz = class_getInstanceMethod([self class], @selector(bht_viewDidDisappear:));
    method_exchangeImplementations(original, swizz);
}

- (void)bht_viewDidDisappear:(BOOL)animated
{
    [self bht_unregisterForKeyboardNotifications];
    
    [self bht_viewDidDisappear:animated];
}

@end
