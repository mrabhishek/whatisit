//
//  LevelSelectMenu.m
//  whatisit
//
//  Created by Abhishek Mishra on 7/5/14.
//
//

#import "LevelSelectMenu.h"

@implementation LevelSelectMenu

@synthesize delegate;

-(id) initWithEpisode:(int) episode
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		//CGSize s = [CCDirector sharedDirector].winSize;
        
        m_episode = episode;
		
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

-(void)setEpisode: (int)episode
{
    m_episode = episode;
}

-(int) getEpisode
{
    return m_episode;
}

-(void) createLevelMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:44];
    [CCMenuItemFont setFontName:kFontName];
    
    NSMutableArray* levels = [NSMutableArray arrayWithCapacity:kLevelsPerEpisode];;
    
    for (int i =0; i < kLevelsPerEpisode; i++) {
        // Reset Button
        CCMenuItemImage *level = [CCMenuItemImage itemWithNormalImage:@"next.png" selectedImage:@"next.png" block:^(id sender){
            [self.delegate didPressLevel:self:i+1];
        }];
        
        [levels addObject:level];
    }
    
    //Main menu
//	CCMenuItemImage *mainMenu = [CCMenuItemImage itemWithNormalImage:@"menu.png" selectedImage:@"menu.png" block:^(id sender){
//        [self.delegate didPressMainMenuFromLevelSelectMenu:self];
//	}];
//    
//    [levels addObject:mainMenu];
    
	CCMenu *menu = [CCMenu menuWithArray:levels];
    [menu alignItemsVertically];
    //[menu alignItemsInRows:[NSNumber numberWithInt:5], menu, nil];
    
	//[menu alignItemsInColumns:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1], nil];
	
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
