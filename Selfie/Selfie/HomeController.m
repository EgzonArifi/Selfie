//
//  HomeController.m
//  Selfie
//
//  Created by Egzon Arifi on 5/20/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "HomeController.h"
#import "YCameraViewController.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(IBAction)goToStickerCamera:(id)sender {
    [self.navigationController presentViewController:[[YCameraViewController alloc] init]
                                            animated:YES
                                          completion:nil];
}
@end
