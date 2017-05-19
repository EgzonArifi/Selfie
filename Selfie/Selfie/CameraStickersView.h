//
//  CameraStickersView.h
//  Selfie
//
//  Created by Egzon Arifi on 5/19/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraStickersView : UIView

@property (strong, nonatomic) IBOutlet CameraStickersView *mainView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stickers;
@end
