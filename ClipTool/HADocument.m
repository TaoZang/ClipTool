//
//  HADocument.m
//  ClipTool
//
//  Created by Tao on 11/25/15.
//  Copyright © 2015 Tao. All rights reserved.
//

#import "HADocument.h"
#import "HAClipController.h"
#import "HAEditController.h"

@interface HADocument ()

@property (nonatomic) NSViewController *controller;

@end

@implementation HADocument

- (void)makeWindowControllers {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([self.fileType isEqualToString:@"clip"]) {
        NSWindowController *windowController = [storyboard instantiateControllerWithIdentifier:@"Clip Window Controller"];
        [self addWindowController:windowController];
        
        self.controller = windowController.contentViewController;
        [(HAClipController *)self.controller setFileURL:self.fileURL];
    } else {
        NSWindowController *windowController = [storyboard instantiateControllerWithIdentifier:@"Subtitle Window Controller"];
        [self addWindowController:windowController];
        
        self.controller = windowController.contentViewController;
        [(HAEditController *)self.controller setFileURL:self.fileURL];
    }
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    return YES;
}

@end