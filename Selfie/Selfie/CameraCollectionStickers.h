//
//  CameraCollectionStickers.h
//  Selfie me LDK
//
//  Created by Egzon Arifi on 5/24/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CameraStickerDelegate <NSObject>

@required
- (void)didSelectCameraCollectionSticker:(NSString *)sticker;

@end

@interface CameraCollectionStickers : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id <CameraStickerDelegate> delegate;

@property (strong, nonatomic) IBOutlet CameraCollectionStickers *mainView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stickers;

@end
