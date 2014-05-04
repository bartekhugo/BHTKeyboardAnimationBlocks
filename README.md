BHTKeyboardAnimationBlocks
==========================

UIViewController category making life easier when working with animations on keybard appearing/disappearing. 
Provides a simple block based API to set animations to be performed on each of UIKeyboardNotifications.

Category registers only for those notifications for which there are any blocks set.
Registering for notifications happens on `viewWillAppear:` method call and unregistering on `viewDidDisappear:` method call.

If view controller is already visible when setting blocks It will automatically register for those notification or unregister from them when assigning `nil`.

Installation
==========================

- Add to your podfile:

    pod 'UIViewController-BHTKeyboardAnimationBlocks', '~> 0.0.1'

Usage
==========================

```objc
- (void)setupKeyboardAnimations
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        // block to be performed during keybord appearing
    }];
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        // block to be performed during keybord disappearing
    }];
    
    [self setKeyboardDidShowActionBlock:^(CGRect keyboardFrame){
        // block to be performed when keyboard did appear
    }];
    
    [self setKeyboardDidHideActionBlock:^(CGRect keyboardFrame){
        // block to be performed when keyboard did hide
    }];
}
```
