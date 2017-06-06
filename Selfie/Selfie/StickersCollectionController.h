//
//  StickersCollectionController.h
//  Selfie me LDK
//
//  Created by Egzon Arifi on 5/24/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraControllerStickerDelegate <NSObject>

@required
- (void)didSelectCameraCollectionSticker:(NSString *)sticker;

@end

@interface StickersCollectionController : UIViewController

@property (nonatomic, weak) id <CameraControllerStickerDelegate> delegate;

@end
