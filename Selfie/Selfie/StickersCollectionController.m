//
//  StickersCollectionController.m
//  Selfie me LDK
//
//  Created by Egzon Arifi on 5/24/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "StickersCollectionController.h"
#import "StickerCollectionViewCell.h"

@interface StickersCollectionController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stickers;
@end

@implementation StickersCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.stickers = @[@"Sticker1",@"Sticker2",@"Sticker3",@"Sticker4",@"Sticker5",@"Sticker6",@"Sticker7",@"Sticker8",@"Sticker9"];
}
#pragma mark - CollectionView Delegate and Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stickers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCollectionViewCell"
                                                                  forIndexPath:indexPath];
    [cell.sticker setImage:[UIImage imageNamed:self.stickers[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectCameraCollectionSticker:self.stickers[indexPath.row]];
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width/3.4, self.collectionView.frame.size.width/3.4);
}
- (IBAction)closeController:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
