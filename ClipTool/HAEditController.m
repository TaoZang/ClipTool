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

@interface HAEditController () <NSTableViewDataSource, NSTableViewDelegate>

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
    self.videoView.showsFrameSteppingButtons = YES;
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

- (IBAction)didRemoveItem:(id)sender {
    NSLog(@"remove");
}

- (void)didInsertSubtitle:(id)sender {
    CMTime currentTime = self.player.currentTime;
    self.startTimeField.stringValue = [self formatCMTime:currentTime];
}

- (void)didEndSubtitle:(id)sender {
    CMTime currentTime = self.player.currentTime;
    self.endTimeField.stringValue = [self formatCMTime:currentTime];
}

- (void)didCommitSubtitle:(id)sender {
    HASubtitle *subtitle = [[HASubtitle alloc] init];
    subtitle.startTime = self.startTimeField.stringValue;
    subtitle.endTime = self.endTimeField.stringValue;
    subtitle.content = [self.contentText.textStorage string];
    
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

- (NSString *)formatCMTime:(CMTime)currentTime {
    CMTime frameTime = CMTimeConvertScale(currentTime, 25, kCMTimeRoundingMethod_RoundTowardZero);
    NSInteger second = frameTime.value / 25;
    NSInteger msecond = frameTime.value % 25 * 40;
    return [NSString stringWithFormat:@"00:%.2ld:%.3ld", (long)second, (long)msecond];
}

- (NSMutableArray *)subtitleArray {
    if (!_subtitleArray) {
        _subtitleArray = [[NSMutableArray alloc] init];
    }
    return _subtitleArray;
}

@end
