#import <UIKit/UIKit.h>
#import <rootless.h>


%hook ANPDockedTabBarViewController
- (void)viewDidLayoutSubviews {
    %orig; 

    UITabBar *tabBar = self.tabBarController.tabBar ?: self.tabBar;
    if (tabBar) {
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
    %orig; 

    
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.amazon.Amazon"]) {
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")] ||
                [subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                subview.hidden = YES; 
                subview.userInteractionEnabled = NO; 
            }
        }
    }
}
%end
