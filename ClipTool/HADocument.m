//
//  HADocument.m
//  ClipTool
//
//  Created by Tao on 11/25/15.
//  Copyright © 2015 Tao. All rights reserved.
//

#import "HADocument.h"
#import "HAClipController.h"

@interface HADocument ()

@property (nonatomic) HAClipController *controller;

@end

@implementation HADocument

- (void)makeWindowControllers {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *windowController = [storyboard instantiateControllerWithIdentifier:@"Clip Window Controller"];
    [self addWindowController:windowController];
    
    self.controller = (HAClipController *)windowController.contentViewController;
    self.controller.fileURL = self.fileURL;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    return YES;
}

@end