//
//  HAGuideController.m
//  ClipTool
//
//  Created by Tao on 11/25/15.
//  Copyright © 2015 Tao. All rights reserved.
//

#import "HAGuideController.h"
#import "HADocument.h"

@interface HAGuideController ()

@property (nonatomic) NSWindowController *windowController;

- (IBAction)openMovieFile:(id)sender;
- (IBAction)openSubtitleEditor:(id)sender;

@end

@implementation HAGuideController

- (IBAction)openMovieFile:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:@[@"mp4"]];
    
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *fileURL = [[openPanel URLs] firstObject];
            HADocument *document = [[HADocument alloc] initWithContentsOfURL:fileURL ofType:@"clip" error:nil];
            
            [[NSDocumentController sharedDocumentController] addDocument:document];
            [document makeWindowControllers];
            [document showWindows];
        }
    }];
}

- (IBAction)openSubtitleEditor:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:@[@"mp4"]];
    
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *fileURL = [[openPanel URLs] firstObject];
            if (fileURL) {
                HADocument *document = [[HADocument alloc] initWithContentsOfURL:fileURL ofType:@"subtitle" error:nil];
                [[NSDocumentController sharedDocumentController] addDocument:document];
                [document makeWindowControllers];
                [document showWindows];
            }
        }
    }];
}

@end
