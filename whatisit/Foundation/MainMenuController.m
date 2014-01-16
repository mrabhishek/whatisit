//
//  MainMenuController.m
//  clearway
//
//  Created by Abhishek Mishra on 6/27/13.
//
//

#import "MainMenuController.h"

@implementation MainMenuController

-(id)initWithMenu
{
    if(self = [super init])
    {
        _Menu = [[MainMenu alloc] init]; //need to release in dealloc
        [self addChild:_Menu];
    }
    return self;
}

-(void)dealloc
{
    [self removeAllChildrenWithCleanup:YES]; //release for addchild
    [_Menu release]; //release for alloc init
    _Menu = nil;
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

-(void)onExit
{
    //this is to take care of releasing the count when
    //a new scene was pushed.
    //main menu scene is always pushed and not replaced
    //so every on exit should take care of releasing itself
    //[self release];
    [super onExit];
}

@end
