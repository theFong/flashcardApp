//
//  FlashCard.h
//  flashCard
//
//  Created by Alec Fong on 10/15/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import <Foundation/Foundation.h>

// constants
static NSString * const kQuestionKey = @"question";
static NSString * const kAnswerKey = @"answer";
static NSString * const kFavKey = @"fav";
static NSString * const kFavoriteYes = @"yes";
static NSString * const kFavoriteNo = @"no";

@interface Flashcard : NSObject

@property (strong, nonatomic, readonly) NSString* question;
@property (strong, nonatomic, readonly) NSString* answer;
@property BOOL isFavorite;

- (instancetype) initWithQuestion: (NSString *) question
                           answer: (NSString *) ans;
- (instancetype) initWithQuestion: (NSString *) question
                           answer: (NSString *) ans
                       isFavorite: (BOOL) isFav;

- (instancetype) initWithDictionary: (NSDictionary *) card;
- (NSDictionary *) dictionary;

@end
