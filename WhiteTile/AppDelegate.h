//
//  AppDelegate.h
//  WhiteTile
//
//  Created by binhnx on 5/6/14.
//  Copyright libreteam 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <CoreLocation/CoreLocation.h>

#define ADMOB_BANNER_UNIT_ID  @"ca-app-pub-9549102114287819/9152795489"

@import GoogleMobileAds;

typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
}CocosBannerType;

#define BANNER_TYPE kBanner_Portrait_Bottom

@interface MyNavigationController : UINavigationController <CCDirectorDelegate>

@end

@interface AppController : NSObject <UIApplicationDelegate, GADInterstitialDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	CCDirectorIOS	*director_;
    
    CocosBannerType mBannerType;
    GADBannerView *mBannerView;
    float on_x, on_y, off_x, off_y;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, retain) UIWindow *window;

@property (readonly) MyNavigationController *navController;

@property (readonly) CCDirectorIOS *director;

@property(nonatomic, strong) GADInterstitial *interstitial;

-(void)hideBannerView;

-(void)showBannerView;

-(void)didShowFullScreenBanner;

@end
