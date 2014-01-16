//
//  SceneController.m
//  clearway
//
//  Created by Abhishek Mishra on 6/26/13.
//
//

//controls all scenes in the game

#import "SceneController.h"

#define TAG_HUD  201
#define TAG_OVERLAY_MENU 301

@interface SceneController()

@end

@implementation SceneController

//Hud delegate implementation

//main menu impl

-(CCScene*) getCurrentScene
{
    //[self init];
    return _currentScene;
}

-(id) init
{
    if(self = [super init])
    {
        [self setupMenuScene];
        [self setCurrentScene:_mainMenuController];
    }
    
    return self;
}

-(void)dealloc
{
    [_mainMenuController release];
    _mainMenuController = nil;
    [super dealloc];
}

-(void)setCurrentScene:(CCScene*)scene
{
    if(_currentScene != nil)
    {
        [_currentScene release];
    }
    _currentScene = scene;
}

-(void) pushCurrentScene
{
    [[CCDirector sharedDirector] pushScene: _currentScene];
}

-(void) setupMenuScene
{
    if(_mainMenuController == nil)
    {
        _mainMenuController = [[MainMenuController alloc] initWithMenu];
        _mainMenuController.Menu.delegate = self;
    }
}

-(void) cleanupMenuScene
{
    [_mainMenuController release];
    _mainMenuController = nil;
}

-(void) setupAppStoreScene
{
    if(_appStoreController == nil)
    {
        _appStoreController = [[AppStoreController alloc] initWitAppStoreView];
        _appStoreController.AppStoreView.delegate = self;
    }
}

-(void) cleanupAppStoreScene
{
    [_appStoreController release];
    _appStoreController = nil;
}

-(void) setupGameScene
{
    if(_gameController ==nil)
    {
        //TODO get a game controller
        //push it on to the director
        _hud = [[Hud alloc]init];
        _hud.delegate = self;
        
        _overlayMenu = [[OverlayMenu alloc] init];
        _overlayMenu.delegate = self;
        
        //autorealese because gamecontroller will own it
        //by adding it as a child
        GameLayer * gameLayer = [[[GameLayer alloc]init] autorelease];
        _gameController = [[GameController alloc] initWithGameView:gameLayer];
        [_gameController addChild:_hud z:1 tag:TAG_HUD];
        [_gameController SetNextGameLevel];
    }
}

//Main Menu delegates
-(void)didPressPlay:(id)sender
{
    [self cleanupMenuScene];
    [self setupGameScene];
    [self setCurrentScene:_gameController];
    [self pushCurrentScene];
    [_gameController resumeGame:self];
}

-(void)didPressPause :(id)sender
{
    //_hud.hidePauseButton;
    //_hud.overlayMenu
    //TODO make sure to get a proper scene
    if(_gameController != nil)
    {
        [_gameController pauseGame:self];
        [_gameController removeChildByTag:TAG_HUD cleanup:NO];
        [_gameController addChild:_overlayMenu z:1 tag:TAG_OVERLAY_MENU];
    }
}

//overlay menu delegate method
-(void) didPressResume:(id)sender
{
    if(_gameController != nil)
    {
        [_gameController resumeGame:self];
        [_gameController removeChildByTag:TAG_OVERLAY_MENU cleanup:NO];
        [_gameController addChild:_hud z:1 tag:TAG_HUD];
    }
}

-(void) didPressRestart:(id)sender
{
    //TODO game controller needs to be reset
    //no need to kill all the other stuff
    //we are cleaning up everything -restart the whole game
    [self cleanupGameObjects];
    [self setupGameScene];
    [self setCurrentScene:_gameController];
    [self pushCurrentScene];
    [_gameController resumeGame:self];
    
}

-(void) didPressAppStore:(id)sender
{
    [self cleanupGameObjects];
    
    [self setupAppStoreScene];
    [self setCurrentScene:_appStoreController];
    [self pushCurrentScene];
    
    //need to implement cleanup appstore scene;
}

-(void) didPressMainMenu: (id)sender
{
    //TODO release everything
    //may need to be changed if your game
    //init takes a lot of time
    //do selective cleanup.
    
    [self cleanupGameObjects];
    
    //replace with main menu scene
    //may need to recreate main menu scene if it was disposed earlier
    [self setupMenuScene];
    [self setCurrentScene:_mainMenuController];
    [self pushCurrentScene];
    
    
}

-(void)levelComplete :(id)sender
{
    //TODO Add the level complete screen
    //with option of going to previous/next level
    
    /*if(_gameController != nil)
    {
        [_gameController pauseGame:self];
        [_gameController removeChildByTag:TAG_HUD cleanup:NO];
        [_gameController addChild:_overlayMenu z:1 tag:TAG_OVERLAY_MENU];
    }*/
}

-(void)levelFailed :(id)sender
{
    //TODO Add the level fail screen
    //with option of going to previous/next level
    
    /*if(_gameController != nil)
    {
        [_gameController pauseGame:self];
        [_gameController removeChildByTag:TAG_HUD cleanup:NO];
        [_gameController addChild:_overlayMenu z:1 tag:TAG_OVERLAY_MENU];
    }
     */
}

//overlay menu delegate method
-(void) didPressNextLevel:(id)sender
{
    //TODO setup next level
    
    /*if(_gameController != nil)
    {
        [_gameController resumeGame:self];
        [_gameController removeChildByTag:TAG_OVERLAY_MENU cleanup:NO];
        [_gameController addChild:_hud z:1 tag:TAG_HUD];
    }*/
}

//overlay menu delegate method
-(void) didPressPreviousLevel:(id)sender
{
    //TODO setup previous level on the game
    /*if(_gameController != nil)
    {
        [_gameController resumeGame:self];
        [_gameController removeChildByTag:TAG_OVERLAY_MENU cleanup:NO];
        [_gameController addChild:_hud z:1 tag:TAG_HUD];
    }*/
}

//overlay menu delegate method
-(void) didPressSameLevel:(id)sender
{
    //TODO setup same level on the game
    /*if(_gameController != nil)
     {
     [_gameController resumeGame:self];
     [_gameController removeChildByTag:TAG_OVERLAY_MENU cleanup:NO];
     [_gameController addChild:_hud z:1 tag:TAG_HUD];
     }*/
}

//app store delegae
- (void)buyButtonClicked:(id)sender
{
    [_appStoreController buyButtonClicked:sender];
}

- (void)buyButtonTapped:(id)sender
{
    [_appStoreController buyButtonTapped:sender];
}

//end app store delegae

-(void) cleanupGameObjects
{
    [_hud release];
    _hud = nil;
    [_overlayMenu release];
    _overlayMenu = nil;
    [_gameController stopAllActions];
	[_gameController unscheduleAllSelectors];
    [_gameController release];
    _gameController = nil;
}

@end