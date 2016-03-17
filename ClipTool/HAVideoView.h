//
//  HAVideoView.h
//  ClipTool
//
//  Created by Tao on 11/26/15.
//  Copyright © 2015 Tao. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@class HAVideoView;
@protocol HAVideoFrameSteppingDelegate <NSObject>

- (void)onPlayingTimeChanged:(HAVideoView *)videoView;

@end

@interface HAVideoView : AVPlayerView

@property (nonatomic, weak) id<HAVideoFrameSteppingDelegate> delegate;

@end
