//
//  DetailCategoryViewController.h
//  Colorfy
//
//  Created by Mac729 on 6/23/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCategoryViewController : UIViewController

@property int selectedCategoryIndex;
@property int previousImageNumSum;
@property (nonatomic, strong) NSMutableArray *selectedCategoryImages;
@property (nonatomic, strong) NSString *selectedCategoryName;

@end
