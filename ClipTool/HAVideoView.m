//
//  HAVideoView.m
//  ClipTool
//
//  Created by Tao on 11/26/15.
//  Copyright © 2015 Tao. All rights reserved.
//

#import "HAVideoView.h"

@implementation HAVideoView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.showsFrameSteppingButtons = YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onFrameSteppingToTime:)]) {
        [self.delegate onFrameSteppingToTime:self.player.currentTime];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
   
    [self becomeFirstResponder];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
