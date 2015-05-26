//
//  AKDCBlockTests.m
//  iOSObjectiveCAudioKit
//
//  Created by Aurelius Prochazka on 5/22/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

#import "AKTestCase.h"

#define testDuration 10.0

@interface TestDCBlockInstrument : AKInstrument
@end

@implementation TestDCBlockInstrument

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *filename = [AKManager pathToSoundFile:@"PianoBassDrumLoop" ofType:@"wav"];
        AKFileInput *audio = [[AKFileInput alloc] initWithFilename:filename];
        audio.loop = YES;
        AKMix *mono = [[AKMix alloc] initMonoAudioFromStereoInput:audio];
        
        AKDCBlock *dcBlock = [[AKDCBlock alloc] initWithInput:mono];
        
        [self setAudioOutput:dcBlock];
    }
    return self;
}

@end

@interface AKDCBlockTests : AKTestCase
@end

@implementation AKDCBlockTests

- (void)testDCBlock
{
    // Set up performance
    TestDCBlockInstrument *testInstrument = [[TestDCBlockInstrument alloc] init];
    [AKOrchestra addInstrument:testInstrument];
    [testInstrument playForDuration:testDuration];
    
    // Render audio output
    NSString *outputFile = [NSString stringWithFormat:@"%@/AKTest-DCBlock.aiff", NSTemporaryDirectory()];
    [[AKManager sharedManager] renderToFile:outputFile forDuration:testDuration];
    
    // Check output
    NSData *nsData = [NSData dataWithContentsOfFile:outputFile];
    XCTAssertEqualObjects([nsData MD5], @"887a7afd611039ef810940dd39836c3e");
}

@end