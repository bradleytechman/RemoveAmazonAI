// it's supposed to hide the rufus ai thing on an item but it doesn't and I don't feel like making it work so maybe eventually I will
// kinda shitty code - it kept hiding all the task bar buttons instead of just one so chatgpt did come up with the rightmostbutton thing

#import <UIKit/UIKit.h>
#import <rootless.h>

%hook UITabBar

- (void)layoutSubviews {
    %orig;

    if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.amazon.Amazon"])
        return;

    UIResponder *responder = self;
    UIViewController *vc = nil;

    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)responder;
            break;
        }
        responder = [responder nextResponder];
    }

    if (![vc isKindOfClass:NSClassFromString(@"ANPDockedTabBarViewController")])
        return;

    UIView *rightmostButton = nil;
    CGFloat maxX = -CGFLOAT_MAX;

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGFloat x = CGRectGetMinX(subview.frame);
            if (x > maxX) {
                maxX = x;
                rightmostButton = subview;
            }
        }
    }

    if (rightmostButton) {
        rightmostButton.hidden = YES;
        rightmostButton.userInteractionEnabled = NO;
    }

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            if (CGRectGetMinX(subview.frame) >= maxX - 10) {
                subview.hidden = YES;
                subview.userInteractionEnabled = NO;
            }
        }
    }
    Class BottomSheetVC = NSClassFromString(@"AppCXNativeBottomSheetViewController");
    if (BottomSheetVC) {
        for (UIView *subview in self.subviews) {
            UIResponder *responder = subview.nextResponder;
            if ([responder isKindOfClass:BottomSheetVC]) {
                subview.hidden = YES;
                subview.userInteractionEnabled = NO;
            }
        }
    }

    // reflow visible buttons evenly once after hiding done
    NSMutableArray<UIView *> *visibleButtons = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")] && !subview.hidden) {
            [visibleButtons addObject:subview];
        }
    }

    [visibleButtons sortUsingComparator:^NSComparisonResult(UIView *a, UIView *b) {
        CGFloat ax = CGRectGetMinX(a.frame);
        CGFloat bx = CGRectGetMinX(b.frame);
        if (ax < bx) return NSOrderedAscending;
        else if (ax > bx) return NSOrderedDescending;
        else return NSOrderedSame;
    }];

    NSUInteger count = visibleButtons.count;
    if (count == 0) return;

    CGFloat totalWidth = CGRectGetWidth(self.bounds);
    CGFloat buttonWidth = totalWidth / count;
    CGFloat buttonHeight = CGRectGetHeight(self.bounds);
    CGFloat y = 0;

    for (NSUInteger i = 0; i < count; i++) {
        UIView *button = visibleButtons[i];
        button.frame = CGRectMake(i * buttonWidth, y, buttonWidth, buttonHeight);
    }
}

%end
