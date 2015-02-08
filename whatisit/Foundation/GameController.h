//
//  GameController.h
//  clearway
//
//  Created by Abhishek Mishra on 6/26/13.
//
//

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "GameLayer.h"
#import "Hud.h"
#import "Level.h"
#import "LevelCompletion.h"

@interface GameController : CCScene
    
@property (nonatomic,assign) GameLayer *gameView;
@property (nonatomic,assign) ResultType gameResult;
@property (nonatomic,assign) LevelCompletion *levelCompletion;
@property (retain) Level *currentLevel;
@property (retain) Level *lastCompletedLevel;
@property (retain) Level *nextLevel;
@property (retain) Level *tempLevel;



// returns a CCScene that contains the HelloWorldLayer as the only child
-(id) initWithGameView:(GameLayer*) gameView;
-(void)pauseGame:(id)sender;
-(void)resumeGame:(id)sender;
-(bool)setGameLevel:(Level*) level;
-(Level*)getNextGameLevel;
-(bool) SetCurrentGameLevel;
-(bool)SetNextGameLevel;
-(Level*)getLastCompletedGameLevel;
-(void) resetGameBodies;
-(void)ShowMessageAtPositionForTime:(NSString*)str :(CGPoint) position :(int)forTime :(int) fontSize;
-(void) CleanMessage;
-(void)levelCompletionUpdate:(id)sender;

@end
