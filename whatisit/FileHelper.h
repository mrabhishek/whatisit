//
//  FileHelper.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

@interface FileHelper : NSObject

+(NSString*) fullFilenameInDocumentsDirectory:(NSString*) filename;
+(BOOL) fileExistsInDocumentsDirectory:(NSString*) fileName;
+(NSString *)dataFilePathForFileWithName:(NSString*) filename withExtension:(NSString*)extension forSave:(BOOL)forSave;
+(void) createFolder:(NSString*) foldername;

@end
