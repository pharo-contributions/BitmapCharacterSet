"
(ConfigurationOfBitmapCharacterSet project version: #stable) load

(ConfigurationOfBitmapCharacterSet project version: #stable) load: #('Tests')
"
Class {
	#name : #ConfigurationOfBitmapCharacterSet,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfBitmapCharacterSet
}

{ #category : #private }
ConfigurationOfBitmapCharacterSet class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : #catalog }
ConfigurationOfBitmapCharacterSet class >> catalogChangeLog [
		
 ^ '
-25/11/2013 - Speed improvements from Monty.
[[[
(ConfigurationOfSoup project version: #''stable'') load
(ConfigurationOfSoup project version: ''1.1'') load
]]]

-1/2013 - Migrated from squeaksource.
[[[
(ConfigurationOfSoup project version: #''stable'') load
(ConfigurationOfSoup project version: ''1.0'') load
]]]


'
	
	
]

{ #category : #catalog }
ConfigurationOfBitmapCharacterSet class >> catalogDescription [

^ 'BitmapCharacterSet is a set for characters that uses a bitmap for storing wide characters and an array of truth values for byte characters. Used by XMLParser.'
]

{ #category : #catalog }
ConfigurationOfBitmapCharacterSet class >> catalogKeyClassesAndExample [

	^ 'It is composed of a single class BitmapCharacterSet.

Example:
[[[ 
			BitmapCharacterSet newFrom: Character separators.
			BitmapCharacterSet newFrom: Character allByteCharacters.
]]]'
]

{ #category : #catalog }
ConfigurationOfBitmapCharacterSet class >> catalogKeywords [
	^ #(collection set character unicode)
	
]

{ #category : #catalog }
ConfigurationOfBitmapCharacterSet class >> catalogLicense [
	^ 'The MIT License (MIT)

Copyright (c) 2016 PharoExtras Team.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'
]

{ #category : #private }
ConfigurationOfBitmapCharacterSet class >> ensureMetacello [
	"Bootstrap Gofer (if necessary), bootstrap ConfigurationOfMetacello (using old Gofer API), then load the latest 
	version of Metacello itself."

	Smalltalk at: #MetacelloProject ifAbsent: [
		Smalltalk at: #Gofer ifAbsent: [
			"Current version of Gofer from which to bootstrap - as of 1.0-beta.21"
			self bootstrapPackage: 'Gofer-Core-lr.115' from: 'http://seaside.gemstone.com/ss/metacello' ].
		Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
			gofer := goferClass new
				url: 'http://seaside.gemstone.com/ss/metacello';
				yourself.
			[ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
			gofer load ].
		"load 'default' group of Metacello"
		(Smalltalk at: #ConfigurationOfMetacello) perform: #load ]
]

{ #category : #'metacello tool support' }
ConfigurationOfBitmapCharacterSet class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'metacello tool support' }
ConfigurationOfBitmapCharacterSet class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : #loading }
ConfigurationOfBitmapCharacterSet class >> load [
	"self load"

	^self project latestVersion load
]

{ #category : #loading }
ConfigurationOfBitmapCharacterSet class >> loadDefault [
	"self loadDefault"

	^ self loadMostRecentCoreWithTests
]

{ #category : #loading }
ConfigurationOfBitmapCharacterSet class >> loadMostRecentCoreWithTests [
	^self project lastVersion load: #('Core' 'Tests')
]

{ #category : #'metacello tool support' }
ConfigurationOfBitmapCharacterSet class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : #accessing }
ConfigurationOfBitmapCharacterSet class >> project [

	^self new project
]

{ #category : #'unloading Metacello' }
ConfigurationOfBitmapCharacterSet class >> unloadMetacello [

	Smalltalk at: #ConfigurationOfMetacello ifPresent: [:cls | cls unloadMetacello ]
]

{ #category : #baselines }
ConfigurationOfBitmapCharacterSet >> baseline100: spec [ 
	<version: '1.0-baseline'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec repository: 'http://smalltalkhub.com/mc/PharoExtras/BitmapCharacterSet/main'.	
		spec description: 'Imported from SqueakSource'.
		spec package: 'Collections-BitmapCharacterSet'.
		spec 
			package: 'Collections-Tests-BitmapCharacterSet' 
			with: [spec requires: 'Collections-BitmapCharacterSet'].
			
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Collections-BitmapCharacterSet');
			group: 'Tests' with: #('Collections-Tests-BitmapCharacterSet'). ].
]

{ #category : #'symbolic versions' }
ConfigurationOfBitmapCharacterSet >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1.0-baseline'

]

{ #category : #accessing }
ConfigurationOfBitmapCharacterSet >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfBitmapCharacterSet >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.2.6'.
	
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version100: spec [ 
	<version: '1.0' imports: #('1.0-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.
		spec description: 'Latest versions from Squeaksource'.
		
		spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-JAA.5'.
		spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-JAA.5'
		]
	


]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version110: spec [ 
	<version: '1.1' imports: #('1.0-baseline') >
	
	spec for: #common do: [ 
		spec blessing: #release.
		spec description: 'Speed Improvement from Monty and adding tests'.
		
		spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-Anonymous.6'.
		spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-Anonymous.6'
		]
	


]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version111: spec [ 
	<version: '1.1.1' imports: #('1.0-baseline') >
	
	spec for: #common do: [ 
		spec blessing: #release.
		spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.7'.
		spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-Anonymous.6'
		]
	


]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version112: spec [ 
	<version: '1.1.2' imports: #('1.0-baseline') >
	
	spec for: #common do: [ 
		spec blessing: #release.
		spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.8'.
		spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-Anonymous.6'
		]
	


]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version113: spec [ 
        <version: '1.1.3' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.10'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-Anonymous.6'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version114: spec [ 
        <version: '1.1.4' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.11'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.7'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version115: spec [ 
        <version: '1.1.5' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.12'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.7'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version116: spec [ 
        <version: '1.1.6' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.13'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.8'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version117: spec [ 
        <version: '1.1.7' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.14'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.9'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version118: spec [ 
        <version: '1.1.8' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.15'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.10'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version119: spec [ 
        <version: '1.1.9' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.16'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.10'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version120: spec [ 
        <version: '1.2.0' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.17'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.10'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version121: spec [ 
        <version: '1.2.1' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.18'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.11'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version122: spec [ 
        <version: '1.2.2' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.19'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.11'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version123: spec [ 
        <version: '1.2.3' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.20'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.12'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version124: spec [ 
        <version: '1.2.4' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.22'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.13'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version125: spec [ 
        <version: '1.2.5' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.23'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.13'
                ].
]

{ #category : #versions }
ConfigurationOfBitmapCharacterSet >> version126: spec [ 
        <version: '1.2.6' imports: #('1.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-monty.25'.
			spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-monty.14'
                ].
]
