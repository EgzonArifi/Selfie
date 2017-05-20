//
//  EAAlertView.m
//  STUcard
//
//  Created by Egzon Arifi on 4/3/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "EAAlertView.h"

@implementation EAAlertView

+ (void)showMessage:(NSString*)message withTitle:(NSString *)title onViewController:(UIViewController *)controller {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                     }];
    [alert addAction:okAction];
    
    [controller presentViewController:alert animated:YES completion:nil];
}
+ (void)showMessage:(NSString*)message withTitle:(NSString *)title  {
    [self showMessage:message withTitle:title onViewController:[self currentTopViewController]];
}
+ (void)internetProblemAlert {
    [self showMessage:NSLocalizedString(@"Internet Problem", nil) withTitle:@"Error"];
}
+ (UIViewController *)currentTopViewController {
    UIViewController *topVC = [
                               [[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
