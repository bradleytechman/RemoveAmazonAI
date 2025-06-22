#import <UIKit/UIKit.h>
#import <rootless.h>

// Hook ANPDockedTabBarViewController
%hook ANPDockedTabBarViewController
- (void)viewDidLayoutSubviews {
    %orig; // Call original method

    // Access the tab bar
    UITabBar *tabBar = self.tabBarController.tabBar ?: self.tabBar;
    if (tabBar) {
        // Enumerate subviews to hide and disable interaction
        for (UIView *subview in tabBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")] ||
                [subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                subview.hidden = YES; // Hide the subview
                subview.userInteractionEnabled = NO; // Disable user interaction
            }
        }
    }
}
%end

// Fallback: Hook UITabBar globally for Amazon app
%hook UITabBar
- (void)layoutSubviews {
    %orig; // Call original method

    // Apply only in Amazon app
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.amazon.Amazon"]) {
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")] ||
                [subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                subview.hidden = YES; // Hide the subview
                subview.userInteractionEnabled = NO; // Disable user interaction
            }
        }
    }
}
%end