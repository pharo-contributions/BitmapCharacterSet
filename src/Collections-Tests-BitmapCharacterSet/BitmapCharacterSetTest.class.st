Class {
	#name : #BitmapCharacterSetTest,
	#superclass : #TestCase,
	#instVars : [
		'characters'
	],
	#category : #'Collections-Tests-BitmapCharacterSet'
}

{ #category : #enumerating }
BitmapCharacterSetTest >> absentCharactersDo: aBlock [
	| previousValue |

	previousValue := 0.
	self charactersDo: [:each |
		previousValue + 1 to: each asciiValue - 1 do: [:i |
			aBlock value: i asCharacter].
		previousValue := each asciiValue].

	previousValue + 1 to: self lastCodePoint - 1 do: [:i |
		aBlock value: i asCharacter].
]

{ #category : #accessing }
BitmapCharacterSetTest >> characterSetClass [
	^ BitmapCharacterSet
]

{ #category : #accessing }
BitmapCharacterSetTest >> characters [
	^ characters
		ifNil: [| writeStream previousValue offset |
			writeStream := (Array new: 250000) writeStream.
			previousValue := 0.
			writeStream nextPut: previousValue asCharacter.
			offset := 1.
			1 to: self lastCodePoint do: [:i |
				previousValue + offset = i
					ifTrue: [
						writeStream nextPut: i asCharacter.
						previousValue := i.
						offset :=
							offset = 8
								ifTrue: [1]
								ifFalse: [offset + 1]]].
			characters := writeStream contents]
]

{ #category : #enumerating }
BitmapCharacterSetTest >> charactersDo: aBlock [
	self characters do: aBlock
]

{ #category : #accessing }
BitmapCharacterSetTest >> emptyCharacterSet [
	^ self characterSetClass new
]

{ #category : #accessing }
BitmapCharacterSetTest >> lastCodePoint [
	^ self characterSetClass lastCodePoint
]

{ #category : #accessing }
BitmapCharacterSetTest >> nonEmptyCharacterSet [
	^ self characterSetClass newFrom: self characters
]

{ #category : #tests }
BitmapCharacterSetTest >> testAdd [
	| set |

	set := self emptyCharacterSet.
	self charactersDo: [:each |
		self
			deny: (set includes: each);
			assert: (set add: each) = each;
			assert: (set includes: each);
			assert: (set add: each) = each;
			assert: (set includes: each)].
]

{ #category : #tests }
BitmapCharacterSetTest >> testCapacity [
	"Since the bitmap is allocated in bytes, the last byte can have excess capacity
	even when a specific capacity is specified."

	self assert: (self characterSetClass new: 256) capacity = 256.
	257 to: 264 do: [:i |
		self assert: (self characterSetClass new: i) capacity = 264].
	265 to: 272 do: [:i |
		self assert: (self characterSetClass new: i) capacity = 272].
]

{ #category : #tests }
BitmapCharacterSetTest >> testCopy [
	| set copy |

	set := self nonEmptyCharacterSet.
	copy := set copy.
	self
		assert: set = copy;
		deny: set == copy;
		assert: set byteCharacters = copy byteCharacters;
		deny: set byteCharacters == copy byteCharacters;
		assert: set wideCharacters = copy wideCharacters;
		deny: set wideCharacters == copy wideCharacters.
]

{ #category : #tests }
BitmapCharacterSetTest >> testDo [
	| set enumerated |

	set := self emptyCharacterSet.
	enumerated := OrderedCollection new.

	set do: [:each | enumerated add: each].
	self assert: enumerated isEmpty.

	set addAll: self characters.
	set do: [:each | enumerated add: each].
	self assert: enumerated size = self characters size.
	enumerated
		with: self characters
		do: [:enumeratedChar :expectedChar |
			self assert: enumeratedChar = expectedChar]
]

{ #category : #tests }
BitmapCharacterSetTest >> testEquals [
	self
		assert: self emptyCharacterSet = self emptyCharacterSet;
		assert: self nonEmptyCharacterSet = self nonEmptyCharacterSet;
		deny: self emptyCharacterSet = self nonEmptyCharacterSet;
		deny: self nonEmptyCharacterSet = self emptyCharacterSet
]

{ #category : #tests }
BitmapCharacterSetTest >> testHash [
	self
		assert: self emptyCharacterSet hash = self emptyCharacterSet hash;
		assert: self nonEmptyCharacterSet hash = self nonEmptyCharacterSet hash;
		deny: self emptyCharacterSet hash = self nonEmptyCharacterSet hash
]

{ #category : #tests }
BitmapCharacterSetTest >> testIncludes [
	| set |

	set := self emptyCharacterSet.
	self
		charactersDo: [:each | self deny: (set includes: each)];
		absentCharactersDo: [:each | self deny: (set includes: each)].

	set := self nonEmptyCharacterSet.
	self
		charactersDo: [:each | self assert: (set includes: each)];
		absentCharactersDo: [:each | self deny: (set includes: each)].
]

{ #category : #tests }
BitmapCharacterSetTest >> testMaxCapacity [
	| unroundedMaxCapacity roundedMaxCapacity set |

	unroundedMaxCapacity := self lastCodePoint + 1.
	roundedMaxCapacity := unroundedMaxCapacity + (unroundedMaxCapacity \\ 8).

	set := self characterSetClass new: unroundedMaxCapacity.
	self assert: set capacity = roundedMaxCapacity.

	set := self characterSetClass new: unroundedMaxCapacity + 8.
	self assert: set capacity = roundedMaxCapacity.
]

{ #category : #tests }
BitmapCharacterSetTest >> testNewFrom [
	| set newSet |

	set := self characterSetClass newFrom: self characters.
	self assert: set class == self characterSetClass.
	self charactersDo: [:each | self assert: (set includes: each)].

	newSet := self characterSetClass newFrom: set.
	self
		assert: newSet = set;
		deny: newSet == set.
]

{ #category : #tests }
BitmapCharacterSetTest >> testRemoveIfAbsent [
	| set |

	set := self nonEmptyCharacterSet.
	self absentCharactersDo: [:each |
		self assert: (set remove: each ifAbsent: [nil]) isNil].
	self charactersDo: [:each |
		self assert: (set remove: each ifAbsent: [nil]) = each.
		self assert: (set remove: each ifAbsent: [nil]) isNil].
]

{ #category : #tests }
BitmapCharacterSetTest >> testSize [
	| set size |

	set := self emptyCharacterSet.
	size := 0.
	self charactersDo: [:each |
		self assert: set size = size.
		set add: each.
		size := size + 1.
		self assert: set size = size.

		"Adding the same character shouldn't alter the size"
		set add: each.
		self assert: set size = size.].

	self charactersDo: [:each |
		set remove: each.
		size := size - 1.
		self assert: set size = size].	
]
