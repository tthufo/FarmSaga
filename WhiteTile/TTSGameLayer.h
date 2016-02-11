//
//  HelloWorldLayer.h
//  WhiteTile
//
//  Created by binhnx on 5/6/14.
//  Copyright libreteam 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"

@import GoogleMobileAds;

@interface TTSGameLayer : CCLayer <GADInterstitialDelegate>//, GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray * arrr,*arr1,*arr2,*arr3,*arr4,*arr5;
    NSMutableArray *collumn;
    CCSprite * mid;
    CCLabelTTF * score,*best;
    BOOL isRunning;
    NSArray *col;
    CCSprite * preview;
}

@property(nonatomic,retain) NSString* isSuperMod;

@property(nonatomic, strong) GADInterstitial *interstitial;

+(CCScene *) scene:(NSString*)superMod;

@end
