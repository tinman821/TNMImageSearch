//
//  ImageCell.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *percentageLabel;

@end

@implementation ImageCell

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setPercentageVisible:(BOOL)percentageVisible {
    _percentageVisible = percentageVisible;
    self.percentageLabel.hidden = !percentageVisible;
}

- (void)setPercentageComplete:(float)percentageComplete {
    self.percentageLabel.text = [NSString stringWithFormat:@"%@%%", @((int)(percentageComplete * 100))];
}

@end
