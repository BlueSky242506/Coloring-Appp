//
//  CFLibrariesCollectionViewCell.h
//  Colorfy
//
//  Created by Mac729 on 6/19/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFLibrariesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *artworkNum;
@property (strong, nonatomic) IBOutlet UIView *cellNumberView;


@end
