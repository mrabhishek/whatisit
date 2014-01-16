//
//  HelloWorldLayer.mm
//  clearway
//
//  Created by Abhishek Mishra on 6/12/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "GameLayer.h"
#import "PhysicsSprite.h"

enum {
	kTagParentNode = 1,
};

#define DEGTORAD 0.0174532925199432957f
#define RADTODEG 57.295779513082320876f

#pragma mark - GameLayer

@interface GameLayer()
-(void) initPhysics;
@end

@implementation GameLayer


-(id) init
{
	if( (self=[super init])) {
		
		// enable events
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		m_windowSize = [CCDirector sharedDirector].winSize;
		
		// init physics
		[self initPhysics];
		
#if 1
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
		spriteTexture_ = [parent texture];
        
#else
		// doesn't use batch node. Slower
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
		CCNode *parent = [CCNode node];
#endif
		[self addChild:parent z:0 tag:kTagParentNode];
	}
	return self;
}

-(void) setGameLevel:(LevelFileHandler*)levelfile Sender:(id)sender
{
    _levelFile = levelfile;
    
    //once the level is set the game can be setup accordingly
    
    [self setupGame];
}

-(void) dealloc
{
    delete m_world;
    m_world = NULL;

    delete m_debugDraw;
    m_debugDraw = NULL;
	
	[super dealloc];
}

-(void) initPhysics
{
    [self setupWorld];
    [self setupDebugDrawing];
    [self setupBoundaries];
}

-(void) setupGame
{
    [self setupBall];
    [self setupObstacles];
    [self setupTarget];
}

-(void) setupWorld
{
    //setup the world
    b2Vec2 gravity;
    gravity.Set(0, -20.0f);
    m_world = new b2World(gravity);
    
    m_world->SetAllowSleeping(true);
    m_world->SetContinuousPhysics(true);
    
    m_mouseJoint = NULL;
    
    b2BodyDef bodyDef;
	m_groundBody = m_world->CreateBody(&bodyDef);
}

-(void)setupDebugDrawing
{
    //debug drawings
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    m_world->SetDebugDraw(m_debugDraw);
    
    //debug flags
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    //flags += b2Draw::e_jointBit;
    //flags += b2Draw::e_aabbBit;
    //flags += b2Draw::e_pairBit;
    //flags += b2Draw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);
}

-(void)setupBoundaries
{
    b2BodyDef bd;
    b2Body* ground = m_world->CreateBody(&bd);
    //bottom wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(0.0f)), b2Vec2(_X(m_windowSize.width), _X(0.0f)));
        ground->CreateFixture(&shape, 0.0f);
    }
    
    //left wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(0.0f)), b2Vec2(_X(0.0f), _X(m_windowSize.height)));
        ground->CreateFixture(&shape, 0.0f);
    }
    
    //top wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(m_windowSize.height)), b2Vec2(_X(m_windowSize.width), _X(m_windowSize.height)));
        ground->CreateFixture(&shape, 0.0f);
    }
    
    //right wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(m_windowSize.width), 0.0f), b2Vec2(_X(m_windowSize.width), _X(m_windowSize.height)));
        ground->CreateFixture(&shape, 0.0f);
    }
}


-(void)setupBall
{
    [self setupSphere:b2_dynamicBody :25 :m_windowSize.width/2 :0];
}

-(void)setupObstacles
{
    [self setupPlusShapedWedge:0.250f*m_windowSize.width :0.50f*m_windowSize.height];
    [self setupPlusShapedWedge:0.60f*m_windowSize.width :0.70f*m_windowSize.height];
}

-(void)setupTarget
{
    [self setupSphere: b2_kinematicBody:30 :RandomFloat(15.0f, m_windowSize.width-15.0f)
                     :RandomFloat(15.0f, m_windowSize.height-15.0f)];
}


-(void)setupPlusShapedWedge :(float) centerAtX : (float) centerAtY
{
    [self setupHorizontalWedge:centerAtX :centerAtY];
    [self setupVerticalWedge:centerAtX :centerAtY];
}

-(void)setupHorizontalWedge :(float) centerAtX : (float) centerAtY
{
    [self setupBox:b2_kinematicBody :40 :10 :centerAtX :centerAtY];
}

-(void)setupVerticalWedge :(float) centerAtX : (float) centerAtY
{
    [self setupBox:b2_kinematicBody :10 :40 :centerAtX :centerAtY];
}

-(void)setupBox :(b2BodyType) ofBodyType :(float) ofWidth :(float)ofHeight
                :(float) centerAtX :(float) centerAtY
{
    {
        b2BodyDef bd;
        bd.type = ofBodyType;
        bd.position.Set(_X(centerAtX),_X(centerAtY));
        b2Body* ground = m_world->CreateBody(&bd);
        
        b2PolygonShape shape;
        shape.SetAsBox(_X(ofWidth), _X(ofHeight));
        ground->CreateFixture(&shape, 0.0f);
    }
}


-(void)setupSphere :(b2BodyType) ofBodyType : (float) ofRadius : (float) centerAtX : (float) centerAtY
{
    {
        b2CircleShape shape;
        shape.m_radius = _X(ofRadius);
        
        b2FixtureDef fd;
        fd.shape = &shape;
        fd.density = 1.0f;
    
        b2BodyDef bd;
        bd.type = ofBodyType;
        bd.position.Set(_X(centerAtX) , _X(centerAtY));
            
        b2Body* body = m_world->CreateBody(&bd);
            
        fd.restitution = 0.80f;
        body->CreateFixture(&fd);
    }
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
    
    /// If center needs to be moved.
    //[self.camera setCenterX:settings.viewCenter.x*PTM_RATIO centerY:settings.viewCenter.y*PTM_RATIO centerZ:0];
    //[self.camera setEyeX:settings.viewCenter.x*PTM_RATIO eyeY:settings.viewCenter.y*PTM_RATIO eyeZ:415];
	
    m_world->DrawDebugData();
	kmGLPopMatrix();
}



-(void) updateView: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
    
	m_world->Step(dt, velocityIterations, positionIterations);
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        _startLocation = [touch locationInView: [touch view]];
		
		_startLocation = [[CCDirector sharedDirector] convertToGL: _startLocation];
        _midLocation = _startLocation;
	}
    
    _firstMove = 0;
    
    b2Vec2 p =  b2Vec2(_X(_startLocation.x),_X(_startLocation.y));
    m_mouseWorld = p;
    
    if (m_mouseJoint != NULL)
    {
        return;
    }
    
    // Make a small box.
    b2AABB aabb;
    b2Vec2 d;
    d.Set(_X(0.001f), _X(0.001f));
    aabb.lowerBound = p - d;
    aabb.upperBound = p + d;
    
    // Query the world for overlapping shapes.
    QueryCallback callback(p);
    m_world->QueryAABB(&callback, aabb);
    
    if (callback.m_fixture)
    {
        b2Body* body = callback.m_fixture->GetBody();
        b2MouseJointDef md;
        md.bodyA = m_groundBody;
        md.bodyB = body;
        md.target = body->GetPosition();//p;
        md.maxForce = 5000.0f * body->GetMass();
        m_mouseJoint = (b2MouseJoint*)m_world->CreateJoint(&md);
        body->SetAwake(true);
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        _firstMove++;
        
        if(_firstMove == 1)
        {
            _touchStartTime = CACurrentMediaTime();
        }
        
        CFTimeInterval elapsedTime = CACurrentMediaTime() - _touchStartTime;
        
        //NSLog(@"elapsed time %f",elapsedTime);
        //swipe can't last more than 0.2 seconds
        if(elapsedTime > 0.2)
        {
            break;
        }
        //NSLog(@"Elapsed time %f",elapsedTime);
        
        _endLocation = [touch locationInView: [touch view]];
		
		_endLocation = [[CCDirector sharedDirector] convertToGL: _endLocation];
        
        _midLocation = _endLocation;
	}
    
    b2Vec2 p = b2Vec2(_X(_endLocation.x),_X(_endLocation.y));
    
    m_mouseWorld = p;
    
    if (m_mouseJoint)
    {
        m_mouseJoint->SetTarget(p);
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        _endLocation = [touch locationInView: [touch view]];
		
		_endLocation = [[CCDirector sharedDirector] convertToGL: _endLocation];
    }
    
    if (m_mouseJoint)
    {
        m_world->DestroyJoint(m_mouseJoint);
        m_mouseJoint = NULL;
    }
}

-(void) pauseGameView:(id)sender
{
    settings.pause = true;
}
-(void) resumeGameView:(id)sender
{
    settings.pause = false;
}

class QueryCallback : public b2QueryCallback
{
public:
	QueryCallback(const b2Vec2& point)
	{
		m_point = point;
		m_fixture = NULL;
	}
    
	bool ReportFixture(b2Fixture* fixture)
	{
		b2Body* body = fixture->GetBody();
		if (body->GetType() == b2_dynamicBody)
		{
			bool inside = fixture->TestPoint(m_point);
			if (inside)
			{
				m_fixture = fixture;
                
				// We are done, terminate the query.
				return false;
			}
		}
        
		// Continue the query.
		return true;
	}
    
	b2Vec2 m_point;
	b2Fixture* m_fixture;
};

@end
