
#import "SVProgressHUD.h"

@interface SVProgressHUD () {
    UIView *loadingView;
    UIImageView *rotateView;
    
    NSTimer *rotatingTimer;
    double angle;
}

@end


@implementation SVProgressHUD

static SVProgressHUD* sharedInstance;

+ (void) showWithStatus:(NSString*)status {
    if (sharedInstance == nil) {
        sharedInstance = [[SVProgressHUD alloc] init];
        [sharedInstance initUI];
    }
    
    [sharedInstance startTimer];
}

+ (void) dismiss {
    [sharedInstance stopTimer];
}

- (void) startTimer {
    loadingView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:loadingView];
    [UIView animateWithDuration:0.3 animations:^{
        loadingView.alpha = 1;
    }];
    
    angle = 0;
    rotatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(rotateCompass) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    [UIView animateWithDuration:0.3 animations:^{
        loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
    }];
    
    [rotatingTimer invalidate];
}

- (void) rotateCompass {
    angle += 20 * M_2_PI;
    rotateView.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
}

- (void) initUI {
    angle = 0;
    loadingView = [[UIView alloc] init];
    loadingView.frame = [UIScreen mainScreen].bounds;
    loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UIImageView *compass = [[UIImageView alloc] init];
    compass.image = [UIImage imageNamed:@"loading_compas.png"];
    compass.frame = CGRectMake(0, 0, 33, 33);
    compass.center = loadingView.center;
    compass.alpha = 0.8;
    [loadingView addSubview:compass];

    rotateView = [[UIImageView alloc] init];
    rotateView.image = [UIImage imageNamed:@"loading_rotate.png"];
    rotateView.frame = CGRectMake(0, 0, 33, 33);
    rotateView.center = loadingView.center;
    [loadingView addSubview:rotateView];
}

@end

