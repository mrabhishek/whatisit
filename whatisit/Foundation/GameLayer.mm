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
    int m_id;
    bool m_shouldDie;
    bool m_sensor;
    bool m_killerWall;
    bool m_movingx;
    bool m_movingy;
    float m_vel;
    CCSprite* m_sprite;
    
    BodyDetail(int ident,CCSprite* sprite,bool shouldDie, bool sensor = false, bool killerWall = false
               ,bool movingx = false, bool movingy = false, float vel=0)
    {
        m_id = ident;
        m_sprite = sprite;
        m_shouldDie = shouldDie;
        m_sensor = sensor;
        m_killerWall = killerWall;
        m_movingx = movingx;
        m_movingy = movingy;
        m_vel = vel;
    }
    
    ~BodyDetail()
    {
        m_sprite = nil;
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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background;
        
        background = [CCSprite spriteWithFile:@"bge1.png"];
        
        background.position = ccp(size.width/2, size.height/2);
        
        // add the label as a child to this Layer
        [self addChild: background];
		
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
    delete m_contactListener;
    m_contactListener = NULL;
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
    [self setupJoints:levelfile.revoluteJoints];
}

-(void) setupWorld
{
    //setup the world
    b2Vec2 gravity;
    gravity.Set(0, -20.0f);
    m_world = new b2World(gravity);
    
    // Create contact listener
    m_contactListener = new MyContactListener();
    m_world->SetContactListener(m_contactListener);
    
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
        BodyDetail* detail = (BodyDetail*) body->GetUserData() ;
        if(detail !=nil)
        {
            [self removeChild:detail->m_sprite cleanup:NO];
        }
        m_world->DestroyBody(body);
        body = NULL;
    }
}

-(void)setupBoundaries
{
    b2BodyDef bd;
    m_boundary = m_world->CreateBody(&bd);
    
    //bottom 1 wall
    /*{
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(0.0f)), b2Vec2(_X(m_windowSize.width), _X(0.0f)));
        m_boundary->CreateFixture(&shape, 0.0f);
    }*/
    
    //bottom 2 wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(m_windowSize.height*0.025)), b2Vec2(_X(m_windowSize.width), _X(m_windowSize.height*0.025)));
        m_boundary->CreateFixture(&shape, 0.0f);
        
        CCSprite* spr = [CCSprite spriteWithFile:@"hwall_half.png"];
        spr.position = ccp(m_windowSize.width*0.25, m_windowSize.height*0.0125);
        [self addChild:spr z:2];
        CCSprite* spr2 = [CCSprite spriteWithFile:@"hwall_half.png"];
        spr2.position = ccp(m_windowSize.width*0.75, m_windowSize.height*0.0125);
        [self addChild:spr2 z:2];
    }
    
    //left wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(m_windowSize.width*0.025), _X(0.0f)), b2Vec2(_X(0.0f), _X(m_windowSize.height)));
        m_boundary->CreateFixture(&shape, 0.0f);
        
        CCSprite* spr = [CCSprite spriteWithFile:@"vwall_half.png"];
        spr.position = ccp(m_windowSize.width*0.0125, m_windowSize.height*0.25);
        [self addChild:spr z:2];
        CCSprite* spr2 = [CCSprite spriteWithFile:@"vwall_half.png"];
        spr2.position = ccp(m_windowSize.width*0.0125, m_windowSize.height*0.75);
        [self addChild:spr2 z:2];
    }
    
    //top wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(0.0f), _X(m_windowSize.height*0.975)), b2Vec2(_X(m_windowSize.width), _X(m_windowSize.height*0.975)));
        m_boundary->CreateFixture(&shape, 0.0f);
        
        CCSprite* spr = [CCSprite spriteWithFile:@"hwall_half.png"];
        spr.position = ccp(m_windowSize.width*0.25, m_windowSize.height*0.9875);
        [self addChild:spr z:2];
        CCSprite* spr2 = [CCSprite spriteWithFile:@"hwall_half.png"];
        spr2.position = ccp(m_windowSize.width*0.75, m_windowSize.height*0.9875);
        [self addChild:spr2 z:2];
    }
    
    //right wall
    {
        b2EdgeShape shape;
        shape.Set(b2Vec2(_X(m_windowSize.width*.975), 0.0f), b2Vec2(_X(m_windowSize.width*.975), _X(m_windowSize.height)));
        m_boundary->CreateFixture(&shape, 0.0f);
        
        CCSprite* spr = [CCSprite spriteWithFile:@"vwall_half.png"];
        spr.position = ccp(m_windowSize.width*0.9875, m_windowSize.height*0.25);
        [self addChild:spr z:2];
        CCSprite* spr2 = [CCSprite spriteWithFile:@"vwall_half.png"];
        spr2.position = ccp(m_windowSize.width*0.9875, m_windowSize.height*0.75);
        [self addChild:spr2 z:2];
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
    if(target.shape == circle)
    {
        float scale = (float)25.0f/25.0f;
        b2CircleShape shape;
        shape.m_radius = _X(kCircleRadius*m_dMultiplier*scale);
        
        b2FixtureDef fd;
        fd.shape = &shape;
        fd.density = 1.0f;
        
        b2BodyDef bd;
        bd.type = target.bodyType;
        bd.position.Set(_X(target.Position.x) , _X(target.Position.y));
        
        b2Body* body = m_world->CreateBody(&bd);
        
        fd.restitution = kBallRestitution;
        body->CreateFixture(&fd);
        
        CCSprite* spr = [CCSprite spriteWithFile:@"circle.png"];
        spr.position = ccp(target.Position.x, target.Position.y);
        spr.scale = scale;
        [self addChild:spr];
        
        BodyDetail* detail = new BodyDetail(target.Id, spr,target.die,target.sensor);
        
        body->SetUserData(detail);
        body->SetAngularVelocity(target.angularVelocity);
        
        m_target = body;
    }
    //m_target = [self setupbox2DBody:target];
}

-(void) setupJoints :(NSMutableArray*) joints
{
    for(RevoluteJoint* joint in joints)
    {
        if([joint.jointType isEqualToString: @"revolute"] )
        {
            [self setupRevoluteJoint:joint];
        }
    }
}

-(b2RevoluteJoint*) setupRevoluteJoint:(RevoluteJoint*) joint
{
    b2RevoluteJointDef revJointDef;
    for (b2Body* b = m_world->GetBodyList(); b; b = b->GetNext())
    {
        BodyDetail* detail = (BodyDetail*)b->GetUserData();
        if (detail !=nil)
        {
            if(detail->m_id == joint.IdBodyA)
            {
                b->SetGravityScale(0);
                revJointDef.bodyA = b;
            }
            else if (detail->m_id == joint.IdBodyB)
            {
                b->SetGravityScale(0);
                revJointDef.bodyB = b;
                revJointDef.localAnchorB.Set(-2,0);
            }
        }
        revJointDef.collideConnected = joint.collideConnected;
    }
    
    return (b2RevoluteJoint*)m_world->CreateJoint(&revJointDef);
}

-(b2Body*)setupbox2DBody:(AbstractModel*)model
{
    int multiplier = 1;
    switch (model.shape) {
        case circle:
            return [self setupSphere:model:kCircleRadius];
            break;
        case plus_small:
        case plus:
            return [self setupPlusShapedWedge:model];
            break;
        case hwall_quarter:
            if(model.killerwall) multiplier= 2;
            return [self setupBox:model :0.125*m_windowSize.width :multiplier*kHorizontalWallHeight];
            break;
        case hwall_half:
            return [self setupBox:model :0.25*m_windowSize.width :multiplier*kHorizontalWallHeight];
            break;
        case hwall_full:
            return [self setupBox:model :0.5*m_windowSize.width :multiplier*kHorizontalSideWallHeight];
            break;
        case vwall_quarter:
            return [self setupBox:model :multiplier*kVerticalWallWidth :0.125*m_windowSize.height];
            break;
        case vwall_half:
            return [self setupBox:model :multiplier*kVerticalWallWidth :0.25*m_windowSize.height];
            break;
        case vwall_full:
            return [self setupBox:model :multiplier*kVerticalSideWallWidth :0.5*m_windowSize.height];
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
    
    BodyDetail* detail = new BodyDetail(model.Id,[self getSpriteForBody:model],model.die,model.sensor);
    
    return [self setupPlus:model.bodyType :width :height :model.Position:detail:model];
}


-(b2Body*)setupPlus :(b2BodyType) ofBodyType :(float) ofWidth :(float)ofHeight
                    :(CGPoint) position :(BodyDetail*) detail :(AbstractModel*) model
{
    b2BodyDef bd;
    bd.type = ofBodyType;
    bd.position.Set(_X(position.x),_X(position.y));
    b2Body* ground = m_world->CreateBody(&bd);
    
    b2PolygonShape shape;
    shape.SetAsBox(_X(ofWidth*m_dMultiplier), _X(ofHeight*m_dMultiplier));
    b2Fixture* fix = ground->CreateFixture(&shape, 0.0f);
    b2Filter filter = b2Filter();
    filter.categoryBits =0x04;
    filter.maskBits = 0xffff;
    fix->SetFilterData(filter);
    fix->SetSensor(detail->m_sensor);
    
    
    
    b2PolygonShape shape2;
    shape2.SetAsBox(_X(ofHeight*m_dMultiplier), _X(ofWidth*m_dMultiplier));
    b2Fixture* fix2 = ground->CreateFixture(&shape2, 0.0f);
    fix2->SetSensor(detail->m_sensor);
    
    filter.categoryBits =0x04;
    filter.maskBits = 0xffff;
    fix2->SetFilterData(filter);
    
    
    ground->SetUserData(detail);
    ground->SetAngularVelocity(model.angularVelocity);
    
    return ground;
}

-(CCSprite*)getSpriteForBody :(AbstractModel*)model
{
    NSString* filename;
    float scale =1;
    
    switch (model.shape) {
        case plus:
            filename = @"plus.png";
            filename = @"circle.png";
            break;
        case plus_small:
            filename = @"plus_small.png";
            break;
        case hwall_half:
            filename = @"hwall_half.png";
            if(model.killerwall) filename =@"hwall_half_killerwall.png";
            break;
        case hwall_quarter:
            filename = @"hwall_quarter.png";
            if(model.killerwall) filename =@"hwall_quarter_killerwall.png";
            break;
        case hwall_full:
            filename = @"hwall_full.png";
            break;
        case vwall_half:
            filename = @"vwall_half.png";
            if(model.killerwall) filename =@"vwall_half_killerwall.png";
            break;
        case vwall_quarter:
            filename = @"vwall_quarter.png";
            if(model.killerwall) filename =@"vwall_quarter_killerwall.png";
            break;
        case vwall_full:
            filename = @"vwall_full.png";
            break;
        case circle:
            filename =@"circle.png";

            break;
        default:
            filename = @"circle.png";
            break;
    }
    CCSprite* spr = [CCSprite spriteWithFile:filename];
    spr.position = ccp(model.Position.x, model.Position.y);
    spr.scale = scale;
    [self addChild:spr];
    return spr;
}

-(b2Body*)setupBox :(AbstractModel*)model :(float) ofWidth :(float)ofHeight
{
    
    b2BodyDef bdB;
    bdB.type = model.bodyType;
    bdB.position.Set(_X(model.Position.x),_X(model.Position.y));
    b2Body* groundBox = m_world->CreateBody(&bdB);
    
    b2FixtureDef myFixtureDef;
    myFixtureDef.density = 1;
    myFixtureDef.restitution = 0;
    b2PolygonShape shapeBox;
    shapeBox.SetAsBox(_X(ofWidth), _X(ofHeight));
    
    myFixtureDef.shape = &shapeBox;
    if(!m_world)
        NSLog(@"World is null");
    groundBox->CreateFixture(&myFixtureDef);
    
    
    BodyDetail* detail = new BodyDetail(model.Id,[self getSpriteForBody:model],model.die,model.sensor,model.killerwall);
    
    if(model.movingx)
    {
        if(model.vel.x >0)
        {
            //groundBox->SetGravityScale(0);
            //float velChange = 1;
            //float impulse = groundBox->GetMass() * velChange; //disregard time factor
            //groundBox->ApplyLinearImpulse( b2Vec2(impulse,0), groundBox->GetWorldCenter() );
            detail->m_vel = model.vel.x;
            detail->m_movingx = true;
            groundBox->SetLinearVelocity(model.vel);
            
        }
    }
    else if(model.movingy)
    {
        if(model.vel.y > 0)
        {
            detail->m_vel = model.vel.y;
            detail->m_movingy = true;
            groundBox->SetLinearVelocity(model.vel);
        }
    }
    
    groundBox->SetUserData(detail);
    groundBox->SetAngularVelocity(model.angularVelocity);
    
    return groundBox;
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
    
    BodyDetail* detail = new BodyDetail(model.Id,[self getSpriteForBody:model],model.die,model.sensor);
    
    body->SetUserData(detail);
    body->SetAngularVelocity(model.angularVelocity);
    
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
    bool aIsTarget = false;
    bool bIsTarget = false;
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
    
	m_world->Step(dt, velocityIterations, positionIterations);
    
    for (b2Body* b = m_world->GetBodyList(); b; b = b->GetNext())
    {
        BodyDetail* detail = (BodyDetail*)b->GetUserData();
        if (detail !=nil)
        {
            CCSprite* sprite = detail->m_sprite;
            CGPoint pos = ccp(b->GetPosition().x*PTM_RATIO,b->GetPosition().y*PTM_RATIO);
            
            //experimental for moving kinematic bodies in SHM between walls.
            {
                if(detail->m_movingx)
                {
                    if(pos.x >= m_windowSize.width - [sprite boundingBox].size.width/2 || pos.x <= [sprite boundingBox].size.width/2 )
                        b->SetLinearVelocity(-b->GetLinearVelocity());
                }
                else if(detail->m_movingy)
                {
                    if(pos.y >= m_windowSize.height - [sprite boundingBox].size.height/2 || pos.y <= [sprite boundingBox].size.height/2)
                        b->SetLinearVelocity(-b->GetLinearVelocity());
                }
            }
            
            sprite.position = pos;
            sprite.rotation = -1*b->GetAngle()*180/M_PI;
        }
    }
    
    //Contact logic
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = m_contactListener->_contacts.begin();
        pos != m_contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            BodyDetail* detailA = (BodyDetail *) bodyA->GetUserData();
            BodyDetail* detailB = (BodyDetail *) bodyB->GetUserData();
            
            if(bodyA == m_target)
                aIsTarget = true;
            if(bodyB == m_target)
                bIsTarget = true;
            
            if(detailA->m_shouldDie)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyA) != toDestroy.end())
                {
                    /* v contains x */
                } else
                {
                    /* v does not contain x */
                    if(!aIsTarget)
                    {
                        [self explosionEffect:ccp(PTM_RATIO*(bodyA->GetPosition().x),PTM_RATIO*(bodyA->GetPosition().y))];
                    }
                    else
                    {
                        [self targetExplosionEffect:ccp(PTM_RATIO*(bodyA->GetPosition().x),PTM_RATIO*(bodyA->GetPosition().y))];
                    }
                    toDestroy.push_back(bodyA);
                }
            }
            
            if(detailB->m_shouldDie)
            {
                if(std::find(toDestroy.begin(), toDestroy.end(), bodyB) != toDestroy.end())
                {
                    /* v contains x */
                } else
                {
                    /* v does not contain x */
                    if (!bIsTarget)
                    {
                        [self explosionEffect:ccp(PTM_RATIO*(bodyB->GetPosition().x),PTM_RATIO*(bodyB->GetPosition().y))];
                    }
                    else
                    {
                        [self targetExplosionEffect:ccp(PTM_RATIO*(bodyB->GetPosition().x),PTM_RATIO*(bodyB->GetPosition().y))];
                    }
                    toDestroy.push_back(bodyB);
                }
                
            }
            
            if(aIsTarget || bIsTarget)
            {
                //if target is hit destroy the player
                //and fire a level complete event.
                result = levelComplete;
                break;
                //toDestroy.push_back(m_player);
            }
            
            if(detailA->m_killerWall || detailB->m_killerWall)
            {
                result = levelFailed;
                break;
                //TODO do break candy collision
            }
            
        }
    }
    
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        BodyDetail* detail = (BodyDetail*) body->GetUserData() ;
        [self removeChild:detail->m_sprite cleanup:NO];
        m_world->DestroyBody(body);
        body = NULL;
    }
    
    return result;
    
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        m_startLocation = [touch locationInView: [touch view]];
		
		m_startLocation = [[CCDirector sharedDirector] convertToGL: m_startLocation];
        m_midLocation = m_startLocation;
	}
    
    m_firstMove = 0;
    
    b2Vec2 p =  b2Vec2(_X(m_startLocation.x),_X(m_startLocation.y));
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
        
        //if start location is higher than winsize/2 -- return
        if(body == m_player && m_startLocation.y >= 0.35*m_windowSize.height)
        {
            //need to show a message that the ball can'tbe touched
            //at this height
            m_playerStuckCount++;
            if(m_playerStuckCount >=6)
            {
                [self ShowMessageAtPositionForTime:@"Restart Level":ccp(m_windowSize.width/2,0.75*m_windowSize.height):1:30];
            }
            else
            {
                [self ShowMessageAtPositionForTime:@"Can't move the Candy from here":ccp(m_windowSize.width/2,0.75*m_windowSize.height):1:25];
            }
            return;
        }
        
        b2MouseJointDef md;
        md.bodyA = m_groundBody;
        md.bodyB = body;
        md.target = body->GetPosition();//p;
        md.maxForce = 5000.0f * body->GetMass();
        m_mouseJoint = (b2MouseJoint*)m_world->CreateJoint(&md);
        body->SetAwake(true);
        
        m_playerStuckCount = 0;
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        m_firstMove++;
        
        if(m_firstMove == 1)
        {
            m_touchStartTime = CACurrentMediaTime();
        }
        
        CFTimeInterval elapsedTime = CACurrentMediaTime() - m_touchStartTime;
        
        //NSLog(@"elapsed time %f",elapsedTime);
        //swipe can't last more than 0.2 seconds
        if(elapsedTime > 0.2)
        {
            break;
        }
        //NSLog(@"Elapsed time %f",elapsedTime);
        
        m_endLocation = [touch locationInView: [touch view]];
		
		m_endLocation = [[CCDirector sharedDirector] convertToGL: m_endLocation];
        
        m_midLocation = m_endLocation;
	}
    
    b2Vec2 p = b2Vec2(_X(m_endLocation.x),_X(m_endLocation.y));
    
    m_mouseWorld = p;
    
    if (m_mouseJoint)
    {
        m_mouseJoint->SetTarget(p);
    }
}

-(void)ShowMessageAtPositionForTime:(NSString*)str :(CGPoint) position :(int)forTime :(int) fontSize
{
    //TODO show a message at position
    CCLabelTTF  *startText = [CCLabelTTF labelWithString:str fontName:kFontName fontSize:fontSize];
    startText.position = position;
    [startText runAction:[CCFadeTo actionWithDuration:forTime opacity:1.0f]];
    if([self getChildByTag:TAG_GAME_LAYER_TEXT])
    {
        [self removeChildByTag:TAG_GAME_LAYER_TEXT cleanup:YES];
    }
    [self addChild:startText z:1 tag:TAG_GAME_LAYER_TEXT];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        m_endLocation = [touch locationInView: [touch view]];
		
		m_endLocation = [[CCDirector sharedDirector] convertToGL: m_endLocation];
    }
    
    if (m_mouseJoint)
    {
        m_world->DestroyJoint(m_mouseJoint);
        m_mouseJoint = NULL;
    }
}

-(void) targetExplosionEffect :(CGPoint) position
{
    CCParticleExplosion* explosion = [[CCParticleExplosion alloc]initWithTotalParticles:50];
    explosion.texture = [[CCTextureCache sharedTextureCache] addImage: @"circle.png"];
    explosion.autoRemoveOnFinish = YES;
    explosion.blendAdditive = NO;
    explosion.gravity = ccp(0,-50);
    explosion.startSize = 5.0f;
    explosion.speed = 60.0f;
    //explosion.anchorPoint = ccp(0.5f,0.5f);
    explosion.position = position;
    explosion.duration = 0.05f;
    
    
    CCParticleSun* explosion2 = [[CCParticleSun alloc]initWithTotalParticles:60];
    explosion2.texture = [[CCTextureCache sharedTextureCache] addImage: @"broken_circle.png"];
    explosion2.autoRemoveOnFinish = YES;
    explosion2.blendAdditive = NO;
    explosion2.gravity = ccp(0,-50);
    explosion2.startSize = 10.0f;
    explosion2.speed = 60.0f;
    //explosion.anchorPoint = ccp(0.5f,0.5f);
    explosion2.position = position;
    explosion2.duration = 0.05f;
    
    [self addChild:explosion z:self.zOrder+1];
    [self addChild:explosion2 z:self.zOrder+2];
}

-(void) explosionEffect :(CGPoint) position
{
    CCParticleSun* explosion = [[CCParticleSun alloc]initWithTotalParticles:80];
    explosion.autoRemoveOnFinish = YES;
    explosion.startSize = 20.0f;
    explosion.speed = 30.0f;
    explosion.anchorPoint = ccp(0.5f,0.5f);
    explosion.position = position;
    explosion.duration = 0.05f;
    [self addChild:explosion z:self.zOrder+1];
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
