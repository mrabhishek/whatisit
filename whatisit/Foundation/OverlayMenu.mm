//
//  OverlayMenu.m
//  clearway
//
//  Created by Abhishek Mishra on 6/22/13.
//
//

#import "OverlayMenu.h"

@implementation OverlayMenu

@synthesize delegate;

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		//CGSize s = [CCDirector sharedDirector].winSize;

		
		// create reset button
		[self createOverlayMenu];
	}
	return self;
}

-(void)dealloc
{
    //[self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

-(void) createOverlayMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:44];
    [CCMenuItemFont setFontName:kFontName];
	
    // Reset Button
	CCMenuItemImage *play = [CCMenuItemImage itemWithNormalImage:@"resume.png" selectedImage:@"resume.png" block:^(id sender){
        [self.delegate didPressResume:self];
	}];
    
//    // Reset Button
//	CCMenuItemLabel *newGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender){
//        [self.delegate didPressRestart:self];
//	}];
    
    // App Store Button
	CCMenuItemImage *appStore = [CCMenuItemImage itemWithNormalImage:@"appstore.png" selectedImage:@"appstore.png" block:^(id sender){
        [self.delegate didPressAppStore:self];
	}];
    
    //Main menu
	CCMenuItemImage *mainMenu = [CCMenuItemImage itemWithNormalImage:@"mainmenu.png" selectedImage:@"mainmenu.png" block:^(id sender){
        [self.delegate didPressMainMenu:self];
	}];
    
    
	CCMenu *menu = [CCMenu menuWithItems:play,appStore,mainMenu, nil];
    
	[menu alignItemsVerticallyWithPadding:20];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:-1];
}

-(void) hideOverlayMenu
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
