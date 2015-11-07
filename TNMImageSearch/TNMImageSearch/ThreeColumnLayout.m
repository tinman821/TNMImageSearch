//
//  ThreeColumnLayout.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "ThreeColumnLayout.h"

@implementation ThreeColumnLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width / 3 - self.minimumInteritemSpacing, self.collectionView.bounds.size.height / 3);
}

@end
