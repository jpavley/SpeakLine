//
//  SpeakLineAppDelegate.h
//  SpeakLine
//
//  Created by  John Pavley on 6/12/13.
//  Copyright (c) 2013  John Pavley. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kSpeakingModeNotStarted 0
#define kSpeakingModeStopped 1
#define kSpeakingModeSpeaking 2
#define kSpeakingModePaused 3
#define kSpeakingModeCompleted 4

@interface SpeakLineAppDelegate : NSObject <NSApplicationDelegate, NSSpeechSynthesizerDelegate>
{
    NSArray *_voices;
    NSSpeechSynthesizer *_speechSynth;
    int _speakingMode;
}

@property (weak) IBOutlet NSTextField *textField;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *continueButton;
@property (weak) IBOutlet NSButton *pauseButton;
@property (weak) IBOutlet NSTableView *tableView;
@property int speakingMode;

- (IBAction)stopIt:(id)sender;
- (IBAction)speakIt:(id)sender;
- (IBAction)pauseIt:(id)sender;
- (IBAction)continueIt:(id)sender;
- (void)mapStateToUI;

@end
