//
//  EpisodeSelectMenu.m
//  whatisit
//
//  Created by Abhishek Mishra on 7/5/14.
//
//

#import "EpisodeSelectMenu.h"

@implementation EpisodeSelectMenu

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
    
    NSMutableArray* levels = [NSMutableArray arrayWithCapacity:kTotalNumberOfEpisodes];;
    
    for (int i =0; i < kTotalNumberOfEpisodes; i++) {
        // Reset Button
        CCMenuItemImage *level = [CCMenuItemImage itemWithNormalImage:@"next.png" selectedImage:@"next.png" block:^(id sender){
            [self.delegate didPressEpisode:self:i+1];
        }];
        
        [levels addObject:level];
    }
    
    //Main menu
//	CCMenuItemImage *mainMenu = [CCMenuItemImage itemWithNormalImage:@"menu.png" selectedImage:@"menu.png" block:^(id sender){
//        [self.delegate didPressMainMenuFromEpisodeSelectMenu:self];
//	}];
    
    //[levels addObject:mainMenu];
    
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
