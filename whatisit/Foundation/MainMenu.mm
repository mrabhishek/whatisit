//
//  Menu.m
//  clearway
//
//  Created by Abhishek Mishra on 6/18/13.
//
//


#import "MainMenu.h"

//// Needed to obtain the Navigation Controller
//#import "AppDelegate.h"

@implementation MainMenu

@synthesize delegate;

-(void) dealloc
{
	//delete world;
	//world = NULL;
	
	//delete m_debugDraw;
	//m_debugDraw = NULL;
	
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}


-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		//CGSize s = [CCDirector sharedDirector].winSize;
		
//        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//        app.navController.navigationBarHidden = YES;
		
		// create reset button
		[self createMenu];
	}
	return self;
}

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:44];
    [CCMenuItemFont setFontName:kFontName];
	
    // Reset Button
	CCMenuItemLabel *play = [CCMenuItemFont itemWithString:@"Play" block:^(id sender){
		//[SceneManager goHelloWorld];
        [self.delegate didPressPlay:self];
	}];
    
		
	CCMenu *menu = [CCMenu menuWithItems:play, nil];
    
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:-1];
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
