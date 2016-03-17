//
//  HAEditController.m
//  ClipTool
//
//  Created by Tao on 11/26/15.
//  Copyright © 2015 Tao. All rights reserved.
//

#import "HAEditController.h"
#import "HAVideoView.h"
#import "HASubtitleCell.h"
#import "HASubtitle.h"

@interface HAEditController () <NSTableViewDataSource, NSTableViewDelegate, HAVideoFrameSteppingDelegate>

@property (weak) IBOutlet HAVideoView *videoView;
@property (weak) IBOutlet NSTextField *timeLabel;
@property (weak) IBOutlet NSTextField *frameLabel;
@property (weak) IBOutlet NSTextField *startTimeField;
@property (weak) IBOutlet NSTextField *endTimeField;
@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSTextView *contentText;

@property (nonatomic) AVPlayer *player;
@property (nonatomic) NSMutableArray *subtitleArray;

- (IBAction)didInsertSubtitle:(id)sender;
- (IBAction)didEndSubtitle:(id)sender;
- (IBAction)didCommitSubtitle:(id)sender;
- (IBAction)didExportSubtitle:(id)sender;

- (IBAction)didRemoveItem:(id)sender;
- (IBAction)didMoveupItem:(id)sender;
- (IBAction)didMovedownItem:(id)sender;

@end

@implementation HAEditController

- (void)setFileURL:(NSURL *)fileURL {
    _fileURL = fileURL;
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [self.videoView setPlayer:self.player];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.videoView.delegate = self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.subtitleArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    HASubtitle *subtitle = [self.subtitleArray objectAtIndex:row];
    
    NSString *identifier = [tableColumn identifier];
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    if ([identifier isEqualToString:@"startCell"]) {
        cellView.textField.stringValue = subtitle.startTime;
    } else if([identifier isEqualToString:@"endCell"]) {
        cellView.textField.stringValue = subtitle.endTime;
    } else if([identifier isEqualToString:@"contentCell"]) {
        cellView.textField.stringValue = subtitle.content;
    }
    return cellView;
}

- (void)onPlayingTimeChanged:(HAVideoView *)videoView {
    [self updateTimeLabel];
}

- (IBAction)didRemoveItem:(id)sender {
    NSInteger index = [self.tableView rowForView:sender];
    [self.subtitleArray removeObjectAtIndex:index];
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationEffectFade];
}

- (IBAction)didMoveupItem:(id)sender {
    NSInteger index = [self.tableView selectedRow];
    if (index > 0 && index < self.subtitleArray.count) {
        [self.tableView moveRowAtIndex:index toIndex:(index - 1)];
        [self moveItemAtIndex:index toIndex:(index - 1)];
    }
}

- (IBAction)didMovedownItem:(id)sender {
    NSInteger index = [self.tableView selectedRow];
    if (index >= 0 && index < (self.subtitleArray.count - 1)) {
        [self.tableView moveRowAtIndex:index toIndex:(index + 1)];
        [self moveItemAtIndex:index toIndex:(index + 1)];
    }
}

- (void)didInsertSubtitle:(id)sender {
    CMTime currentTime = self.player.currentTime;
    self.startTimeField.stringValue = [self formatCMTime:[self convertTime:currentTime]];
}

- (void)didEndSubtitle:(id)sender {
    CMTime currentTime = self.player.currentTime;
    self.endTimeField.stringValue = [self formatCMTime:[self convertTime:currentTime]];
}

- (void)didCommitSubtitle:(id)sender {
    HASubtitle *subtitle = [[HASubtitle alloc] init];
    subtitle.startTime = self.startTimeField.stringValue;
    subtitle.endTime = self.endTimeField.stringValue;
    subtitle.content = [NSString stringWithString:[self.contentText.textStorage string]];
    
    [sender resignFirstResponder];
    [self.subtitleArray addObject:subtitle];
    [self.tableView reloadData];
}

- (void)didExportSubtitle:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *subFile = [[self.fileURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"vtt"];
    [fileManager removeItemAtURL:subFile error:nil];
    
    [@"WEBVTT\n\n" writeToURL:subFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:subFile.path];
    for (HASubtitle *subtitle in self.subtitleArray) {
        NSString *line = [NSString stringWithFormat:@"%@ --> %@\n%@\n\n", subtitle.startTime, subtitle.endTime, subtitle.content];
        [handler seekToEndOfFile];
        [handler writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)updateTimeLabel {
    CMTime currentTime = self.player.currentTime;
    CMTime frameTime = [self convertTime:currentTime];
    self.timeLabel.stringValue = [NSString stringWithFormat:@"TimeStamp: %@", [self formatCMTime:frameTime]];
    self.frameLabel.stringValue = [NSString stringWithFormat:@"Frame: %ld", (long)frameTime.value];
}

- (NSString *)formatCMTime:(CMTime)frameTime {
    NSInteger second = frameTime.value / 25;
    NSInteger msecond = frameTime.value % 25 * 40;
    return [NSString stringWithFormat:@"00:%.2ld.%.3ld", (long)second, (long)msecond];
}

- (CMTime)convertTime:(CMTime)time {
    return CMTimeConvertScale(time, 25, kCMTimeRoundingMethod_RoundTowardZero);
}

- (void)moveItemAtIndex:(NSInteger)srcIndex toIndex:(NSInteger)destIndex {
    HASubtitle *srcItem = [self.subtitleArray objectAtIndex:srcIndex];
    [self.subtitleArray removeObjectAtIndex:srcIndex];
    [self.subtitleArray insertObject:srcItem atIndex:destIndex];
}

- (NSMutableArray *)subtitleArray {
    if (!_subtitleArray) {
        _subtitleArray = [[NSMutableArray alloc] init];
    }
    return _subtitleArray;
}

@end
