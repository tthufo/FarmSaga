//
//  IntroLayer.m
//  WhiteTile
//
//  Created by binhnx on 5/6/14.
//  Copyright libreteam 2014. All rights reserved.
//


#import "TTSMenuLayer.h"
#import "TTSGameLayer.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import <sys/utsname.h>

#pragma mark - TTSMenuLayer

@implementation TTSMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	TTSMenuLayer *layer = [TTSMenuLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init]))
    {
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
			background = [CCSprite spriteWithFile:@"Splashscreen.png"];
            [self resizeSprite:background toWidth:size.width toHeight:size.height];
			background.rotation = 0;
		}
        else
        {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
		[self addChild: background];
        [self didCreateMenu:size];
        [self didChangeBackGround:background];
        
        arrr = [NSMutableArray new];
        arr1 = [NSMutableArray new];
        arr2 = [NSMutableArray new];
        arr3 = [NSMutableArray new];
        col = [@[arrr,arr1,arr2,arr3] retain];
                
        if([self IS_IPHONE_6_PLUS])
        {
            extra = - 33;
        }
        else
        {
            if(size.height > 480)
            {
                extra = 22;
            }
            else
            {
                extra = -8;
            }
        }
        [self setUpView];
	}
	
	return self;
}

int extra;

-(void)didChangeBackGround:(CCSprite*)sprite
{
    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:@"bg2.png"];
}

NSMutableArray * menuAr;

-(void)didCreateMenu:(CGSize)size
{
    menuAr = [NSMutableArray new];
    CCSprite * menu = [CCSprite spriteWithFile:@"bg_2.png" rect:CGRectMake(0, 0, size.width/1.5,size.height/2)];
    [self resizeSprite:menu toWidth:size.width/1.2 toHeight:size.height/1.5];
    menu.position = ccp(size.width/2,size.height/2);
    
    CCMenuItem *starMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"button_FruitSalad.png" selectedImage:@"button_FruitSalad.png"
                                target:self selector:@selector(didPressMode1)];
    CCMenuItem *starMenuItem2 = [CCMenuItemImage
                                 itemFromNormalImage:@"button_JuicerMode.png" selectedImage:@"button_JuicerMode.png"
                                 target:self selector:@selector(didPressMode2)];
    CCMenuItem *starMenuItem3 = [CCMenuItemImage
                                 itemFromNormalImage:@"button_BlenderMode.png" selectedImage:@"button_BlenderMode.png"
                                 target:self selector:@selector(didPressMode3)];
    CCMenu * optmenu = [CCMenu menuWithItems:starMenuItem,starMenuItem2, starMenuItem3, nil];
    [optmenu alignItemsVertically];
    optmenu.position = ccp(menu.contentSize.width/2,menu.contentSize.height/2);
    [menu addChild:optmenu];
    [self addChild:menu z:10];
}

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height
{
    [sprite.texture setAliasTexParameters];
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}

-(void)didPressMode1
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TTSGameLayer scene:@"0"]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
}

-(void)didPressMode2
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TTSGameLayer scene:@"1"]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
}

- (void)didPressMode3
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TTSGameLayer scene:@"2"]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

-(void)setUpView
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    for(int i = 0; i< 5; i++)
    {
        CCSprite * sprite = [CCSprite new];
        sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25]]]];
        [self resizeSprite:sprite toWidth:size.width/4 toHeight:(size.height - 100)/5];
        if(i == 0)
        {
            sprite.position = ccp(size.width/8, 50 + sprite.contentSize.height/2);
        }
        else
        {
            sprite.position = ccp(size.width/8, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
        }
        [arrr addObject:sprite];
        [self addChild:sprite];
        
        
        CCSprite *sprite1 = [CCSprite new];
        sprite1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25]]]];
        [self resizeSprite:sprite1 toWidth:size.width/4 toHeight:(size.height - 100)/5];
        if(i == 0)
        {
            sprite1.position = ccp(size.width/8 + sprite1.contentSize.height , 50 + sprite1.contentSize.height/2);
        }
        else
        {
            sprite1.position = ccp(size.width/8 + sprite1.contentSize.height, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height+ extra);
        }
        [arr1 addObject:sprite1];
        [self addChild:sprite1];
        
        
        CCSprite *sprite2 = [CCSprite new];
        sprite2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25]]]];
        [self resizeSprite:sprite2 toWidth:size.width/4 toHeight:(size.height - 100)/5];
        if(i == 0)
        {
            sprite2.position = ccp(size.width/8 + sprite1.contentSize.height * 2, 50 + sprite2.contentSize.height/2);
        }
        else
        {
            sprite2.position = ccp(size.width/8 + sprite1.contentSize.height * 2, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height+ extra);
        }
        [arr2 addObject:sprite2];
        [self addChild:sprite2];
        
        
        CCSprite *sprite3 = [CCSprite new];
        sprite3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25]]]];
        [self resizeSprite:sprite3 toWidth:size.width/4 toHeight:(size.height - 100)/5];
        if(i == 0)
        {
            sprite3.position = ccp(size.width/8 + sprite3.contentSize.height * 3, 50 + sprite3.contentSize.height/2);
        }
        else
        {
            sprite3.position = ccp(size.width/8 + sprite3.contentSize.height * 3, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height+ extra);
        }
        [arr3 addObject:sprite3];
        [self addChild:sprite3];
    }
    [self setStateForSprite:NO];
}

-(void)setStateForSprite:(BOOL)enable
{
    for (NSArray *c in col)
    {
        for(CCSprite * sprite in c)
        {
            sprite.isAccessibilityElement = enable;
        }
    }
}

- (void)onEnter
{
    [super onEnter];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(showBannerView)];
}

- (void)onExit
{
    [super onExit];
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(hideBannerView)];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"detail"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"detail"];
    }
    else
    {
        int count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"detail"] intValue] + 1 ;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", count] forKey:@"detail"];
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"detail"] intValue] % 4 == 0)
    {
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(didShowFullScreenBanner)];
    }
}

- (BOOL)IS_IPHONE_6_PLUS
{
    return [[self deviceType] isEqualToString:@"iPhone 6 Plus"] ||  [[self deviceType] isEqualToString:@"iPhone 6S Plus"];
}

- (NSString *)deviceType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *result = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *matches = @{
                              @"i386" : @"32-bit Simulator",
                              @"x86_64" : @"64-bit Simulator",
                              @"iPod1,1" : @"iPod Touch",
                              @"iPod2,1" : @"iPod Touch Second Generation",
                              @"iPod3,1" : @"iPod Touch Third Generation",
                              @"iPod4,1" : @"iPod Touch Fourth Generation",
                              @"iPod5,1" : @"iPod Touch Fifth Generation",
                              @"iPhone1,1" : @"iPhone",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPad1,1" : @"iPad",
                              @"iPad2,1" : @"iPad 2",
                              @"iPad3,1" : @"3rd Generation iPad",
                              @"iPad3,2" : @"iPad 3(GSM+CDMA)",
                              @"iPad3,3" : @"iPad 3(GSM)",
                              @"iPad3,4" : @"iPad 4(WiFi)",
                              @"iPad3,5" : @"iPad 4(GSM)",
                              @"iPad3,6" : @"iPad 4(GSM+CDMA)",
                              @"iPhone3,1" : @"iPhone 4",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPad3,4" : @"4th Generation iPad",
                              @"iPad2,5" : @"iPad Mini",
                              @"iPhone5,1" : @"iPhone 5(GSM)",
                              @"iPhone5,2" : @"iPhone 5(GSM+CDMA)",
                              @"iPhone5,3" : @"iPhone 5C(GSM)",
                              @"iPhone5,4" : @"iPhone 5C(GSM+CDMA)",
                              @"iPhone6,1" : @"iPhone 5S(GSM)",
                              @"iPhone6,2" : @"iPhone 5S(GSM+CDMA)",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6S",
                              @"iPhone8,2" : @"iPhone 6S Plus"
                              };
    
    if (matches[result]) {
        return matches[result];
    } else {
        return result;
    }
}


@end
