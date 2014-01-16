//
//  LevelFileHandler.m
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

#import "LevelFileHandler.h"
#import "TargetCircle.h"
#import "TargetPlusShape.h"
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
    
    // clean level data before loading level from file
    self.targetCircles = [NSMutableArray arrayWithCapacity:5];
    self.targetPlusShapes = [NSMutableArray arrayWithCapacity:5];
    
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
    }
    
    NSArray* objectsLayers =
            [doc.rootElement nodesForXPath:@"//map/layer[@name='objects']" error:nil];
    NSLog(@"%@", objectsLayers);
    
    if(objectsLayers != nil && objectsLayers.count > 0)
    {
        GDataXMLElement* objects = objectsLayers[0];
    }
    
    
}

@end
