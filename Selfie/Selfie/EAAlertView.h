//
//  EAAlertView.h
//  STUcard
//
//  Created by Egzon Arifi on 4/3/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EAAlertView : NSObject

+ (void)showMessage:(NSString*)message withTitle:(NSString *)title onViewController:(UIViewController *)controller;
+ (void)showMessage:(NSString*)message withTitle:(NSString *)title;
+ (void)internetProblemAlert;

@end
