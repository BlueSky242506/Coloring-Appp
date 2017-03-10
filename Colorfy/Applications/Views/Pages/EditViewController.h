//
//  EditViewController.h
//  Colorfy
//
//  Created by Mac729 on 6/24/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;
#import "NEOColorPickerViewController.h"
#import "MyLineDrawingView.h"
#import "DrawingScrillView.h"
#import "PaintToolDialog.h"
#import "MBProgressHUD.h"

@interface EditViewController : UIViewController<UIDocumentInteractionControllerDelegate, NEOColorPickerViewControllerDelegate, MBProgressHUDDelegate>{
    @private MBProgressHUD *progress;
    @public NSString *imgFinalImageName;
}

@property (weak, nonatomic) IBOutlet UIView *recentColorView;
@property (strong, nonatomic)  UIColor *newcolor;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrentTool;
@property(nonatomic,retain)IBOutlet UIImage *imgFinalImage;
@property (strong, nonatomic) IBOutlet UIView *center_row;
@property (nonatomic,retain) IBOutlet UILabel *musicName;
@property (nonatomic,retain) IBOutlet UILabel *playStopLabel;
@property int selectedImageNumber;
@property int fromMyWorkFlag;
@end


