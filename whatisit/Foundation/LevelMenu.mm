//
//  LevelMenu.m
//  whatisit
//
//  Created by Abhishek Mishra on 1/20/14.
//
//

#import "LevelMenu.h"

@implementation LevelMenu

@synthesize delegate;

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		//CGSize s = [CCDirector sharedDirector].winSize;
        
		
		// create reset button
		[self createLevelMenu];
	}
	return self;
}

-(void)dealloc
{
    //[self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

-(void) createLevelMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:44];
    [CCMenuItemFont setFontName:kFontName];
	
    // Reset Button
	CCMenuItemImage *replay = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay.png" block:^(id sender){
        [self.delegate didPressReplay:self];
	}];
    
    // Reset Button
	CCMenuItemImage *next = [CCMenuItemImage itemWithNormalImage:@"next.png" selectedImage:@"next.png" block:^(id sender){
        [self.delegate didPressNextLevel:self];
	}];
    
    //Main menu
	CCMenuItemImage *mainMenu = [CCMenuItemImage itemWithNormalImage:@"menu.png" selectedImage:@"menu.png" block:^(id sender){
        [self.delegate didPressMainMenuFromLevelMenu:self];
	}];
    
	CCMenu *menu = [CCMenu menuWithItems:replay,next,mainMenu, nil];
    
	[menu alignItemsInColumns:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1], nil];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, 0.33*size.height)];
	
	
	[self addChild: menu z:-1];
}

-(void) hideLevelMenu
{
    //TODO hide overlay menu
    //can receive message from controller
}

//for testing purposes
- (id) retain
{
    return [super retain];
}

-(oneway void) release
{
    [super release];
}

-(void)onEnter
{
    [super onEnter];
}

-(void) onExit
{
    //no need not release because Main menu is not being pushed as a scene
    [super onExit];
}

@end