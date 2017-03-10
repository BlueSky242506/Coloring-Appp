//
//  EditViewController.m
//  Colorfy
//
//  Created by Mac729 on 6/24/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "EditViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Gloabals.h"

#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPopupBackgroundView.h"
#import <objc/runtime.h>
#import "Reachability.h"
#import "LineDrawingUndoRedoCacha.h"
#import "ImageShareViewController.h"
#import "PuzzleViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface EditViewController() <UIScrollViewDelegate, NEOColorPickerViewControllerDelegate, UIActionSheetDelegate, UITabBarControllerDelegate>{
    
/// Color view & button variables
    NSMutableOrderedSet *_recentUsedColors;
    MyLineDrawingView *drawScreen;
    DrawingScrillView *scrollToZoom;
    UIView *scrollContainer;
    UIImageView *ivFinalImage;
    bool tempIsZoomOn;
    UIPinchGestureRecognizer *imageZoom;
    CGFloat scaleRatio;
    CGFloat imageScale;
    CGFloat initialImageWidth;
    
    IBOutlet UIButton *colorBtn;
    IBOutlet UIView *colorView;
    
/// Music view & button variables
    IBOutlet UIButton *musicBtn;
    IBOutlet UIView *musicView;
    
/// Option view & button variables
    IBOutlet UIButton *optionBtn;
    IBOutlet UIView *optionView;
    
    NSString *imageName;
    
    NSDictionary *tempFB;
    
/// Audio player variables
    AVAudioPlayer *audioPlayer;
    NSArray *audioFileArray;
    int audioRunningIndex;
    IBOutlet UIButton *audioPlayBtn;
    int menuViewKey;
}
@end

int recentColorLimit = 5;

@implementation EditViewController
@synthesize recentColorView;
@synthesize musicName;
@synthesize playStopLabel;

-(BOOL)connected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if (self.imgFinalImage == nil) {
        
       tempIsZoomOn = true;

        imageName = [NSString stringWithFormat:@"%d.jpg",self.selectedImageNumber];
        UIImage *localSavedImage = [self getLocalSavedImage];
        if (localSavedImage == nil) {
            self.imgFinalImage = [UIImage imageNamed:imageName];
        } else {
            self.imgFinalImage = localSavedImage;
        }
        
        menuViewKey = 0;
    } else {
        menuViewKey = 1;
    }
    audioFileArray = @[@"Desert", @"Fire", @"Forest", @"Moutains", @"Rain", @"Sea", @"Sky", @"Summer Rain", @"Water", @"Wind"];
    audioRunningIndex = 0;
    [self performSelector:@selector(callAfterSomeTime) withObject:nil afterDelay:0.5f];
    
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonSelect:(UIButton *)sender {
    UIButton *btnSelect = (UIButton *)sender;
    
    if (self.fromMyWorkFlag == 1) {
        appController.selectedSegmentItem = 1;
        self.fromMyWorkFlag = 0;
    }
    
    if (btnSelect.tag == 0) {              // back view controller
        if (appController.selectedSegmentItem == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if(appController.selectedSegmentItem == 1){
            [self dismissViewControllerAnimated:YES completion:nil];            
        }
    }else if (btnSelect.tag == 1){         // back  action
        //undo
        [drawScreen undoButtonClicked];
        // end undo
    }else if (btnSelect.tag == 2) {        // forward action
        //redo
        [drawScreen redoButtonClicked];
        // end redo
    }else if (btnSelect.tag == 3) {        // color pallete button
        NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
        controller.delegate = self;
        controller.selectedColor = self.newcolor;
        controller.title = @"Color Palette";
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
    }else if (btnSelect.tag == 4) {         // menubar colorBtn
        [colorBtn setSelected:YES];
        [musicBtn setSelected:NO];
        [optionBtn setSelected:NO];
        colorView.hidden = NO;
        musicView.hidden = YES;
        optionView.hidden = YES;
        
    }else if (btnSelect.tag == 5) {         // menubar musicBtn
        [musicBtn setSelected:YES];
        [colorBtn setSelected:NO];
        [optionBtn setSelected:NO];
        musicView.hidden = NO;
        colorView.hidden = YES;
        optionView.hidden = YES;
        
    }else if (btnSelect.tag == 6) {         // menubar optionBtn
        [optionBtn setSelected:YES];
        [musicBtn setSelected:NO];
        [colorBtn setSelected:NO];
        optionView.hidden = NO;
        colorView.hidden = YES;
        musicView.hidden = YES;
        
    }else if (btnSelect.tag == 7) {
        [self saveImage:sender];
    }
}

-(void) callAfterSomeTime {
    [self initDrawing];
    [self loadRecentUsedColors];
    self.newcolor = [_recentUsedColors objectAtIndex:0];
    [self initBottomBarRecentColors];
}

-(void) initDrawing {
    CGFloat width = self.center_row.frame.size.width;
    CGFloat height = self.center_row.frame.size.height;
    CGFloat lengthSide = MIN(width, height);
    
    CGFloat leftStartPoint = self.center_row.frame.size.width / 2 - lengthSide / 2;
    CGFloat topStartPoint = self.center_row.frame.size.height / 2 - lengthSide / 2;
    CGRect rect = CGRectMake(leftStartPoint, topStartPoint, lengthSide, lengthSide);
    CGRect rect1 = CGRectMake(0, 0, lengthSide, lengthSide);
    
    // remove subViews
    [[self.center_row subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    scrollToZoom = nil;
    scrollContainer = nil;
    ivFinalImage = nil;
    
    scrollToZoom = [[DrawingScrillView alloc] initWithFrame:rect];
    scrollContainer = [[UIView alloc] initWithFrame:rect1];
    ivFinalImage = [[UIImageView alloc] initWithFrame:rect1];
    [scrollContainer addSubview:ivFinalImage];
    [scrollToZoom addSubview:scrollContainer];
    [self.center_row addSubview:scrollToZoom];
    
    scrollContainer.tag = 50;
//    self.imgFinalImage = [UIImage imageNamed:imageName];
    ivFinalImage.image = self.imgFinalImage;
    imageScale = lengthSide / ivFinalImage.image.size.height;        //
    ivFinalImage.clipsToBounds = YES;
    ivFinalImage.backgroundColor = [UIColor whiteColor];
    
    // DrawLine
    if(!drawScreen) {
        [self initDrawScreen:rect];
    } else {
        MyLineDrawingView *tempDrawScreen = drawScreen;
        [self initDrawScreen:rect];
        drawScreen->currentColor = tempDrawScreen->currentColor;
        drawScreen->paintTool = tempDrawScreen->paintTool;          //FILL;
        drawScreen->realImage = self.imgFinalImage;
        drawScreen->currentImageView = ivFinalImage;
        drawScreen->isActive = false;//tempDrawScreen->isActive;
        drawScreen->brushSize = tempDrawScreen->brushSize;
    }
    
    scrollToZoom->isZoomOn = tempIsZoomOn;
    scrollToZoom.contentSize = ivFinalImage.image.size;
    CGRect scrollViewFrame = scrollToZoom.frame;
    initialImageWidth = scrollViewFrame.size.width;
    scaleRatio = initialImageWidth / ivFinalImage.frame.size.width;
    
    [scrollToZoom setScrollEnabled:YES];
    scrollToZoom.minimumZoomScale = 1.0f;  // minScale;
    scrollToZoom.maximumZoomScale = 5.0f;
    scrollToZoom.zoomScale = 1.0f;          // minScale;
    scrollToZoom.delegate= self;
    
    [colorBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
    [colorBtn setTitleColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [musicBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected];
    [musicBtn setTitleColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [optionBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateSelected] ;
    [optionBtn setTitleColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (menuViewKey == 0) {
        [colorBtn setSelected:YES];
        [musicBtn setSelected:NO];
        [optionBtn setSelected:NO];
        colorView.hidden = NO;
        musicView.hidden = YES;
        optionView.hidden = YES;
    }else{
        [colorBtn setSelected:NO];
        [musicBtn setSelected:NO];
        [optionBtn setSelected:YES];
        colorView.hidden = YES;
        musicView.hidden = YES;
        optionView.hidden = NO;
    }
}

-(void)initDrawScreen:(CGRect)rect{
    drawScreen = [[MyLineDrawingView alloc] initWithFrame:rect  imageForEraser:self.imgFinalImage];
    [drawScreen setBackgroundColor:[UIColor clearColor]];
    drawScreen->currentColor = self.newcolor;
    drawScreen->paintTool = FILL;       //self.btnCurrentTool.tag;//FILL;
//    drawScreen.tag = 3;
    drawScreen->realImage = self.imgFinalImage;
    drawScreen->currentImageView = ivFinalImage;
    [scrollContainer addSubview:drawScreen];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(void)loadRecentUsedColors {
    NSFileManager *fs = [NSFileManager defaultManager];
    NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"recentColors.data"];
    if ([fs isReadableFileAtPath:filename]) {
        _recentUsedColors = [[NSMutableOrderedSet alloc] initWithOrderedSet:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]];
    } else {
        _recentUsedColors = [[NSMutableOrderedSet alloc] init];
        
        for (int i = 0; i < recentColorLimit; i++) {
            UIColor *color = [UIColor colorWithHue:i / (float)recentColorLimit saturation:1.0 brightness:1.0 alpha:1.0];
            [_recentUsedColors addObject:color];
        }
        [self saveRecentUsedColors];
    }
}

-(void)saveRecentUsedColors {
    NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"recentColors.data"];
    
    [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_recentUsedColors];
    [data writeToFile:filename atomically:YES];
}

//////////////////////////////////////////////////////////////////////
-(void)initBottomBarRecentColors {
    // remove subViews
    [[recentColorView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // remove subLayers
    [recentColorView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGFloat parentWidth = recentColorView.frame.size.width;
    CGFloat parentHeight = recentColorView.frame.size.height - 10;
    int frameWidth = ((int)parentWidth / (int)recentColorLimit);
    CGRect rect;
    
    CGFloat offset = (parentWidth - parentHeight * recentColorLimit) / (recentColorLimit - 1);
    
    for (int i = 0; i < recentColorLimit && i < _recentUsedColors.count; i++) {
        int column = i;
        if(parentWidth > 500) {
            rect = CGRectMake((column * frameWidth) + parentHeight, 0, parentHeight, parentHeight);
        } else {
            rect = CGRectMake((column * parentHeight) + column * offset, 0, parentHeight, parentHeight);
        }
        
        CALayer *layer = [CALayer layer];
        layer.cornerRadius = parentHeight/2;
        UIColor *color = [_recentUsedColors objectAtIndex:i];
        layer.backgroundColor = color.CGColor;
        //[layer setMasksToBounds:YES];
        layer.frame = rect;
        //[layer setBounds:CGRectMake(0.0f, 0.0f, radius *2 radius *2)];
        
        [self setupShadow:layer];
        [self.recentColorView.layer addSublayer:layer];
        
        if([self.newcolor isEqual:color]) {

                NSString *imgName = [NSString stringWithFormat:@"ds_face_01.png"];
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.frame = rect;
                imgView.image = [UIImage imageNamed:imgName];
                [self.recentColorView addSubview: imgView];
            
            if(drawScreen!=nil) {
                drawScreen->currentColor = self.newcolor;
            }
        }
    }
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomRecentColorTaped:)];
    [self.recentColorView addGestureRecognizer:recognizer];
}

-(IBAction)saveImage:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(ivFinalImage.bounds.size, NO, 0);
    [ivFinalImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *finalImage = viewImage;
    imgFinalImageName = appController.selectedCategoryName;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    NSLog(@"%@",fullPath);
    
    NSData* data = UIImagePNGRepresentation(finalImage);
    BOOL isWritten = [data writeToFile:fullPath atomically:YES];
    if(isWritten) {
        [self saveAlert];
    } else {
        NSLog(@"Error failed to save image.");
    }
}

-(UIImage *) getLocalSavedImage {
    UIImage *localSavedImage;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    NSData *imgData = [NSData dataWithContentsOfFile:fullPath];
    localSavedImage = [UIImage imageWithData:imgData];
    return localSavedImage;
}

-(void)saveAlert {
    UIAlertController *alert =  [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:@"Image Saved Successfully"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
}

-(void)dismissAlert:(UIAlertController *)_alert {
    [_alert dismissViewControllerAnimated:YES completion:nil];
}

- (void) setupShadow:(CALayer *)layer {
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    layer.shadowOffset = CGSizeMake(0, 2);
    CGRect rect = layer.frame;
    rect.origin = CGPointZero;
    layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:layer.cornerRadius].CGPath;
}

- (void) bottomRecentColorTaped:(UITapGestureRecognizer *)recognizer {
    
    CGFloat parentWidth = self.recentColorView.frame.size.width;
    int frameWidth = (int)parentWidth / (int)recentColorLimit;
    
    CGPoint point = [recognizer locationInView:self.recentColorView];
    int row = (int)((point.y) / frameWidth);
    int column = (int)((point.x - 8) / frameWidth);
    int index = row * 1 + column;
    
    if (index < _recentUsedColors.count) {
        
        self.newcolor = [_recentUsedColors objectAtIndex:index];
        //drawScreen->curentColor = self.newcolor;
        [self initBottomBarRecentColors];
    }
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void) colorPickerViewDismissedByOutSideClick:(UIColor *)color {
    [self selectedColorByColorPickerView:color];
}

-(void) selectedColorByColorPickerView:(UIColor *)color {
    self.newcolor = color;
    //drawScreen->curentColor = self.newcolor;
    
    [_recentUsedColors removeObject:color];
    if(_recentUsedColors.count == recentColorLimit) {
        [_recentUsedColors removeObjectAtIndex:[_recentUsedColors count]-1];
    }
    
    [_recentUsedColors insertObject:color atIndex:0];
    [self saveRecentUsedColors];
    [self initBottomBarRecentColors];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    
    [self selectedColorByColorPickerView:color];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [drawScreen toucheStart:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [drawScreen toucheMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];

        if ([touches count] == 1)
        {
            if ([[touch view] tag] == 50) {         // scrollContainer = 50
            
                scrollContainer.userInteractionEnabled = false;
                
                if(progress == nil) {
                    progress = [[MBProgressHUD alloc] initWithView:self.view];
                }
                
                [self.view addSubview:progress];
                progress.dimBackground = YES;
                progress.delegate = self;
                [progress show:YES];
                
                CGPoint tpoint = [[[event allTouches] anyObject] locationInView:ivFinalImage];
                
                tpoint.x = tpoint.x * scaleRatio;
                tpoint.y = tpoint.y * scaleRatio;
                
                tpoint = CGPointMake(tpoint.x / imageScale, tpoint.y / imageScale);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    UIImage *filledImage = [drawScreen floodFillAtPoint:tpoint withImage:ivFinalImage.image byColor:self.newcolor];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        ivFinalImage.image = filledImage;
                        LineDrawingUndoRedoCacha *obj = [[LineDrawingUndoRedoCacha alloc] init];
                        obj.color = self.newcolor;
                        obj->tpoint = tpoint;
                        obj->paintTool = FILL;
                        [drawScreen->pathArray addObject:obj];
                
                        [self performSelector:@selector(endFill) withObject:nil afterDelay:0.1f];
                    });
                });
            }
        }
}

-(void)endFill {
    scrollContainer.userInteractionEnabled = true;
    [progress hide:YES];
}

#pragma mark - Audio Play Methods

- (IBAction)audioPlayBtnClick:(id)sender {
    if ([audioPlayer isPlaying]) {
        [audioPlayer pause];
        UIImage *buttonBackgroundImage = [UIImage imageNamed:@"playBtn.png"];
        [audioPlayBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        playStopLabel.text=@"PLAY";
    }else{
        UIImage *buttonBackgroundImage = [UIImage imageNamed:@"pauseBtn.png"];
        [audioPlayBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        NSString *path = [[NSBundle mainBundle] pathForResource:[audioFileArray objectAtIndex:audioRunningIndex] ofType:@"mp3"];
        NSURL *file = [NSURL fileURLWithPath:path];
        playStopLabel.text=@"STOP";
    
        audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [audioPlayer play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:audioPlayer];
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    audioRunningIndex = audioRunningIndex + 1;
    NSString *path = [[NSBundle mainBundle] pathForResource:[audioFileArray objectAtIndex:audioRunningIndex] ofType:@"mp3"];
    NSURL *file = [NSURL fileURLWithPath:path];
    audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    [audioPlayer play];
}

- (IBAction)audioNextPlayBtnClick:(id)sender {
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"pauseBtn.png"];
    [audioPlayBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    playStopLabel.text=@"STOP";
    if ([audioPlayer isPlaying]) [audioPlayer stop];
    audioRunningIndex = audioRunningIndex + 1;
    if (audioRunningIndex == [audioFileArray count]) {
        audioRunningIndex = audioRunningIndex - 1;
        UIAlertController *alert =  [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:@"No next Audio file!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0];
        playStopLabel.text=@"PLAY";
        UIImage *buttonBackgroundImage1 = [UIImage imageNamed:@"playBtn.png"];
        [audioPlayBtn setBackgroundImage:buttonBackgroundImage1 forState:UIControlStateNormal];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[audioFileArray objectAtIndex:audioRunningIndex] ofType:@"mp3"];
        NSURL *file = [NSURL fileURLWithPath:path];
        musicName.text=[audioFileArray objectAtIndex:audioRunningIndex];
        audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [audioPlayer play];
         playStopLabel.text=@"STOP";
    }
}

- (IBAction)audioPreviousPlayBtnClick:(id)sender {
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"pauseBtn.png"];
    [audioPlayBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
   
    if ([audioPlayer isPlaying]) [audioPlayer stop];
    audioRunningIndex = audioRunningIndex - 1;
    if (audioRunningIndex < 0) {
        audioRunningIndex = audioRunningIndex + 1;
        UIAlertController *alert =  [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:@"No previous Audio file!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0];
        playStopLabel.text=@"PLAY";
        UIImage *buttonBackgroundImage1 = [UIImage imageNamed:@"playBtn.png"];
        [audioPlayBtn setBackgroundImage:buttonBackgroundImage1 forState:UIControlStateNormal];

    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:[audioFileArray objectAtIndex:audioRunningIndex] ofType:@"mp3"];
        NSURL *file = [NSURL fileURLWithPath:path];
        musicName.text=[audioFileArray objectAtIndex:audioRunningIndex];
        audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [audioPlayer play];
         playStopLabel.text = @"STOP";
    }
}

- (IBAction)artworkSaveBtnClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save to local", @"Save to database", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)artworkShareBtnClick:(id)sender {
    ImageShareViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageSharePage"];
    panelController.imgShare = ivFinalImage.image;
    panelController.imageNum = [NSString stringWithFormat:@"%d", self.selectedImageNumber];
    [self.navigationController pushViewController:panelController animated:YES];
}

- (IBAction)makePuzzleBtnClick:(id)sender {
    
    UINavigationController *viewContorller = (UINavigationController *)self.navigationController.presentingViewController;
    UITabBarController *viewController1 = (UITabBarController *)viewContorller.topViewController;
    [viewController1 setSelectedIndex:3];
    PuzzleViewController *panelController = (PuzzleViewController *)((UINavigationController *)viewController1.selectedViewController).topViewController;
    panelController.imgShare = ivFinalImage.image;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    scrollView.contentSize = scrollContainer.frame.size;
    return scrollContainer;
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self saveImageLocal];
            break;
        case 1:
            [self saveOwnImageBtnClick];
            break;
        default:
            break;
    }
}

-(void) saveImageLocal {
    UIGraphicsBeginImageContextWithOptions(ivFinalImage.bounds.size, NO, 0);
    [ivFinalImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *finalImage = viewImage;
    imgFinalImageName = appController.selectedCategoryName;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    NSLog(@"%@",fullPath);
    
    NSData* data = UIImagePNGRepresentation(finalImage);
    BOOL isWritten = [data writeToFile:fullPath atomically:YES];
    if(isWritten) {
        [self saveAlert];
    } else {
        NSLog(@"Error failed to save image.");
    }
}

-(void) saveOwnImageBtnClick {
    if ([[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"]) {
        [self saveImageOwn];
    } else {
        [progress show:YES];
        [appController facebookLogin:self progressView:progress];
        if (appController.currentUserId != nil) {
            [progress hide:YES];
            [self saveImageOwn];
        }
    }
}

-(void) dataRefreshFB {
    NSString *fbId = [tempFB objectForKey:@"id"];
    NSString *username = [tempFB objectForKey:@"name"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:fbId forKey:@"facebook_id"];
    [userInfo setObject:username forKey:@"user_name"];
    [commonUtils showActivityIndicator:self.view];
    
    [[DatabaseController sharedManager] userSignUp:userInfo onSuccess:^(id json) {
        NSLog(@"Database Data : %@", json);
        NSDictionary *temp = json;
        [commonUtils hideActivityIndicator];
        NSString *status = [temp objectForKey:@"status"];
        if ([status intValue] == 2) {
            [commonUtils showVAlertSimple:@"You already registered" body:@"" duration:1.0];
            [commonUtils setUserDefaultDic:@"RegisteredUser" withDic:userInfo];
            [self saveImageOwn];
        } else if ([status intValue] == 1) {
            NSDictionary *userInformation = [[temp objectForKey:@"current_user"] objectAtIndex:0];
            NSString *userId = [userInformation objectForKey:@"user_id"];
            appController.currentUserId = userId;
            [commonUtils setUserDefaultDic:@"RegisteredUser" withDic:userInformation];
            [commonUtils showVAlertSimple:@"You registered successfully" body:@"" duration:1.0];
            [self saveImageOwn];
        } else {
            [commonUtils showVAlertSimple:@"Please check your FB account!" body:nil duration:1.0];
        }
    } onFailure:^(id json) {
        NSLog(@"Database Data1 : %@", json);
        [commonUtils showVAlertSimple:@"Connection error" body:@"please try again later" duration:1.0];
    }];
}

-(void)saveImageOwn {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *imageStr = [commonUtils encodeToBase64String:ivFinalImage.image byCompressionRatio:0.8];
    NSString *currentUser_id = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"];
    [parameters setObject: currentUser_id forKey:@"user_id"];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.selectedImageNumber] forKey:@"imageNum"];
    [parameters setObject:[NSString stringWithFormat:@"%d",0] forKey:@"status"];
    [parameters setObject:imageStr forKey:@"imageStr"];
        
    [[DatabaseController sharedManager] imageSave:parameters onSuccess:^(id json) {
        NSLog(@"Database Data : %@", json);
        NSDictionary *temp = json;
        if ([[temp objectForKey:@"status"] intValue] == 1) {
            [commonUtils showVAlertSimple:@"" body:@"Image saved successfully as Own" duration:1.2];
        }
    } onFailure:^(id json) {
        NSLog(@"Database Data1 : %@", json);
        [commonUtils showVAlertSimple:@"Connection error" body:@"please try again later" duration:1.2];
    }];
}

@end