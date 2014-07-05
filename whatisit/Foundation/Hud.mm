//
//  Hud.m
//  clearway
//
//  Created by Abhishek Mishra on 6/19/13.
//
//

#import "Hud.h"

@implementation Hud
@synthesize delegate;

-(id)init
{
    if( (self=[super init])){
        [self setupPausebutton];
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setupPausebutton
{
    [CCMenuItemFont setFontSize:44];
    [CCMenuItemFont setFontName:kFontName];
    
    CCMenuItemImage *pause = [CCMenuItemImage itemWithNormalImage:@"hudmenu.png" selectedImage:@"hudmenu.png" block:^(id sender){
        [self pauseGame];
        
    }];
    CCMenuItemImage *replay = [CCMenuItemImage itemWithNormalImage:@"hudmenu.png" selectedImage:@"hudmenu.png" block:^(id sender){
        [self replay];
        
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:pause,replay,nil];
    
    [self addChild: menu];
    [menu alignItemsHorizontally];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/6, size.height*0.9)];
    
}

-(void) hidePauseButton
{
    //TODO hide the pause button
}

-(void)pauseGame
{
    [self.delegate didPressPause:self];
}

-(void)replay
{
    [self.delegate didPressReplayFromHud:self];
}

@end
