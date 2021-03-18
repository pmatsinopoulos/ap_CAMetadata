//
//  main.m
//  CAMetadata
//
//  Created by Panagiotis Matsinopoulos on 18/3/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

void GetAudioFileInformationProperty(AudioFileID audioFile, CFDictionaryRef *dictionary) {
  OSStatus theErr = noErr;
  UInt32 dictionarySize = 0;
  theErr = AudioFileGetPropertyInfo(audioFile,
                                    kAudioFilePropertyInfoDictionary,
                                    &dictionarySize,
                                    0);
  assert(theErr == noErr);
  
  theErr = AudioFileGetProperty(audioFile,
                                kAudioFilePropertyInfoDictionary,
                                &dictionarySize,
                                dictionary);
  assert(theErr == noErr);
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc < 2) {
      printf("Usage: CAMetadata fullpath/to/audiofile\n");
      return -1;
    }
    
    NSString *audioFilePath = [[NSString stringWithUTF8String:argv[1]]
                               stringByExpandingTildeInPath];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath];
    
    AudioFileID audioFile;
    OSStatus theErr = noErr;
    theErr = AudioFileOpenURL((__bridge CFURLRef)audioURL,
                              kAudioFileReadPermission,
                              0,
                              &audioFile);
    assert(theErr == noErr);
        
    CFDictionaryRef dictionary;
    
    GetAudioFileInformationProperty(audioFile, &dictionary);
    
    NSLog(@"dictionary: %@", dictionary);
    
    CFRelease(dictionary);
    
    theErr = AudioFileClose(audioFile);
    assert(theErr == noErr);
  }
  return 0;
}
