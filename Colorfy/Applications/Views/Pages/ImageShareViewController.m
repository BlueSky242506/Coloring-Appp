//
//  ImageShareViewController.m
//  Colorfy
//
//  Created by Mac729 on 7/5/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "ImageShareViewController.h"
#import "FilterCollectionViewCell.h"
#import "MBProgressHUD.h"
#import <CoreImage/CoreImage.h>

@interface ImageShareViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    IBOutlet UILabel *pageStatusLbl;
    IBOutlet UIView *doneBtnView;
    IBOutlet UIImageView *editedImageView;
    IBOutlet UIView *imageSharePartView;
    IBOutlet UIView *imageFilterPartView;
    IBOutlet UIButton *lineFilterBlackBtn;
    IBOutlet UIButton *lineFilterWhiteBtn;
    IBOutlet UIButton *lineFilterFillBtn;
    IBOutlet UIButton *vinetteBtn;
    IBOutlet UICollectionView *filterCollectionView;
    NSArray *imageNameList;
    NSArray *imageList;
    UIImage *mergeImageFilter, *mergeImageLines, *mergeImageVignette, *mergeImageLV, *mergeImageLF, *mergeImageVF, *mergeImageLVF;
    UIImage *sourceImage, *backgroundImage, *foregroundImage;
        
    int filterSelectFlag, vignetteSelectFlag, linesSelectFlag;
    MBProgressHUD *progressHUD;
}

@property (strong, nonatomic) CIContext *context;

@end

@implementation ImageShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    doneBtnView.hidden = YES;
    imageSharePartView.hidden = NO;
    imageFilterPartView.hidden = YES;
    pageStatusLbl.text = @"SHARE YOUR ART";
    editedImageView.image = _imgShare;
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.dimBackground = YES;
    [self.view addSubview:progressHUD];
    
    imageNameList = [NSArray arrayWithObjects:@"NO FILTER", @"GRAIN", @"BRUSH", @"JEANS", @"LEATHER", @"WOOL", @"PAPER", @"WOOD", @"BRICK", nil];
    imageList = [NSArray arrayWithObjects:@"NoFilterImage.jpg", @"grainBackImage.jpg", @"brushBackImage.jpg", @"jeanBackImage.jpg", @"leatherBackImage.jpg", @"woolBackImage.jpg", @"paperBackImage.jpg", @"woodBackImage.jpg", @"breakBackImage.jpg", nil];
    sourceImage = self.imgShare;
    if (!_context) _context = [CIContext contextWithOptions:nil];
    filterSelectFlag = 0; linesSelectFlag = 0; vignetteSelectFlag = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Image Merge
-(UIImage*)mergeImage:(UIImage*)image1 image2:(UIImage*)image2{
    
    UIImage *result_image;
    
    float width = editedImageView.frame.size.width;
    float height = editedImageView.frame.size.height;
    
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(newSize);
    
    UIImage *image3 = [self removeBackgroundinImage:image2];
    
    // Use existing opacity as is
    [image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    
    // Apply supplied opacity if applicable
    [image3 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    
    result_image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result_image;
}

-(UIImage*)removeBackgroundinImage:(UIImage*)image {
    
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
//        unsigned char alpha = rawData[byteIndex + 3];
        
        if (red == green && green == blue && red == 255) {
            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 0;
        }
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    free(rawData);
    return result;
}

#pragma mark - UIButton Actions

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterDoneBtnClick:(id)sender {
    doneBtnView.hidden = YES;
    pageStatusLbl.text = @"SHARE YOUR ART";
    imageFilterPartView.hidden = YES;
    imageSharePartView.hidden = NO;
}

- (IBAction)addFilterBtnClick:(id)sender {
    doneBtnView.hidden = NO;
    pageStatusLbl.text = @"ADD FILTER";
    imageSharePartView.hidden = YES;
    imageFilterPartView.hidden = NO;
}

- (IBAction)lineFilterBlackBtnClick:(id)sender {
    linesSelectFlag = 0;
    [commonUtils setRoundedRectBorderButton:lineFilterBlackBtn withBorderWidth:1.0f withBorderColor:[UIColor blackColor] withBorderRadius:0];
    [commonUtils setRoundedRectBorderButton:lineFilterFillBtn withBorderWidth:0.0f withBorderColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] withBorderRadius:0.0];
    [commonUtils setRoundedRectBorderButton:lineFilterWhiteBtn withBorderWidth:0.0f withBorderColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] withBorderRadius:0.0f];
    
    if (filterSelectFlag == 0 && vignetteSelectFlag == 0)
    {
        editedImageView.image = sourceImage;
    } else if (filterSelectFlag == 1 && vignetteSelectFlag == 0)
    {
        mergeImageFilter = [self mergeImage:backgroundImage image2:sourceImage];
        editedImageView.image = mergeImageFilter;
    } else if (filterSelectFlag == 1 && vignetteSelectFlag == 1)
    {
        mergeImageFilter = [self mergeImage:backgroundImage image2:sourceImage];
        mergeImageVF = [self imageVignetteConversion:mergeImageFilter];
        editedImageView.image = mergeImageVF;
    }
}

- (IBAction)lineFilterWhiteBtnClick:(id)sender {
    linesSelectFlag = 1;
    [commonUtils setRoundedRectBorderButton:lineFilterWhiteBtn withBorderWidth:1.0f withBorderColor:[UIColor blackColor] withBorderRadius:0];
    [commonUtils setRoundedRectBorderButton:lineFilterFillBtn withBorderWidth:0.0f withBorderColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] withBorderRadius:0.0];
    [commonUtils setRoundedRectBorderButton:lineFilterBlackBtn withBorderWidth:0.0f withBorderColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] withBorderRadius:0.0f];
    
    
    UIImage *changedImage = [self replaceColorFromBlackToWhite:[UIColor whiteColor] inImage:sourceImage withTolerance:0.2];
    editedImageView.image = changedImage;
    mergeImageLines=changedImage;
    
    if (filterSelectFlag == 0 && vignetteSelectFlag == 0)
    {
        editedImageView.image = changedImage;
    } else if (filterSelectFlag == 1 && vignetteSelectFlag == 0) {
         mergeImageFilter = [self mergeImage:backgroundImage image2:changedImage];
         editedImageView.image = mergeImageFilter;
      
    } else if (filterSelectFlag == 1 && vignetteSelectFlag == 1) {
        
        mergeImageFilter = [self mergeImage:backgroundImage image2:changedImage];
        mergeImageVF = [self imageVignetteConversion:mergeImageFilter];
        editedImageView.image = mergeImageVF;
    }
}

- (IBAction)lineFilterFillBtnClick:(id)sender {
    linesSelectFlag = 1;
    [commonUtils setRoundedRectBorderButton:lineFilterFillBtn withBorderWidth:1.0f withBorderColor:[UIColor blackColor] withBorderRadius:0];
    [commonUtils setRoundedRectBorderButton:lineFilterBlackBtn withBorderWidth:0.0f withBorderColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] withBorderRadius:0.0];
    [commonUtils setRoundedRectBorderButton:lineFilterWhiteBtn withBorderWidth:0.0f withBorderColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] withBorderRadius:0.0f];
    
    UIImage *changedImage1 = [self replaceColorToFill:[UIColor whiteColor] inImage:sourceImage withTolerance:0.1];
    editedImageView.image = changedImage1;
    mergeImageLines=changedImage1;
    
    if (filterSelectFlag == 0 && vignetteSelectFlag == 0)
    {
        editedImageView.image = changedImage1;
    } else if (filterSelectFlag == 1 && vignetteSelectFlag == 0)
    {
        mergeImageFilter = [self mergeImage:backgroundImage image2:changedImage1];
        editedImageView.image = mergeImageFilter;
        
       
    } else if (filterSelectFlag == 1 && vignetteSelectFlag == 1)
    {
        mergeImageFilter = [self mergeImage:backgroundImage image2:changedImage1];
        mergeImageVF = [self imageVignetteConversion:mergeImageFilter];
        editedImageView.image = mergeImageVF;
    }
}

- (IBAction)vinetteBtnClick:(UIButton *)sender {
    if (sender.tag == 2) {
        [vinetteBtn setTitle:@"VINETTE" forState:UIControlStateNormal];
        sender.tag = 1;
        vignetteSelectFlag = 0;
        if (linesSelectFlag == 1 && filterSelectFlag == 1) {
            mergeImageLF = [self mergeImage:backgroundImage image2:mergeImageLines];
            editedImageView.image = mergeImageLF;
        }else if (filterSelectFlag == 1 && linesSelectFlag == 0) {
            editedImageView.image = mergeImageFilter;
        }else if (filterSelectFlag == 0 && linesSelectFlag == 1) {
            editedImageView.image = mergeImageLines;
        }else if (filterSelectFlag == 0 && linesSelectFlag == 0) {
            editedImageView.image = sourceImage;
        }
    }else if (sender.tag == 1){
        [vinetteBtn setTitle:@"Return Back" forState:UIControlStateNormal];
        sender.tag = 2;
        vignetteSelectFlag = 1;
        if (filterSelectFlag == 0 && linesSelectFlag == 0) {
            mergeImageVignette = [self imageVignetteConversion:sourceImage];
            editedImageView.image = mergeImageVignette;
        }else if (filterSelectFlag == 0 && linesSelectFlag == 1) {
            mergeImageLV = [self imageVignetteConversion:mergeImageLines];
            editedImageView.image = mergeImageLV;
        }else if (filterSelectFlag == 1 && linesSelectFlag == 0) {
            mergeImageVF = [self imageVignetteConversion:mergeImageFilter];
            editedImageView.image = mergeImageVF;
        }else if (filterSelectFlag == 1 && linesSelectFlag == 1) {
            mergeImageLVF = [self imageVignetteConversion:mergeImageLF];
            editedImageView.image = mergeImageLVF;
        }
    }
}

-(UIImage *)imageVignetteConversion:(UIImage *)uiImage{
    UIImage *resultImage;
    CIImage *ci_mergeImage = [CIImage imageWithCGImage:uiImage.CGImage];
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:ci_mergeImage forKey:kCIInputImageKey];
    [vignette setValue:@(0.8) forKey:@"inputIntensity"];
    [vignette setValue:@(uiImage.size.width/2-100) forKey:@"inputRadius"];
    resultImage = [self imageFromCIImage:[vignette outputImage]];
    return resultImage;
}

- (UIImage *)imageFromCIImage:(CIImage *)ciImage {
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

-(UIImage*) replaceColorToFill:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance {
    
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char *) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0];
    float g = components[1];
    float b = components[2];
//    float a = components[3]; // not needed
    
    //    r = r * 255.0;
    //    g = g * 255.0;
    //    b = b * 255.0;
    
    r = 0; g = 0; b = 0;
    
//    const float redRange[2] = {
//        MAX(r - (tolerance / 2.0), 0.0),
//        MIN(r + (tolerance / 2.0), 255.0)
//    };
//    
//    const float greenRange[2] = {
//        MAX(g - (tolerance / 2.0), 0.0),
//        MIN(g + (tolerance / 2.0), 255.0)
//    };
//    
//    const float blueRange[2] = {
//        MAX(b - (tolerance / 2.0), 0.0),
//        MIN(b + (tolerance / 2.0), 255.0)
//    };
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
//        unsigned char alpha = rawData[byteIndex + 3];
        
        //        if (((red >= redRange[0]) && (red <= redRange[1])) &&
        //            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
        //            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
        // make the pixel transparent
        //
        
        if (red == green && green == blue && red != 255) {
            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 10;
        }
        
        //        NSLog(@"%d , %d , %d , %d", red, green, blue, alpha);
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

-(UIImage*)replaceColorFromBlackToWhite:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance {
    
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
//    CGColorRef cgColor = [color CGColor];
//    const CGFloat *components = CGColorGetComponents(cgColor);
//    float r = components[0];
//    float g = components[1];
//    float b = components[2];
    
//    r = 0; g = 0; b = 0;
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
//        unsigned char alpha = rawData[byteIndex + 3];
        
        if (red == green && green == blue) {
            rawData[byteIndex] = 255;
            rawData[byteIndex + 1] = 255;
            rawData[byteIndex + 2] = 255;
            rawData[byteIndex + 3] = 0;
        }
        
        byteIndex += 4;
    }
    
    UIImage *result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

// FaceBook login function

- (IBAction)facebookShareBtnClick:(id)sender {    
    if ([[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"]) {
        [self saveImage];
    } else {
        [progressHUD show:YES];
        [appController facebookLogin: self progressView:progressHUD];
        if (appController.currentUserId != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self saveImage];
        }
    }
}

- (void) saveImage {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *imageStr = [commonUtils encodeToBase64String:editedImageView.image byCompressionRatio:0.8];
    NSString *currentUser_id = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"];
    [parameters setObject: currentUser_id forKey:@"user_id"];
    [parameters setObject:self.imageNum forKey:@"imageNum"];
    [parameters setObject:[NSString stringWithFormat:@"%d",1] forKey:@"status"];
    [parameters setObject:imageStr forKey:@"imageStr"];
    
    [[DatabaseController sharedManager] imageSave:parameters onSuccess:^(id json) {
        NSLog(@"Database Data : %@", json);
        NSDictionary *temp = json;
        if ([[temp objectForKey:@"status"] intValue] == 1) {
            [commonUtils showVAlertSimple:@"" body:@"Image saved successfully as public" duration:1.0];
        }
    } onFailure:^(id json) {
        NSLog(@"Database Data1 : %@", json);
        [commonUtils showVAlertSimple:@"Connection error" body:@"please try again later" duration:1.0];
    }];
}


#pragma mark - UICollectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [imageList count];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self->filterCollectionView.collectionViewLayout;
    
    CGFloat availableHeightForCells = CGRectGetHeight(self->filterCollectionView.frame) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - flowLayout.minimumInteritemSpacing * (rowNumber - 1);
    CGFloat cellHeight = availableHeightForCells ;
    flowLayout.itemSize = CGSizeMake(cellHeight, cellHeight);
    
    return flowLayout.itemSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"FilterCollectionViewCell";
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.filterBackgroundImg setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    cell.filterBackgroundImg.image = [UIImage imageNamed:[imageList objectAtIndex:indexPath.item]];
    cell.filterBackgroundImgLbl.text = [imageNameList objectAtIndex:indexPath.item];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    backgroundImage = [UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];

    
           filterSelectFlag = 1;
    
    
    if (linesSelectFlag == 0 && vignetteSelectFlag == 0) {
        mergeImageFilter = [self mergeImage:backgroundImage image2:sourceImage];
        editedImageView.image = mergeImageFilter;
    }else if (linesSelectFlag == 0 && vignetteSelectFlag == 1) {
        if (filterSelectFlag == 0) {
            mergeImageVF = [self mergeImage:backgroundImage image2:mergeImageVignette];
            editedImageView.image = mergeImageVF;
        }else{
            
            mergeImageFilter = [self mergeImage:backgroundImage image2:sourceImage];
            editedImageView.image = mergeImageFilter;
            
            mergeImageVF = [self imageVignetteConversion:mergeImageFilter];
            editedImageView.image = mergeImageVF;
        }
        
    }else if (linesSelectFlag == 1 && vignetteSelectFlag == 0) {
        mergeImageLF = [self mergeImage:backgroundImage image2:mergeImageLines];
        editedImageView.image = mergeImageLF;
    } else if (linesSelectFlag == 1 && vignetteSelectFlag == 1) {
        mergeImageLF = [self mergeImage:backgroundImage image2:mergeImageLines];
        mergeImageVF = [self imageVignetteConversion:mergeImageLF];
        editedImageView.image = mergeImageVF;

    }
    
    filterSelectFlag = 1;
    
}

@end
