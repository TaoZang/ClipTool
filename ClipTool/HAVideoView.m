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
    NSLog(@"on key down");
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayingTimeChanged:)]) {
        [self.delegate onPlayingTimeChanged:self];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    NSLog(@"on mouse down");
    [self becomeFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayingTimeChanged:)]) {
        [self.delegate onPlayingTimeChanged:self];
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
