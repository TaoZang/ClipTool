//
//  ViewController.m
//  ClipTool
//
//  Created by Tao on 11/25/15.
//  Copyright © 2015 Tao. All rights reserved.
//

#import "HAClipController.h"
#import "HAVideoView.h"

@interface HAClipController ()

@property (weak) IBOutlet HAVideoView *videoView;
@property (weak) IBOutlet NSTextField *keyTextField;
@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSButton *uploadButton;
@property (weak) IBOutlet NSButton *commitButton;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet NSTextField *frameLabel;
@property (weak) IBOutlet NSButton *clipButton;
@property (weak) IBOutlet NSScrollView *tableView;

@property (nonatomic) AVPlayer *player;

@end

@implementation HAClipController

- (void)setFileURL:(NSURL *)fileURL {
    _fileURL = fileURL;
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [self.videoView setPlayer:self.player];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
}

@end
