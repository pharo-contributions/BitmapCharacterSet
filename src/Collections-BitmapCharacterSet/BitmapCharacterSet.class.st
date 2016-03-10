"
This class implements a set of Character objects similar to CharacterSet and WideCharacterSet, but it uses a bitmap internally to test if wide (multibyte) characters belong to it rather than using a Dictionary like WideCharacterSet does. For byte characters, a simple 256-element Array is used, the same as with CharacterSet, which is faster but uses more memory.

(used by XMLParser)
"
Class {
	#name : #BitmapCharacterSet,
	#superclass : #Collection,
	#instVars : [
		'byteCharacters',
		'wideCharacters',
		'tally'
	],
	#category : #'Collections-BitmapCharacterSet'
}

{ #category : #inspecting }
BitmapCharacterSet class >> inspectorClass [
	"does not use Set class>>inspectorClass because it is incompatible"
	^ Smalltalk tools inspectorClass
]

{ #category : #'instance creation' }
BitmapCharacterSet class >> new [
	^ self new: 256
]

{ #category : #'instance creation' }
BitmapCharacterSet class >> new: aCapacity [
	^ self basicNew initialize: aCapacity
]

{ #category : #'instance creation' }
BitmapCharacterSet class >> newFrom: aCollection [
	"for portability"
	^ self new
		addAll: aCollection;
		yourself	
]

{ #category : #comparing }
BitmapCharacterSet >> = anObject [
	self == anObject
		ifTrue: [^ true].

	(self class == anObject class
		and: [tally = anObject size])
		ifFalse: [^ false].

	^ self allSatisfy: [:each | anObject includes: each].
]

{ #category : #adding }
BitmapCharacterSet >> add: aCharacter [
	| asciiValue |

	"optimized for speed with inlining; do not refactor"
	(asciiValue := aCharacter asciiValue) < 256
		ifTrue: [
			(byteCharacters at: asciiValue + 1)
				ifFalse: [tally := tally + 1].
			byteCharacters
				at: asciiValue + 1
				put: true]
		ifFalse: [| byteIndex byte bitmask |
			"256 // 8 - 31 = 1 (first index), (256 + 8) // 8 - 31 = 2 (second), etc"
			byteIndex := asciiValue // 8 - 31.
			(wideCharacters isNil
				or: [byteIndex > wideCharacters size])
				ifTrue: [self growWideCharacterBitmapTo: (byteIndex * 1.5) asInteger].

			byte := wideCharacters at: byteIndex.
			bitmask := 16r80 bitShift: 0 - (asciiValue \\ 8).
			
			"Only increment the tally if the character is not already present"
			(byte bitAnd: bitmask) > 0
				ifFalse: [tally := tally + 1].

			wideCharacters
				at: byteIndex
				put: (byte bitOr: bitmask)].
	^ aCharacter.
]

{ #category : #private }
BitmapCharacterSet >> byteCharacters [
	^ byteCharacters
]

{ #category : #enumerating }
BitmapCharacterSet >> byteCharactersDo: aBlock [
	1 to: byteCharacters size do: [:i |
		(byteCharacters at: i)
			ifTrue: [aBlock value: (Character value: i - 1)]]
]

{ #category : #accessing }
BitmapCharacterSet >> capacity [
	^ byteCharacters size +
		(wideCharacters
			ifNil: [0]
			ifNotNil: [wideCharacters size * 8]).
]

{ #category : #enumerating }
BitmapCharacterSet >> do: aBlock [
	self
		byteCharactersDo: aBlock;
		wideCharactersDo: aBlock
]

{ #category : #private }
BitmapCharacterSet >> growWideCharacterBitmapTo: aSizeInBytes [
	| newSize |

	newSize := aSizeInBytes min: self maxWideCharactersSize.
	wideCharacters
		ifNil: [wideCharacters := ByteArray new: newSize]
		ifNotNil: [
			wideCharacters :=
				(ByteArray new: newSize)
					replaceFrom: 1
					to: wideCharacters size
					with: wideCharacters
					startingAt: 1].
]

{ #category : #testing }
BitmapCharacterSet >> hasWideCharacters [
	self wideCharactersDo: [:each | ^ true].
	^ false.
]

{ #category : #comparing }
BitmapCharacterSet >> hash [
	^ self class hash bitXor: self size hash
]

{ #category : #testing }
BitmapCharacterSet >> includes: aCharacter [
	| asciiValue |

	"optimized for speed with inlining; do not refactor"
	(asciiValue := aCharacter asciiValue) < 256
		ifTrue: [^ byteCharacters at: asciiValue + 1]
		ifFalse: [| byteIndex |
			wideCharacters
				ifNil: [^ false].
			"256 // 8 - 31 = 1 (first index), (256 + 8) // 8 - 31 = 2 (second), etc"
			(byteIndex := asciiValue // 8 - 31) > wideCharacters size
				ifTrue: [^ false].
			^ ((wideCharacters at: byteIndex) bitAnd:
				(16r80 bitShift: 0 - (asciiValue \\ 8))) > 0]
]

{ #category : #initialization }
BitmapCharacterSet >> initialize: aCapacity [
	byteCharacters := Array new: 256 withAll: false.
	aCapacity > 256
		ifTrue: [
			"(257 - 1) // 8 - 31 = 1 (first byte),
			(257 + 8 - 1) // 8 - 31 = 2 (second byte), etc"
			self growWideCharacterBitmapTo: (aCapacity - 1) // 8 - 31].
	tally := 0.
]

{ #category : #private }
BitmapCharacterSet >> maxWideCharactersSize [
	^ 139232 "16r10FFFF // 8 - 31"
]

{ #category : #copying }
BitmapCharacterSet >> postCopy [
	byteCharacters := byteCharacters copy.
	wideCharacters
		ifNotNil: [wideCharacters := wideCharacters copy].
]

{ #category : #removing }
BitmapCharacterSet >> remove: aCharacter ifAbsent: aBlock [
	| asciiValue |

	"optimized for speed with inlining; do not refactor"
	(asciiValue := aCharacter asciiValue) < 256
		ifTrue: [
			(byteCharacters at: asciiValue + 1)
				ifFalse: [^ aBlock value].
			byteCharacters
				at: asciiValue + 1
				put: false]
		ifFalse: [| byteIndex byte bitmask |
			"256 // 8 - 31 = 1 (first index), (256 + 8) // 8 - 31 = 2 (second), etc"
			byteIndex := asciiValue // 8 - 31.
			(wideCharacters isNil
				or: [byteIndex > wideCharacters size])
				ifTrue: [^ aBlock value].

			bitmask := 16r80 bitShift: 0 - (asciiValue \\ 8).
			((byte := wideCharacters at: byteIndex) bitAnd: bitmask) > 0
				ifFalse: [^ aBlock value].

			wideCharacters
				at: byteIndex
				put: (byte bitAnd: bitmask bitInvert)].
	tally := tally - 1.
	^ aCharacter.
]

{ #category : #removing }
BitmapCharacterSet >> removeAll [
	"empties but preserves the capacity"

	1 to: byteCharacters size do: [:i |
		byteCharacters
			at: i
			put: false].
	wideCharacters
		ifNotNil: [
			1 to: wideCharacters size do: [:i |
				wideCharacters
					at: i
					put: 0]].
	tally := 0.
]

{ #category : #accessing }
BitmapCharacterSet >> size [
	^ tally
]

{ #category : #private }
BitmapCharacterSet >> wideCharacters [
	^ wideCharacters
]

{ #category : #enumerating }
BitmapCharacterSet >> wideCharactersDo: aBlock [
	"optimized for speed with to:do: and inlining; do not refactor"
	| baseValue |

	wideCharacters
		ifNil: [^ self].

	baseValue := 248. "256 - 8"
	1 to: wideCharacters size do: [:byteIndex | | byte |
		baseValue := baseValue + 8. "248 + 8 = 256, 256 + 8 = 264, etc"
		(byte := wideCharacters at: byteIndex) > 0
			ifTrue: [
				0 to: 7 do: [:shiftIndex |
					(byte bitAnd: (16r80 bitShift: 0 - shiftIndex)) > 0
						ifTrue: [
							aBlock value:
								(Character value: baseValue + shiftIndex)]]]].
]
