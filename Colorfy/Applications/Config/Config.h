//
//  Config.m


//#define SERVER_URL @"http://172.16.1.198:8080/colofy/api/"

#define API_KEY @"123456"

//#define API_TEST (SERVER_URL @"test")

//#define API_SIGNUP (SERVER_URL @"user_signup")
//#define API_IMAGE_SAVE (SERVER_URL @"image_save")
//#define API_IMAGE_COMMENT (SERVER_URL @"image_comment")
//#define API_IMAGE_FAVORITE (SERVER_URL @"image_favorite")
//#define API_IMAGES_OWN (SERVER_URL @"own_images")
//#define API_IMAGES_PUBLIC (SERVER_URL @"public_images")

// UICollectionView Cell for row.
#define kCellsPerRow 2
#define rowNumber

// Explore Barks Default Config
#define EXPLORE_BARKS_COUNT_DEFAULT @"100"

// Aviary Config
//#define kAviaryKey @"j8q6p8efaolydstk"
//#define kAviarySecret @"kk4fd7pglcnrgbpd"
#define ADOBE_CLIENT_ID @"05cce7d40c12458bb4f13db89903044c"
#define ADOBE_CLIENT_SECRET @"28e16f52-6acd-4e7a-bdbd-86b0f670d8a4"


// Map View Default Config
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288

#define FONT_GOTHAM_NORMAL(s) [UIFont fontWithName:@"GothamRounded-Book" size:s]
#define FONT_GOTHAM_BOLD(s) [UIFont fontWithName:@"GothamRounded-Bold" size:s]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)

#define DEFAULT_USER_ID 1
