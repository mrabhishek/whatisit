//
//  GameController.m
//  clearway
//
//  Created by Abhishek Mishra on 6/26/13.
//
//

#import "GameController.h"
#import "LevelFileHandler.h"

@implementation GameController

-(id )initWithGameView:(GameLayer*) gv
{
	if(self = [super init])
    {
        _gameView = gv;
        [self addChild:_gameView];
        
        [self scheduleUpdate];
    }
	return self;
}

-(void)dealloc
{
    //[self removeAllChildrenWithCleanup:YES];
    //[_gameView release]; no need to release it since we didn't alloc the memory here
    //we retained it because we added the view as a child
    //super dealloc will call remove all children which will clean it up.
    [super removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

-(void)pauseGame:(id)sender
{
    [[CCDirector sharedDirector] pause];
    [_gameView pauseGameView:self];
}

-(void)resumeGame:(id)sender
{
    [[CCDirector sharedDirector] resume];
    [_gameView resumeGameView:self];
}

-(void) update: (ccTime) dt
{
    [_gameView updateView:dt];
}

-(Level*)getDefaultLEvel
{
    return [[Level alloc]initWithEpisode:1 :3];
}

-(LevelFileHandler*)getLevelFileForLevel : (Level*)level
{
    //TODO convention for level to file name
    //change the file name from abc.txt to that
    
    return [[LevelFileHandler alloc] initWithFileName:[NSString stringWithFormat:@"%d_%d",level.episode,level.levelNum]];
}

-(bool)SetNextGameLevel
{
    Level *level = [self getLastPlayedGameLevel];
    //TODO get next level from here
    //Need to do the max check, If user completed all
    //available levels do something!!
    
    //if no previous level record found
    //set the default level
    
    if(level == nil)
    {
        level = [self getDefaultLEvel];
    }
    
    return [self setGameLevel:level];
}

-(bool)setGameLevel:(Level*) level
{
    assert(level);
    //TODO get the level file handler object
    //for this level
    //this should create the target and obstacles etc
    [_gameView setGameLevel:[self getLevelFileForLevel:level] Sender:self];
    
    return YES; //
}

-(Level*)getLastPlayedGameLevel
{
    //TODO change this to retrieve from saved level information
    return [[Level alloc]initWithEpisode:1 :1];
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
    //[self release];
    [super onExit];
}

@end
