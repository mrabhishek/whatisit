//
//  LevelFileHandler.m
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

#import "LevelFileHandler.h"
#import "Player.h"
#import "Target.h"
#import "Obstacle.h"
#import "RevoluteJoint.h"
#import "GDataXMLNode.h"
#import "FileHelper.h"

@interface LevelFileHandler () {
    NSString* _filename;
}
@end

@implementation LevelFileHandler

-(id)initWithFileName:(NSString*)filename {
    self = [super init];
    if (self) {
        _filename = filename;
        [self loadFile];
    }
    return self;
}

/* loads an XML file containing level data */

//Need error handling if file is not found.
-(void) loadFile {
    // load file from documents directory if possible, if not try to load from mainbundle
    NSString *filePath = [FileHelper dataFilePathForFileWithName:_filename withExtension:@".xml" forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    [xmlData release]; //TODO verify release
    
    // clean level data before loading level from file
    self.player = [[[Player alloc]init]autorelease];
    self.target = [[[Target alloc]init]autorelease];
    
    // if there is no file doc will be empty and we simply return from this method
    if (doc == nil) {
        return;
    }
    //NSLog(@"%@", doc.rootElement);
    
    //TODO: parse XML and store into model classes
    
    NSArray* settingLayers = [doc.rootElement nodesForXPath:@"//map/layer[@name='settings']" error:nil];
    NSLog(@"%@", settingLayers);
    
    if(settingLayers != nil && settingLayers.count > 0)
    {
        GDataXMLElement* settings = settingLayers[0];
        NSLog(@"%@", settings);
    }
    
    NSArray* objectsLayers =
            [doc.rootElement nodesForXPath:@"//map/layer[@name='objects']" error:nil];
    NSLog(@"%@", objectsLayers);
    
    //right now only 1 object layer per xml is supported
    
    for(GDataXMLElement* objectLayer in objectsLayers)
    {
        NSLog(@"%@", objectLayer);
        
        //Load Player data
        
        Player* player = [[Player alloc]init];
        
        NSArray* playersArray = [objectLayer elementsForName:@"player"];
        GDataXMLElement *playerData = playersArray[0];
        
        float x = [playerData attributeForName:@"x"].stringValue.floatValue;
        float y = [playerData attributeForName:@"y"].stringValue.floatValue;
        
        player.Id = [playerData attributeForName:@"id"].stringValue.intValue;
        player.Position = [LevelFileHandler levelPositionToScreenPosition:CGPointMake(x, y)];
        
        player.shape = [box2DHelper shapeFromShapeString:[playerData attributeForName:@"shape"].stringValue];
        
        player.bodyType = [box2DHelper bodyTypeFrombodyTypeString:[playerData attributeForName:@"type"].stringValue];
        
        player.die = [playerData attributeForName:@"die"].stringValue.boolValue;
        
        self.player = player;
        
        //Load target data
        
        Target* target = [[Target alloc]init];
        NSArray* targetArray = [objectLayer elementsForName:@"target"];
        GDataXMLElement* targetData = targetArray[0];
        
        float xt = [targetData attributeForName:@"x"].stringValue.floatValue;
        float yt = [targetData attributeForName:@"y"].stringValue.floatValue;
        
        target.Id = [targetData attributeForName:@"id"].stringValue.intValue;
        target.Position = [LevelFileHandler levelPositionToScreenPosition:CGPointMake(xt, yt)];
        
        target.shape = [box2DHelper shapeFromShapeString:[targetData attributeForName:@"shape"].stringValue];
        
        target.bodyType = [box2DHelper bodyTypeFrombodyTypeString:[targetData attributeForName:@"type"].stringValue];
        
        target.die = [targetData attributeForName:@"die"].stringValue.boolValue;
        target.angularVelocity = [targetData attributeForName:@"angvel"].stringValue.intValue;
        
        //NSLog(@"%@",[targetData attributeForName:@"density"]);
       
        
        if([targetData attributeForName:@"density"].stringValue != NULL)
        {
            target.density = [targetData attributeForName:@"density"].stringValue.floatValue;
        }
        
        self.target = target;
        NSLog(@"%f",target.density);
        
        //load other objectLayer data
        
        self.obstacles = [NSMutableArray arrayWithCapacity:kSupportedObstacles];
        
        NSArray* objectsArray = [objectLayer elementsForName:@"object"];
        
        for(GDataXMLElement* object in objectsArray)
        {
            Obstacle* obstacle = [[Obstacle alloc] init];
            float x = [object attributeForName:@"x"].stringValue.floatValue;
            float y = [object attributeForName:@"y"].stringValue.floatValue;
            
            obstacle.Id = [object attributeForName:@"id"].stringValue.intValue;
            obstacle.Position = [LevelFileHandler levelPositionToScreenPosition:CGPointMake(x, y)];
            
            obstacle.shape = [box2DHelper shapeFromShapeString:[object attributeForName:@"shape"].stringValue];
            obstacle.bodyType = [box2DHelper bodyTypeFrombodyTypeString:[object attributeForName:@"type"].stringValue];
            
            obstacle.die = [object attributeForName:@"die"].stringValue.boolValue;
            obstacle.sensor = [object attributeForName:@"sensor"].stringValue.boolValue;
            obstacle.killerwall = [object attributeForName:@"killerwall"].stringValue.boolValue;
            obstacle.bonus = [object attributeForName:@"bonus"].stringValue.boolValue;
            obstacle.movingx = [object attributeForName:@"movingx"].stringValue.boolValue;
            obstacle.movingy = [object attributeForName:@"movingy"].stringValue.boolValue;
            
            float fromx = [object attributeForName:@"fromx"].stringValue.floatValue;
            float fromy = [object attributeForName:@"fromy"].stringValue.floatValue;
            
            obstacle.from = [LevelFileHandler levelPositionToScreenPosition:CGPointMake(fromx, fromy)];
            
            float tox = [object attributeForName:@"tox"].stringValue.floatValue;
            float toy = [object attributeForName:@"toy"].stringValue.floatValue;
            
            obstacle.to = [LevelFileHandler levelPositionToScreenPosition:CGPointMake(tox, toy)];
            
            float velx = [object attributeForName:@"velx"].stringValue.floatValue;
            float vely = [object attributeForName:@"vely"].stringValue.floatValue;
            
            //safety against bad xml data;
            if(obstacle.movingx) vely =0;
            if(obstacle.movingy) velx = 0;
            
            obstacle.vel = b2Vec2(velx, vely);
            obstacle.angularVelocity = [object attributeForName:@"angvel"].stringValue.intValue;
            
            [self.obstacles addObject:obstacle];
        }
        
        self.revoluteJoints = [NSMutableArray arrayWithCapacity:kSupportedJoints];
        
        NSArray* jointsArray = [objectLayer elementsForName:@"joint"];
        
        for(GDataXMLElement* object in jointsArray)
        {
            RevoluteJoint* joint = [[RevoluteJoint alloc] init];
            joint.Id = [object attributeForName:@"id"].stringValue.intValue;
            joint.jointType = [object attributeForName:@"type"].stringValue;
            joint.IdBodyA = [object attributeForName:@"ida"].stringValue.intValue;
            joint.IdBodyB = [object attributeForName:@"idb"].stringValue.intValue;
            joint.EnableLimit = [object attributeForName:@"limit"].stringValue.boolValue;
            joint.LowerAngle = [object attributeForName:@"lowerangle"].stringValue.intValue;
            joint.HigherAngle = [object attributeForName:@"higherangle"].stringValue.intValue;
            
            [self.revoluteJoints addObject:joint];
        }
        
    }
    
    [doc release]; //TODO check release
}

-(void)dealloc
{
    [_player release]; _player =nil;
    [_target release]; _target =nil;
    [_obstacles release]; _obstacles = nil;
    
    [super dealloc];
}

+(CGPoint) levelPositionToScreenPosition:(CGPoint) position {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    return CGPointMake(position.x * winSize.width, position.y * winSize.height);
}

@end
