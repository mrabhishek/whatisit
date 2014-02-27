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

class BodyDetail
{
public:
    bool m_shouldDie;
    
    BodyDetail(bool shouldDie)
    {
        m_shouldDie = shouldDie;
    }
};

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
        
        //[self initWithColor:ccc4(255,255, 255, 255) fadingTo:ccc4(255, 255, 255, 255)];
        m_dMultiplier = 1;
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		m_windowSize = [CCDirector sharedDirector].winSize;
        
        if(m_windowSize.height > 500)
        {
            m_dMultiplier = 1.75f;
        }
		
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
    //_levelFile = levelfile;
    
    //once the level is set the game can be setup accordingly
    
    [self setupGame:levelfile];
}

-(void) dealloc
{
    delete _contactListener;
    _contactListener = NULL;
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

-(void) setupGame :(LevelFileHandler*) levelfile
{
    [self setupTarget:levelfile.target];
    [self setupPlayer:levelfile.player];
    [self setupObstacles:levelfile.obstacles];
}

-(void) setupWorld
{
    //setup the world
    b2Vec2 gravity;
    gravity.Set(0, -20.0f);
    m_world = new b2World(gravity);
    
    // Create contact listener
    _contactListener = new MyContactListener();
    m_world->SetContactListener(_contactListener);
    
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

-(void) resetGameBodies
{
    //loop through bodies of the world
    //delete them all
    std::vector<b2Body *>toDestroy;
    for (b2Body* b = m_world->GetBodyList(); b; b = b->GetNext())
    {
        if (b != m_boundary && b!= m_groundBody)
        {
            toDestroy.push_back(b);
        }
    }
    
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        m_world->DestroyBody(body);
    }
}

-(void)setupBoundaries
{
    b2BodyDef bd;
    m_boundary = m_world->CreateBody(&bd);
    
    //bottom 1 wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(0.0f)), b2Vec2(_X(m_windowSize.width), _X(0.0f)));
        m_boundary->CreateFixture(&shape, 0.0f);
    }
    
    //bottom 2 wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(m_windowSize.height*0.025)), b2Vec2(_X(m_windowSize.width), _X(m_windowSize.height*0.025)));
        m_boundary->CreateFixture(&shape, 0.0f);
    }
    
    //left wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(0.0f)), b2Vec2(_X(0.0f), _X(m_windowSize.height)));
        m_boundary->CreateFixture(&shape, 0.0f);
    }
    
    //top wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(m_windowSize.height)), b2Vec2(_X(m_windowSize.width), _X(m_windowSize.height)));
        m_boundary->CreateFixture(&shape, 0.0f);
    }
    
    //right wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(m_windowSize.width), 0.0f), b2Vec2(_X(m_windowSize.width), _X(m_windowSize.height)));
        m_boundary->CreateFixture(&shape, 0.0f);
    }
}


-(void)setupPlayer:(Player*)player
{
    m_player = [self setupbox2DBody:player];
}

-(void)setupObstacles :(NSMutableArray*) obstaclces
{
    for(Obstacle* obstacle in obstaclces)
    {
        [self setupbox2DBody:obstacle];
    }
}

-(void)setupTarget :(Target*)target
{
    m_target = [self setupbox2DBody:target];
}

-(b2Body*)setupbox2DBody:(AbstractModel*)model
{
    switch (model.shape) {
        case circle:
            return [self setupSphere:model:kCircleRadius];
            break;
        case plus_small:
        case plus:
            return [self setupPlusShapedWedge:model];
            break;
        case hwall_half:
            return [self setupBox:model.bodyType :0.25*m_windowSize.width :kHorizontalWallHeight :model.Position];
            break;
        case vwall_half:
            return [self setupBox:model.bodyType :kVerticalWallWidth :0.25*m_windowSize.height :model.Position];
            break;
        default:
            return NULL;
            break;
    }
}

-(b2Body*)setupPlusShapedWedge :(AbstractModel*) model
{
    float width = kPlusWidth;
    float height = kPlusHeight;
    
    switch (model.shape) {
        case plus:
            width = kPlusWidth;
            height = kPlusHeight;
            break;
        case plus_small:
            width = kPlusWidthSmall;
            height = kPlusHeightSmall;
            break;
        default:
            break;
    }
    
    BodyDetail* detail = new BodyDetail(model.die);
    
    return [self setupPlus:model.bodyType :width :height :model.Position:detail];
}


-(b2Body*)setupPlus :(b2BodyType) ofBodyType :(float) ofWidth :(float)ofHeight
                 :(CGPoint) position :(BodyDetail*) detail
{
    b2BodyDef bd;
    bd.type = ofBodyType;
    bd.position.Set(_X(position.x),_X(position.y));
    b2Body* ground = m_world->CreateBody(&bd);
    
    b2PolygonShape shape;
    shape.SetAsBox(_X(ofWidth*m_dMultiplier), _X(ofHeight*m_dMultiplier));
    ground->CreateFixture(&shape, 0.0f);
    
    b2PolygonShape shape2;
    shape2.SetAsBox(_X(ofHeight*m_dMultiplier), _X(ofWidth*m_dMultiplier));
    ground->CreateFixture(&shape2, 0.0f);
    
    ground->SetUserData(detail);
    
    return ground;
}

-(b2Body*)setupBox :(b2BodyType) ofBodyType :(float) ofWidth :(float)ofHeight
                   :(CGPoint) position
{
    
    b2BodyDef bd;
    bd.type = ofBodyType;
    bd.position.Set(_X(position.x),_X(position.y));
    b2Body* ground = m_world->CreateBody(&bd);
    
    b2PolygonShape shape;
    shape.SetAsBox(_X(ofWidth), _X(ofHeight));
    ground->CreateFixture(&shape, 0.0f);
    
    return ground;
}


-(b2Body*)setupSphere :(AbstractModel*) model :(float) ofRadius
{
    b2CircleShape shape;
    shape.m_radius = _X(ofRadius*m_dMultiplier);
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    
    b2BodyDef bd;
    bd.type = model.bodyType;
    bd.position.Set(_X(model.Position.x) , _X(model.Position.y));
    
    b2Body* body = m_world->CreateBody(&bd);
    
    fd.restitution = kBallRestitution;
    body->CreateFixture(&fd);
    
    BodyDetail* detail = new BodyDetail(model.die);
    
    body->SetUserData(detail);
    
    return body;
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

-(ResultType) updateView: (ccTime) dt
{
    ResultType result = noResult;
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
    
	m_world->Step(dt, velocityIterations, positionIterations);
    
    //Contact logic
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            BodyDetail* detailA = (BodyDetail *) bodyA->GetUserData();
            BodyDetail* detailB = (BodyDetail *) bodyB->GetUserData();
            
            if(detailA->m_shouldDie)
            {
                toDestroy.push_back(bodyA);
            }
            
            if(detailB->m_shouldDie)
            {
                toDestroy.push_back(bodyB);
            }
            
            if(bodyA == m_target || bodyB == m_target)
            {
                //if target is hit destroy the player
                //and fire a level complete event.
                result = levelComplete;
                //toDestroy.push_back(m_player);
            }
        }
    }
    
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        m_world->DestroyBody(body);
    }
    
    return result;
    
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
