//
//  CameraCollectionStickers.m
//  Selfie me LDK
//
//  Created by Egzon Arifi on 5/24/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "CameraCollectionStickers.h"
#import "CameraCollectionStikcerCell.h"

@implementation CameraCollectionStickers
#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"CameraCollectionStickers"]
                                      owner:self
                                    options:nil];
        self.mainView.frame = self.frame;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"CameraCollectionStikcerCell" bundle: nil]
              forCellWithReuseIdentifier:@"CameraCollectionStikcerCell"];
        
        self.stickers = @[@"Sticker1",@"Sticker2",@"Sticker3",@"Sticker4",@"Sticker5",@"Sticker6",@"Sticker7",@"Sticker8",@"Sticker9"];
        [self addSubview:self.mainView];
        self.collectionView.delegate = self;
        self.self.collectionView.dataSource = self;
    }
    return self;
}
#pragma mark - CollectionView Delegate and Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stickers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CameraCollectionStikcerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CameraCollectionStikcerCell"
                                                                                  forIndexPath:indexPath];
    [cell.sticker setImage:[UIImage imageNamed:self.stickers[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectCameraCollectionSticker:self.stickers[indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/3.4, [UIScreen mainScreen].bounds.size.width/3.4);
}
- (IBAction)closeController:(id)sender {
    [self.delegate didSelectCameraCollectionSticker:@""];
}
@end
