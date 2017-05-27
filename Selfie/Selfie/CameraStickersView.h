//
//  CameraStickersView.h
//  Selfie
//
//  Created by Egzon Arifi on 5/19/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandidateModel.h"

@protocol SelectedStickerDelegate <NSObject>

@required
- (void)didSelectSticker:(NSString *)sticker;

@end

@interface CameraStickersView : UIView

@property (nonatomic, weak) id <SelectedStickerDelegate> delegate;

@property (strong, nonatomic) IBOutlet CameraStickersView *mainView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stickers;
@property (strong, nonatomic) CandidateModel *candidateModel;
- (void)configureList:(CandidateModel *)candidateModel;
@end
