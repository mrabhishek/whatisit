//
//  LevelCompletionDelegate.m
//  whatisit
//
//  Created by Abhishek Mishra on 1/20/14.
//
//

#import "LevelCompletion.h"

@implementation LevelCompletion

@synthesize delegate;

-(id) init
{
	if( (self=[super init])) {
		
	}
	return self;
}

-(void)dealloc
{
    //[self removeAllChildrenWithCleanup:YES];
    [super dealloc];
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
