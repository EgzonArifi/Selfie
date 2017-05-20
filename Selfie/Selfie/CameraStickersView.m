//
//  CameraStickersView.m
//  Selfie
//
//  Created by Egzon Arifi on 5/19/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "CameraStickersView.h"
#import "StickerCell.h"

@implementation CameraStickersView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"CameraStickersView"]
                                      owner:self
                                    options:nil];
        self.mainView.frame = self.frame;
        
        UINib *nib = [UINib nibWithNibName:@"StickerCell" bundle: nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"StickerCell"];
        self.stickers = @[@"sticker1",@"sticker2",@"sticker3",@"sticker4"];
        [self addSubview:self.mainView];
    }
    return self;
}

#pragma mark - CollectionView Delegate and Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stickers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell"
                                                                  forIndexPath:indexPath];
    [cell.stickerImageView setImage:[UIImage imageNamed:self.stickers[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.height, self.collectionView.frame.size.height);
 }
@end
