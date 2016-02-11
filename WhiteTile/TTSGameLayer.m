//
//  HelloWorldLayer.m
//  WhiteTile
//
//  Created by binhnx on 5/6/14.
//  Copyright libreteam 2014. All rights reserved.
//


// Import the interfaces
#import "TTSGameLayer.h"
#import "TTSMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import <sys/utsname.h>


#define kFirstRow (screenWidth/8)
#define kSecondRow (screenWidth/8 + screenWidth/4)
#define kThirdRow (screenWidth/8 + screenWidth/2)
#define kFourthRow (screenWidth/8 + screenWidth/4 * 3)

#pragma mark - TTSGameLayer

@implementation TTSGameLayer

@synthesize isSuperMod;

+(CCScene *) scene :(NSString*)superMod
{
	// 'scene' is an autorelease object.
    [superMod retain];
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	TTSGameLayer *layer = [TTSGameLayer node];
    [layer initWith:superMod];
	// add layer as a child to scene
	[scene addChild: layer];
    return scene;
}

-(id)initWith:(NSString*)string
{
	if( (self = [super init]))
    {
        if(![[NSUserDefaults standardUserDefaults] valueForKey:@"best1"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"best1"];
        }
        
        if(![[NSUserDefaults standardUserDefaults] valueForKey:@"best2"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"best2"];
        }
        
        if(![[NSUserDefaults standardUserDefaults] valueForKey:@"best3"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"best3"];
        }
        
        isSuperMod = string;
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"rain_drop.png"];
        [self resizeSprite:bg toWidth:size.width toHeight:size.height];
        bg.anchorPoint = CGPointMake(0,0);
        [self addChild:bg];
        
        CCSprite *top = [CCSprite spriteWithFile:@"bar.png"];
        [self resizeSprite:top toWidth:screenWidth toHeight:50];
        top.position = CGPointMake(screenWidth/ 2, size.height - top.contentSize.height/2 + 20);
        [self addChild:top z:1];
        
        arrr = [NSMutableArray new];
        arr1 = [NSMutableArray new];
        arr2 = [NSMutableArray new];
        arr3 = [NSMutableArray new];
        arr4 = [NSMutableArray new];
        arr5 = [NSMutableArray new];
        col = [@[arrr,arr1,arr2,arr3] retain];
        [self setUpView];
        [self didCreateBottomMenu:size];
        [self setUpPointView];
    }
	return self;
}

float k ;
int option;
int ran = 0;
int src = 0;
int t = 0;

- (void)starButtonTapped:(id)sender
{
    [self setStateForSprite:YES];
    src = 0;
    t = 0;
    k = (20 + 2 * (src / 50))/4;
    missing = 0;
    fruit = 0;
    [self unschedule:@selector(setTimeOut)];
    [self unschedule:@selector(didUpdate)];
    for (NSMutableArray *c in col)
    {
        for(CCSprite * sp in c)
        {
            [self removeChild:sp];
        }
        [c removeAllObjects];
    }
    [self setUpView];
    preview.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i_min.png",choice]];
    [score setString:[NSString stringWithFormat:@"Score : %@",@"0"]];
}

-(NSString*)getStarName
{
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"stars" ofType:@"txt"];
    NSString *rawText = [NSString stringWithContentsOfFile:urlString encoding:NSUTF8StringEncoding error:nil];
    NSArray *names = [rawText componentsSeparatedByString:@","];

    return names[[self getRandomNumberBetween:0 maxNumber:[names count ] - 1]];
}

-(CCLabelTTF*)didAddLabel:(CCSprite*)sprite andText:(NSString*)string
{
    NSString * temp = nil;
    float font = 0;
    if([string isEqualToString:@"Game Over"])
    {
        temp = string;
        if([string isEqualToString:@"Wrong Tap"] || [string isEqualToString:@"Missed a Fruit"])
            font = 23;
        else
            font = 30;
    }
    else
    {
        temp = string;
        font = 25;
    }
    CCLabelTTF * label = [[CCLabelTTF alloc] initWithString:temp dimensions:CGSizeMake(0, 0)
        alignment:UITextAlignmentCenter lineBreakMode:kCCLineBreakModeClip
    fontName:@"verdana" fontSize:font];
    label.position = ccp([sprite contentSize].width/2, [sprite contentSize].height/2);
    if([string isEqualToString:@"Game Over"])
    {
        label.color = ccc3(255,255,255);
    }
    else
    {
        label.color = ccRED;
    }
    return  label;
}

int distance ;
int array;

-(void)commit
{
    BOOL choice;
    int velo = 10;
    for(CCSprite * sprite in col[array - 1])
    {
        if(option == 5)
        {
            sprite.position = ccp(sprite.position.x , (int)(sprite.position.y + velo));
            choice = YES;
        }
        else
        {
            if(option == array)
            {
                sprite.position = ccp(sprite.position.x , (int)(sprite.position.y - velo));
                choice = NO;
            }
            else
            {
                sprite.position = ccp(sprite.position.x , (int)(sprite.position.y + velo));
                choice = YES;
            }
        }
    }
    if(choice)
    {
        distance -=velo;
        if(distance <= 0)
        {
            [self unschedule:@selector(commit)];
        }
    }
    else
    {
        distance +=velo;
        if(distance >= ([[CCDirector sharedDirector] winSize].height - 100) / 4 + 0 - extra/2)
        {
            [self unschedule:@selector(commit)];
        }
    }
}

-(void)didHidePointDown:(NSTimer*)time
{
    NSDictionary * dict = [time userInfo];
    [((CCSprite*)arr5[[dict[@"id"] intValue]]) runAction:
                       [CCSequence actions:[CCFadeOut actionWithDuration:0.2f], nil]];
}

-(void)didHidePointUp:(NSTimer*)time
{
    NSDictionary * dict = [time userInfo];
    [((CCSprite*)arr4[[dict[@"id"] intValue]]) runAction:
     [CCSequence actions:[CCFadeOut actionWithDuration:0.2f], nil]];
}

-(void)didUpdate
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    switch ([isSuperMod intValue])
    {
        case 0:
            k = 20;
            break;
        case 1:
        case 2:
            k = (20 + 2 * (fruit*10 / 90))/4;
            break;
        default:
            break;
    }
    for(CCSprite * sprite in arrr)
    {
        if(option == 1 || special == 1)
        {
            if(sprite.position.y >= (size.height - 100 + sprite.contentSize.height))
            {
                [sprite removeAllChildren];
                ran = 0;
                ran = [self getRandomNumberBetween:1 maxNumber:4];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    [self didCheckScore];
                    ((CCSprite*)arr4[0]).opacity = 1000;
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointUp:) userInfo:@{@"id":@"0"} repeats:NO];
                }
                if([arrr indexOfObject:sprite] == [arrr count] - 1)
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arrr[0]).position.y - sprite.contentSize.height - 13 - ext - missing);
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arrr[[arrr indexOfObject:sprite] + 1]).position.y - sprite.contentSize.height - 8 - ext - missing);
                }
                if(ran == 1)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }

                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x , (sprite.position.y + k));
        }
        else
        {
            if(sprite.position.y  <= 50 - sprite.contentSize.height/2 + 24)
            {
                if([isSuperMod intValue] == 0)
                {
                    [self unschedule:@selector(didUpdate)];
                    isRunning = NO;
                }
                [sprite removeAllChildren];
                ran = 0;
                ran = [self getRandomNumberBetween:1 maxNumber:4];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    if([isSuperMod intValue] != 0)
                    {
                       [self didCheckScore];
                       ((CCSprite*)arr5[0]).opacity = 1000;
                       [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointDown:) userInfo:@{@"id":@"0"} repeats:NO];
                    }
                }
                if([arrr indexOfObject:sprite] == 0)
                {
                    if([isSuperMod intValue] == 0)
                    {
                        sprite.position = ccp(sprite.position.x, ((CCSprite*)arrr[[arrr count] - 1]).position.y + sprite.contentSize.height - 5 + ext + missing);
                    }
                    else
                    {
                        sprite.position = ccp(sprite.position.x, ((CCSprite*)arrr[[arrr count] - 1]).position.y + sprite.contentSize.height + 8 + ext + missing);
                    }
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arrr[[arrr indexOfObject:sprite] - 1]).position.y + sprite.contentSize.height + 13 + ext + missing);
                }
                if(ran == 1)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }
                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x ,(sprite.position.y - k));
        }
    }
    
    for(CCSprite * sprite in arr1)
    {
        if(option == 2 || special ==2)
        {
            if(sprite.position.y >= (size.height - 100 + sprite.contentSize.height))
            {
                [sprite removeAllChildren];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    array = 2;
                    [self didCheckScore];
                    ((CCSprite*)arr4[1]).opacity = 1000;
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointUp:) userInfo:@{@"id":@"1"} repeats:NO];
                }
                if([arr1 indexOfObject:sprite] == [arr1 count]- 1)
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr1[0]).position.y - sprite.contentSize.height - 13 - ext - missing);
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr1[[arr1 indexOfObject:sprite] + 1]).position.y - sprite.contentSize.height - 8 - ext - missing);
                }
                if(ran == 2)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }
                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x , sprite.position.y + k);
        }
        else
        {
            if(sprite.position.y  <= 50 - sprite.contentSize.height/2 + 24)
            {
                [sprite removeAllChildren];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    array = 2;
                    if([isSuperMod intValue] != 0)
                    {
                        [self didCheckScore];
                        ((CCSprite*)arr5[1]).opacity = 1000;
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointDown:) userInfo:@{@"id":@"1"} repeats:NO];
                    }
                }
                if([arr1 indexOfObject:sprite] == 0)
                {
                    if([isSuperMod intValue] == 0)
                    {
                        sprite.position = ccp(sprite.position.x, ((CCSprite*)arr1[[arr1 count] - 1]).position.y + sprite.contentSize.height - 5 + ext + missing);
                    }
                    else
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr1[[arr1 count]- 1]).position.y + sprite.contentSize.height + 8 + ext + missing);
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr1[[arr1 indexOfObject:sprite] - 1]).position.y + sprite.contentSize.height + 13 + ext + missing);
                }
                if(ran == 2)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }
                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x , sprite.position.y - k);
        }
    }
    
    for(CCSprite * sprite in arr3)
    {
        if(option == 4 || special ==4)
        {
            if(sprite.position.y >= (size.height - 100 + sprite.contentSize.height))
            {
                [sprite removeAllChildren];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    array = 4;
                    [self didCheckScore];
                    ((CCSprite*)arr4[3]).opacity = 1000;
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointUp:) userInfo:@{@"id":@"3"} repeats:NO];
                }
                if([arr3 indexOfObject:sprite] == [arr3 count] - 1)
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr3[0]).position.y - sprite.contentSize.height - 13 - ext - missing);
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr3[[arr3 indexOfObject:sprite] + 1]).position.y - sprite.contentSize.height - 8 - ext - missing);
                }
                if(ran == 4)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }
                
                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x , (sprite.position.y + k));
        }
        else
        {
            if(sprite.position.y  <= 50 - sprite.contentSize.height/2 + 24)
            {
                [sprite removeAllChildren];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    array = 4;
                    if([isSuperMod intValue] != 0)
                    {
                        [self didCheckScore];
                        ((CCSprite*)arr5[3]).opacity = 1000;
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointDown:) userInfo:@{@"id":@"3"} repeats:NO];
                    }
                }
                if([arr3 indexOfObject:sprite] == 0)
                {
                    if([isSuperMod intValue] == 0)
                    {
                        sprite.position = ccp(sprite.position.x, ((CCSprite*)arr3[[arr3 count] - 1]).position.y + sprite.contentSize.height - 5 + ext + missing);
                    }
                    else
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr3[[arr3 count] - 1]).position.y + sprite.contentSize.height + 8 + ext + missing);
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr3[[arr3 indexOfObject:sprite] - 1]).position.y + sprite.contentSize.height + 13 + ext + missing);
                }
                if(ran == 4)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }
                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x ,(sprite.position.y - k));
        }
    }

    
    for(CCSprite * sprite in arr2)
    {
        if(option == 3 || special ==3)
        {
            if(sprite.position.y >= (size.height - 100 + sprite.contentSize.height))
            {
                [sprite removeAllChildren];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    array = 3;
                    [self didCheckScore];
                    ((CCSprite*)arr4[2]).opacity = 1000;
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointUp:) userInfo:@{@"id":@"2"} repeats:NO];
                }
                if([arr2 indexOfObject:sprite] == [arr2 count]- 1)
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr2[0]).position.y - sprite.contentSize.height - 13 - ext - missing);
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr2[[arr2 indexOfObject:sprite] + 1]).position.y - sprite.contentSize.height - 8 - ext - missing);
                }
                if(ran == 3)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }
                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x , sprite.position.y + k);
        }
        else
        {
            if(sprite.position.y  <= 50 - sprite.contentSize.height/2 + 24)
            {
                [sprite removeAllChildren];
                if(sprite.tag == 0 && sprite.isAccessibilityElement)
                {
                    array = 3;
                    if([isSuperMod intValue] != 0)
                    {
                        [self didCheckScore];
                        ((CCSprite*)arr5[2]).opacity = 1000;
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(didHidePointDown:) userInfo:@{@"id":@"2"} repeats:NO];
                    }
                }
                if([arr2 indexOfObject:sprite] == 0)
                {
                    if([isSuperMod intValue] == 0)
                    {
                        sprite.position = ccp(sprite.position.x, ((CCSprite*)arr2[[arr2 count] - 1]).position.y + sprite.contentSize.height - 5 + ext + missing);
                    }
                    else
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr2[[arr2 count]- 1]).position.y + sprite.contentSize.height + 8 + ext + missing);
                }
                else
                {
                    sprite.position = ccp(sprite.position.x, ((CCSprite*)arr2[[arr2 indexOfObject:sprite] - 1]).position.y + sprite.contentSize.height + 13 + ext + missing);
                }
                if(ran == 3)
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]];
                    sprite.tag = 0;
                }
                else
                {
                    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]];
                    sprite.tag = 1;
                }
                [sprite setIsAccessibilityElement:YES];
            }
            sprite.position = ccp(sprite.position.x , sprite.position.y - k);
        }
    }
}

-(void)didCheckScore
{
    src-=10;
    if(src <=0) src = 0;
    [score setString:[NSString stringWithFormat:@"Score : %i",src]];
    if(src <= 0)
    {
        [self unschedule:@selector(didUpdate)];
        isRunning = NO;
        [self didCreatePopUpMenu:@"Game Over"];
    }
}

-(void)setUpPointView
{
    CCSprite * p1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    CCSprite * p2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    CCSprite * p3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    CCSprite * p4 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    [arr4 addObject:p1];
    [arr4 addObject:p2];
    [arr4 addObject:p3];
    [arr4 addObject:p4];
    for(CCSprite * sprite in arr4)
    {
        sprite.position = ccp(screenWidth/8 + screenWidth/4 * [arr4 indexOfObject:sprite],[[CCDirector sharedDirector] winSize].height - 60);
        sprite.opacity = 0;
        [self resizeSprite:sprite toWidth:[[CCDirector sharedDirector] winSize].width / 6 toHeight:[[CCDirector sharedDirector] winSize].width / 6];
        [self addChild:sprite z:10];
    }
    CCSprite * p5 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    CCSprite * p6 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    CCSprite * p7 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    CCSprite * p8 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"]];
    [arr5 addObject:p5];
    [arr5 addObject:p6];
    [arr5 addObject:p7];
    [arr5 addObject:p8];
    for(CCSprite * sprite in arr5)
    {
        sprite.position = ccp(screenWidth/8 + screenWidth/4 * [arr5 indexOfObject:sprite], 60);
        sprite.opacity = 0;
        [self resizeSprite:sprite toWidth:[[CCDirector sharedDirector] winSize].width / 6 toHeight:[[CCDirector sharedDirector] winSize].width / 6];
        [self addChild:sprite z:10];
    }
}

int extra,fruit;
int ext,choice,special;
float missing;

-(void)setUpView
{
    src = 0;
    k = (20 + 2 * (src / 50))/4;
    missing = 0;
    fruit = 0;
    isRunning = NO;
    CGSize size = [[CCDirector sharedDirector] winSize];
    choice = [self getRandomNumberBetween:1 maxNumber:25];
    switch ([isSuperMod intValue])
    {
        case 0:
            option = 5;
            special = 5;
            break;
        case 1:
            option = 5;
            special = 5;
            break;
        case 2:
            if([self getRandomNumberBetween:1 maxNumber:2] == 1)
            {
                option = [self getRandomNumberBetween:1 maxNumber:4];
            }
            else
            {
                option = [self getRandomNumberBetween:1 maxNumber:4];
                special = [self getRandomNumberBetween:1 maxNumber:4];
            }
            break;
        default:
            break;
    }
    if([self IS_IPHONE_6_PLUS])
    {
        extra = - 30;
        ext = - 41;
    }
    else
    {
        if(size.height > 480)
        {
            extra = 14;
            ext = 2;
        }
        else
        {
            extra = -4;
            ext = -16;
        }
    }
    mid = [CCSprite spriteWithFile:@"bar.png"];
    mid.opacity = 0;
    [self resizeSprite:mid toWidth:screenWidth toHeight:(size.height - 100)/5*5];
    mid.position = CGPointMake(screenWidth/2, (size.height - 100)/2 + 145 + ext);
    if([isSuperMod intValue] == 0)
    {
        [self addChild:mid];
    }
    
    for(int i = 0; i< 7; i++)
    {
        switch ([self getRandomNumberBetween:1 maxNumber:4])
        {
            case 1:
            {
            CCSprite * sprite = [CCSprite new];
                if(option == 5)
                {
                   sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                   sprite.tag = 0;
                }
                else
                {
                    if(i > 1 && i <3)
                    {
                        sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                        sprite.tag = 0;
                    }
                    else
                    {
                        sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                        sprite.tag = 1;
                    }
                }
                [self resizeSprite:sprite toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 1 || special ==1)
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, (50 + sprite.contentSize.height/2 - sprite.contentSize.height) - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, 50 + sprite.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }
                [sprite setIsAccessibilityElement:YES];
                [arrr addObject:sprite];
                [self addChild:sprite];
                
                CCSprite *sprite1 = [CCSprite new];
                sprite1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite1.tag = 1;
                [self resizeSprite:sprite1 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 2|| special == 2)
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 - sprite1.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                [sprite1 setIsAccessibilityElement:YES];
                [arr1 addObject:sprite1];
                [self addChild:sprite1];

                CCSprite *sprite2 = [CCSprite new];
                sprite2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite2.tag = 1;
                [self resizeSprite:sprite2 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 3|| special ==3)
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 - sprite2.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                [sprite2 setIsAccessibilityElement:YES];
                [arr2 addObject:sprite2];
                [self addChild:sprite2];
                
                CCSprite *sprite3 = [CCSprite new];
                sprite3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite3.tag = 1;
                [self resizeSprite:sprite3 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 4|| special == 4)
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 - sprite3.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                [sprite3 setIsAccessibilityElement:YES];
                [arr3 addObject:sprite3];
                [self addChild:sprite3];
            }
                break;
            case 2:
            {
                CCSprite *sprite = [CCSprite new];
                sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite.tag = 1;
                [self resizeSprite:sprite toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 1 || special ==1)
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, 50 + sprite.contentSize.height/2 - sprite.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, 50 + sprite.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }

                [sprite setIsAccessibilityElement:YES];
                [arrr addObject:sprite];
                [self addChild:sprite];
                
                CCSprite *sprite1 = [CCSprite new];
                if(option == 5)
                {
                    sprite1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                    sprite1.tag = 0;
                }
                else
                {
                    if(i > 1 && i < 3)
                    {
                        sprite1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                        sprite1.tag = 0;
                    }
                    else
                    {
                        sprite1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                        sprite1.tag = 1;
                    }
                }
                [self resizeSprite:sprite1 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 2 || special ==2)
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 - sprite1.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                [sprite1 setIsAccessibilityElement:YES];
                [arr1 addObject:sprite1];
                [self addChild:sprite1];
                
                CCSprite *sprite2 = [CCSprite new];
                sprite2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite2.tag = 1;
                [self resizeSprite:sprite2 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 3 || special ==3)
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 - sprite2.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                [sprite2 setIsAccessibilityElement:YES];
                [arr2 addObject:sprite2];
                [self addChild:sprite2];
                
                CCSprite *sprite3 = [CCSprite new];
                sprite3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite3.tag = 1;
                [self resizeSprite:sprite3 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 4 || special ==4)
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 - sprite3.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                [sprite3 setIsAccessibilityElement:YES];
                [arr3 addObject:sprite3];
                [self addChild:sprite3];
            }
                break;
            case 3:
            {
                CCSprite * sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite.tag = 1;
                [self resizeSprite:sprite toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 1 || special ==1)
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, 50 + sprite.contentSize.height/2 - sprite.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, 50 + sprite.contentSize.height/2 + extra /2);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }
                [sprite setIsAccessibilityElement:YES];
                
                [arrr addObject:sprite];
                [self addChild:sprite];
                
                CCSprite *sprite1 = [CCSprite new];
                sprite1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite1.tag = 1;
                [self resizeSprite:sprite1 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 2 || special ==2)
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 - sprite1.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                [sprite1 setIsAccessibilityElement:YES];
                
                [arr1 addObject:sprite1];
                [self addChild:sprite1];
                
                CCSprite *sprite2 = [CCSprite new];
                if(option == 5)
                {
                    sprite2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                    sprite2.tag = 0;
                }
                else
                {
                    if(i > 1 && i < 3)
                    {
                        sprite2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                        sprite2.tag = 0;
                    }
                    else
                    {
                        sprite2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                        sprite2.tag = 1;
                    }
                }
                [self resizeSprite:sprite2 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 3 || special ==3)
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 - sprite2.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                [sprite2 setIsAccessibilityElement:YES];
                [arr2 addObject:sprite2];
                [self addChild:sprite2];
                
                CCSprite *sprite3 = [CCSprite new];
                sprite3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite3.tag = 1;
                [self resizeSprite:sprite3 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 4 || special ==4)
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 - sprite3.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                [sprite3 setIsAccessibilityElement:YES];
                [arr3 addObject:sprite3];
                [self addChild:sprite3];
            }
            break;
            case  4:
            {
                CCSprite * sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite.tag = 1;
                [self resizeSprite:sprite toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 1 || special ==1)
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, 50 + sprite.contentSize.height/2 - sprite.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite.position = ccp(kFirstRow, 50 + sprite.contentSize.height/2 + extra /2);
                    }
                    else
                    {
                        sprite.position = ccp(kFirstRow, ((CCSprite*)arrr[i - 1]).position.y + sprite.contentSize.height + extra);
                    }
                }
                [sprite setIsAccessibilityElement:YES];
                [arrr addObject:sprite];
                [self addChild:sprite];
                
                CCSprite *sprite1 = [CCSprite new];
                sprite1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite1.tag = 1;
                [self resizeSprite:sprite1 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 2 || special ==2)
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 - sprite1.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite1.position = ccp(kSecondRow, 50 + sprite1.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite1.position = ccp(kSecondRow, ((CCSprite*)arr1[i - 1]).position.y + sprite1.contentSize.height + extra);
                    }
                }
                [sprite1 setIsAccessibilityElement:YES];
                
                [arr1 addObject:sprite1];
                [self addChild:sprite1];
                
                CCSprite *sprite2 = [CCSprite new];
                sprite2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                sprite2.tag = 1;
                [self resizeSprite:sprite2 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 3 || special ==3)
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 - sprite2.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite2.position = ccp(kThirdRow, 50 + sprite2.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite2.position = ccp(kThirdRow, ((CCSprite*)arr2[i - 1]).position.y + sprite2.contentSize.height + extra);
                    }
                }
                [sprite2 setIsAccessibilityElement:YES];
                [arr2 addObject:sprite2];
                [self addChild:sprite2];
                
                CCSprite *sprite3 = [CCSprite new];
                if(option == 5)
                {
                    sprite3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                    sprite3.tag = 0;
                }
                else
                {
                    if(i > 1 && i < 3)
                    {
                        sprite3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",choice]]];
                        sprite3.tag = 0;
                    }
                    else
                    {
                        sprite3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%i.png",[self getRandomNumberBetween:1 maxNumber:25 except:choice]]]];
                        sprite3.tag = 1;
                    }
                }
                [self resizeSprite:sprite3 toWidth:size.width/4 toHeight:(size.height - 100)/5];
                if(option == 4 || special ==4)
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 - sprite3.contentSize.height - 10 + extra/2 - ext);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                else
                {
                    if(i == 0)
                    {
                        sprite3.position = ccp(kFourthRow, 50 + sprite3.contentSize.height/2 + extra/2);
                    }
                    else
                    {
                        sprite3.position = ccp(kFourthRow, ((CCSprite*)arr3[i - 1]).position.y + sprite3.contentSize.height + extra);
                    }
                }
                [sprite3 setIsAccessibilityElement:YES];
                [arr3 addObject:sprite3];
                [self addChild:sprite3];
            }
                break;
            default:
                break;
        }
    }
    [self setStateForSprite:YES];

}

-(void)didCreateBottomMenu:(CGSize)size
{
    CCSprite *bottom = [CCSprite spriteWithFile:@"bar.png"];
    [self resizeSprite:bottom toWidth:screenWidth toHeight:50];
    bottom.position = CGPointMake(screenWidth/ 2, 50 / 2);
    [self addChild:bottom z:1];
    
    CCSprite * bestScore = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i.png",choice] rect:CGRectMake(0, 0, 192, 32)];
    bestScore.position = CGPointMake(size.width/4, bottom.contentSize.height / 2);
    [self resizeSprite:bestScore toWidth:192 * 0.6 toHeight:32];
    //[bottom addChild:bestScore];
    
    preview = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i_min.png",choice]];
    [self resizeSprite:preview toWidth:40 toHeight:50];
    preview.position = CGPointMake(screenWidth/8 - 10, bottom.contentSize.height/2);
    [bottom addChild:preview];
    
    score = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Score : %@",@"0"] dimensions:CGSizeMake(screenWidth /2, [bottom contentSize].height * 1)
                                     alignment:UITextAlignmentCenter fontName:@"verdana" fontSize:24.0f];
    score.verticalAlignment = kCCVerticalTextAlignmentCenter;
    score.position = ccp(screenWidth *2/3, bottom.contentSize.height /2);
    score.color = ccc3(255,255,255);
    [bottom addChild:score];
    
    best = [[CCLabelTTF alloc] initWithString:@"0" dimensions:CGSizeMake(100, [bottom contentSize].height)
                                         alignment:UITextAlignmentCenter fontName:@"verdana" fontSize:24.0f];
    best.position = ccp(screenWidth * 0.3, bottom.contentSize.height /2);
    best.verticalAlignment = kCCVerticalTextAlignmentCenter;
    best.color = ccc3(255,255,255);
    [bottom addChild:best];
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


-(void)didCreatePopUpMenu:(NSString*)string
{
    [self setStateForSprite:NO];
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite * menu = [CCSprite spriteWithFile:@"bg_2.png" rect:CGRectMake(0, 0, size.width/1.5,size.height/2)];
    [self resizeSprite:menu toWidth:size.width/1.2 toHeight:size.height/1.5];
    menu.position = ccp(size.width/2,size.height/2);
    
    CCMenuItem *starMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"button_Retry.png" selectedImage:@"button_Retry.png"
                                target:self selector:@selector(didPressRetry)];
    CCMenuItem *starMenuItem2 = [CCMenuItemImage
                                 itemFromNormalImage:@"button_menu.png" selectedImage:@"button_menu.png"
                                 target:self selector:@selector(didPressMenu)];
    CCMenu * optmenu = [CCMenu menuWithItems:starMenuItem,starMenuItem2, nil];
    [optmenu alignItemsVertically];
    optmenu.position = ccp(menu.contentSize.width/2,menu.contentSize.height/4);
    
    [menu addChild:optmenu];
    
    CCSprite * point = [CCSprite spriteWithFile:@"point_gameover.png" rect:CGRectMake(0, 0, 192,32)];
    [self resizeSprite:point toWidth:menu.contentSize.width * 0.8 toHeight:menu.contentSize.height * 0.1];
    point.position = ccp(menu.contentSize.width / 2,menu.contentSize.height / 1.3);
    
    CCSprite * wrong = [CCSprite spriteWithFile:@"point_gameover.png" rect:CGRectMake(0, 0, 192,32)];
    [self resizeSprite:wrong toWidth:menu.contentSize.width * 0.8 toHeight:menu.contentSize.height * 0.1];
    wrong.position = ccp(menu.contentSize.width / 2,menu.contentSize.height / 1.8);

    
    CCLabelTTF * over = [self didAddLabel:menu andText:@"Game Over"];
    over.position = ccp(size.width/4 + 25, menu.position.y * 0.9);
    over.dimensions = CGSizeMake(menu.contentSize.width, 50);
    [menu addChild:over];
    [self addChild:menu z:10 tag:999];
    
    switch ([isSuperMod intValue]) {
        case 0:
        {
            [wrong addChild:[self didAddLabel:point andText:[NSString stringWithFormat:@"Best : %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"best1"]]]];
            [point addChild:[self didAddLabel:point andText:[NSString stringWithFormat:@"Point : %@",[[score string] componentsSeparatedByString:@":"][1]]]];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"best1"] intValue] < [[[score string] componentsSeparatedByString:@":"][1] intValue])
            {
                [[NSUserDefaults standardUserDefaults] setValue:[[score string] componentsSeparatedByString:@":"][1] forKey:@"best1"];
            }
        }
            break;
        case 1:
        {
            [wrong addChild:[self didAddLabel:point andText:[NSString stringWithFormat:@"Best : %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"best2"]]]];
            [point addChild:[self didAddLabel:point andText:[NSString stringWithFormat:@"Point : %i",fruit * 10]]];

            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"best2"] intValue] < (fruit * 10))
            {
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i",fruit * 10] forKey:@"best2"];
            }
        }
            break;
        case 2:
        {
            [wrong addChild:[self didAddLabel:point andText:[NSString stringWithFormat:@"Best : %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"best3"]]]];
            [point addChild:[self didAddLabel:point andText:[NSString stringWithFormat:@"Point : %i",fruit* 10]]];

            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"best3"] intValue] < (fruit * 10))
            {
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i",fruit * 10] forKey:@"best3"];
            }
        }
            break;
        default:
            break;
    }
    [menu addChild:point];
    [menu addChild:wrong];
}

-(void)didPressRetry
{
    [self starButtonTapped:self];
    fruit = 0;
    [best setString:[NSString stringWithFormat:@"%i",fruit]];
    [self removeChildByTag:999];
}

-(void)didPressMenu
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TTSMenuLayer scene]]];
}

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height
{
    [sprite.texture setAliasTexParameters];
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace: touch];
    if([isSuperMod intValue] == 0)
    {
        if (CGRectContainsPoint(mid.boundingBox, location))
        {
            return  NO;
        }
    }
    for (NSArray *c in col)
    {
        for (CCSprite *station in c)
        {
            if (CGRectContainsPoint(station.boundingBox, location))
            {
                if(station.tag == 0 && station.isAccessibilityElement)
                {
                    switch ([isSuperMod intValue]) {
                        case 0:
                            missing = 20;
                            if(!isRunning)
                            {
                                [self schedule:@selector(didUpdate) interval:0.01];
                            }
                            isRunning = YES;
                            break;
                        case 1:
                        case 2:
                            if(!isRunning)
                            {
                                [self schedule:@selector(didUpdate) interval:0.01];
                            }
                            isRunning = YES;
                            t++;
                            if(t % 5 ==0)
                            {
                                //k+=0.1;
                                missing+= 0.2;
                            }
                            break;
                        default:
                            break;
                    }
                    [self didTapStar:station isWrong:NO];
                    src += 10;
                    [station setIsAccessibilityElement:NO];
                    [score setString:[NSString stringWithFormat:@"Score : %i",src]];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
                    fruit+=1;
                    [best setString:[NSString stringWithFormat:@"%i",fruit]];
                    return YES;
                }
                else if(!station.isAccessibilityElement)
                {
                    return YES;
                }
                else if(station.tag == 1)
                {
                    NSLog(@"Game Over");
                    if([isSuperMod intValue] == 0)
                    {
                        [self pauseSchedulerAndActions];
                        [self didCreatePopUpMenu:@"Game Over"];
                    }
                    else
                    {
                        [self didCheckScore];
                    }
                    [self didTapStar:station isWrong:YES];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"dead.mp3"];
                    return  YES;
                }
            }
        }
    }
    return NO;
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max except:(int)exception
{
    int random = 0;
    do
    {
        random = min + arc4random() % (max - min + 1);
    } while (random == exception);
    return random;
}

- (void) dealloc
{
	[super dealloc];
}

-(void)didTapStar:(CCSprite*)sprite isWrong:(BOOL)wrong
{
    if(!wrong)
         sprite.texture = [[CCTextureCache sharedTextureCache] addImage:@"plus_ten.png"];
    else
        sprite.texture = [[CCTextureCache sharedTextureCache] addImage:@"minus_ten.png"];
}

-(void)glowAt:(CGPoint)position withScale:(CGSize)size withColor:(ccColor3B)color withRotation:(float)rotation withSprite:(CCSprite*)sprite
{
    [sprite stopAllActions];
    sprite.texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"tap%i.png",2]];
    [sprite setOpacity:1.0f];
    [sprite runAction:[CCRepeatForever actionWithAction:
     [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],[CCFadeIn actionWithDuration:0.8f], nil]]];
}

//#pragma mark GameKit delegate
//
//-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
//
//-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}

- (void)onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:9 swallowsTouches:YES];
}

- (void)onExit
{
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
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
