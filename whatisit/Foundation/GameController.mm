//
//  GameController.m
//  clearway
//
//  Created by Abhishek Mishra on 6/26/13.
//
//

#import "GameController.h"
#import "LevelFileHandler.h"
#import "LevelMenu.h"

@implementation GameController

-(id )initWithGameView:(GameLayer*) gv
{
	if(self = [super init])
    {
        _gameResult =noResult;
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
    //if there is already a result
    //don't keep updating the view.
    if(_gameResult == noResult)
    {
        _gameResult = [_gameView updateView:dt];
        
        switch (_gameResult) {
            case levelComplete:
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(levelComplete:) userInfo:nil repeats:NO];
                //[self levelComplete:self];
                break;
            case levelFailed:
                [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(levelFailed:) userInfo:nil repeats:NO];
                //[self levelFailed:self];
                break;
            default:
                break;
        }
    }
}

-(void)levelComplete :(id)sender
{
    if(_lastCompletedLevel == nil)
    {
        _lastCompletedLevel = [[Level alloc] initWithEpisode:_currentLevel.episode :_currentLevel.levelNum];
    }
    else
    {
        _lastCompletedLevel.episode = _currentLevel.episode;
        _lastCompletedLevel.levelNum = _currentLevel.levelNum;
    }
    //sleep(1);
    [_levelCompletion.delegate levelComplete:self];
}

-(void)levelFailed :(id)sender
{
    //sleep(1);
    [_levelCompletion.delegate levelFailed:self];
}

-(Level*)getDefaultLEvel
{
    return [[Level alloc]initWithEpisode:1 :1];
}

-(LevelFileHandler*)getLevelFileForLevel : (Level*)level
{
    //TODO convention for level to file name
    //change the file name from abc.txt to that
    
    return [[LevelFileHandler alloc] initWithFileName:[NSString stringWithFormat:@"%d_%d",level.episode,level.levelNum]];
}

-(bool) SetCurrentGameLevel
{
    Level *level = _currentLevel;
    if(level == nil)
    {
        level = [self getDefaultLEvel];
    }
    
    if(level == nil)
    {
        return NO;
    }
    
    return [self setGameLevel:level];
}

-(bool)SetNextGameLevel
{
    Level* level = [self getLastCompletedGameLevel];
    //TODO get next level from here
    //Need to do the max check, If user completed all
    //available levels do something!!
    
    //if no previous level record found
    //set the default level
    
    if(level == nil)
    {
        level = [self getDefaultLEvel];
    }
    else
    {
        //make sure not to change the last completed level pointer
        level = [Level getNext:[[Level alloc]initWithEpisode:level.episode :level.levelNum]];
    }
    
    if(level == nil)
    {
        return NO;
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
    _gameResult = noResult;
    _currentLevel =level;
    
    return YES; //
}

-(Level*)getLastCompletedGameLevel
{
    return _lastCompletedLevel;
}

-(void)resetGameBodies
{
    [_gameView resetGameBodies];
}

-(void)ShowMessageAtPositionForTime:(NSString*)str :(CGPoint) position :(int)forTime :(int) fontSize
{
    //TODO show a message at position
    CCLabelTTF  *startText = [CCLabelTTF labelWithString:str fontName:kFontName fontSize:fontSize];
    startText.position = position;
    [startText runAction:[CCFadeTo actionWithDuration:forTime opacity:1.0f]];
    if([self getChildByTag:TAG_GAME_CONTROLLER_TEXT])
    {
        [self removeChildByTag:TAG_GAME_CONTROLLER_TEXT cleanup:YES];
    }
    [self addChild:startText z:1 tag:TAG_GAME_CONTROLLER_TEXT];
}

-(void) CleanMessage
{
    if([self getChildByTag:TAG_GAME_CONTROLLER_TEXT])
    {
        [self removeChildByTag:TAG_GAME_CONTROLLER_TEXT cleanup:YES];
    }
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
