//
//  HelloWorldLayer.h
//  clearway
//
//  Created by Abhishek Mishra on 6/12/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "ApplicationConstants.h"
#import "Test.h"
#import "BodyTypes.h"
#import "VaryingRestitution.h"
#import "GDataXMLNode.h"
#import "LevelFileHandler.h"
#import "AbstractModel.h"
#import "Player.h"
#import "Target.h"
#import "Obstacle.h"
#import "MyContactListener.h"


@interface GameLayer : CCLayerGradient
{
	CCTexture2D *spriteTexture_;	// weak ref
    CGPoint _startLocation;
    CGPoint _midLocation;
    CGPoint _endLocation;
    
    
    Test* _gameBrain;
    Settings settings;
    
    CGSize m_windowSize;
    int m_dMultiplier;
    GLESDebugDraw* m_debugDraw;
    b2World* m_world;
    b2MouseJoint* m_mouseJoint;
    b2Vec2 m_mouseWorld;
    b2Body* m_groundBody;
    
    b2Body* m_player;
    b2Body* m_target;
    b2Body* m_boundary;
    
    CFTimeInterval _touchStartTime;
    int _firstMove;
    LevelFileHandler *_levelFile;
    MyContactListener *_contactListener;
}

-(ResultType) updateView: (ccTime) dt;
-(void) pauseGameView:(id)sender;
-(void) resumeGameView:(id)sender;
-(void) setGameLevel:(LevelFileHandler*)levelFile Sender:(id)sender;
-(void) resetGameBodies;


@end
