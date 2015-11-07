//
//  ImageCell.h
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell

@property (nonatomic, nullable) UIImage *image;
@property (nonatomic) float percentageComplete;
@property (nonatomic) BOOL percentageVisible;

@end
