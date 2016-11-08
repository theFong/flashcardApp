//
//  FlashCardModel.m
//  flashCard
//
//  Created by Alec Fong on 10/15/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import "FlashCardModel.h"

@interface FlashCardModel()
@property (strong, nonatomic) NSMutableArray* flashCards;
@property (strong, nonatomic) NSString* filepath;
@property (strong, nonatomic) FlashCard* noFlashcardsCard;
@end

@implementation FlashCardModel

- (instancetype)init
{
    self = [super init];
    
    _noFlashcardsCard = [[FlashCard alloc] initWithQuestion:@"There are no more flashcards!" answer:@"Please add flashcards!"];
    
    if (self) {
        // set the _currentIndex
        _currentIndex = 0;
        // get the Document directory and set _filepath
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        // _filepath includes the plist
        _filepath = [rootPath stringByAppendingPathComponent:@"flashCardData.plist"];
        
        
        NSMutableArray* cards = [NSMutableArray arrayWithContentsOfFile:_filepath];
        
        if (!cards) { // no file
            _flashCards = [[NSMutableArray alloc] initWithObjects:
                            [[FlashCard alloc] initWithQuestion:@"What is Lucas's Last name?" answer:@"Anfang"],
                            [[FlashCard alloc] initWithQuestion:@"What is the color of the sky?" answer:@"Blue"],
                            [[FlashCard alloc] initWithQuestion:@"What is FIJI?" answer:@"RIP"],
                            [[FlashCard alloc] initWithQuestion:@"What is Obama?" answer:@"Black(is that midly racist?)"],
                            [[FlashCard alloc] initWithQuestion:@"Who tore down that wall that was in Berlin along the iron curtain?" answer:@"Gorbachev"],nil];
        } else {
            _flashCards = [[NSMutableArray alloc] init];
            NSDictionary* card;
            FlashCard* flashcard;
            
            for (card in cards) {
                flashcard = [[FlashCard alloc] initWithDictionary: card];
                [_flashCards addObject: flashcard];
            }
        }
    }
    return self;
}

+ (instancetype) sharedModel{
    static FlashCardModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}
// Accessing number of flashcards in model
- (NSUInteger) numberOfFlashcards{
    return [self.flashCards count];
}
// Accessing a flashcard – sets currentIndex appropriately
- (FlashCard *) randomFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
     _currentIndex = arc4random()%[self numberOfFlashcards];
    return [self flashcardAtIndex:_currentIndex];
}
- (FlashCard *) flashcardAtIndex: (NSUInteger)index{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
    _currentIndex = index;
    return self.flashCards[self.currentIndex];
}
- (FlashCard *) nextFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
    _currentIndex = self.currentIndex == [self numberOfFlashcards]-1 ? 0:self.currentIndex+1;
    return self.flashCards[self.currentIndex];
}
- (FlashCard *) prevFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return self.noFlashcardsCard;
    }
    _currentIndex = 0 > self.currentIndex-1 ? [self numberOfFlashcards]-1:self.currentIndex-1;
    return self.flashCards[self.currentIndex];
}
// Inserting a flashcard
- (void) insertWithQuestion: (NSString *) question
                     answer: (NSString *) ans
                   favorite: (BOOL)fav{
    [self.flashCards addObject:[[FlashCard alloc] initWithQuestion:question answer:ans]];
    [self save];
}
- (void) insertWithQuestion: (NSString *) question
                     answer: (NSString *) ans
                   favorite: (NSNumber *) fav
                    atIndex: (NSUInteger) index{
    [self.flashCards insertObject:[[FlashCard alloc] initWithQuestion:question answer:ans] atIndex:index];
    [self save];
}
// Removing a flashcard
- (void) removeFlashcard{
    if ([self numberOfFlashcards] < 1) {
        return;
    }
    [self.flashCards removeLastObject];
    [self save];
    _currentIndex = 0 > self.currentIndex-1 ? [self numberOfFlashcards]-1:self.currentIndex-1;
}
- (void) removeFlashcardAtIndex: (NSUInteger) index{
    if ([self numberOfFlashcards] < 1) {
        return;
    }
    [self.flashCards removeObjectAtIndex:index];
    [self save];
    
    _currentIndex = 0 > self.currentIndex-1 ? [self numberOfFlashcards]-1:self.currentIndex-1;
}
// Favorite/unfavorite the current flashcard
- (void) toggleFavorite{
    [self save];
    [self.flashCards[self.currentIndex] setIsFavorite:YES];
}
// Getting the favorite flashcards
- (NSArray *) favoriteFlashcards{
    NSMutableArray *favorites = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < [self numberOfFlashcards]; i++) {
        if ([self.flashCards[i] isFavorite]) {
            [favorites addObject:self.flashCards[i]];
        }
    }
    return favorites;
}
- (void) save {
    NSMutableArray* cards = [[NSMutableArray alloc] init];
    FlashCard* card;
    for (card in self.flashCards) {
        [cards addObject: [card dictionary]];
    }
    [cards writeToFile:self.filepath atomically:YES];
}

@end
