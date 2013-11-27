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

^ 
'BitmapCharacter is a special data structure.'
]

{ #category : #catalog }
ConfigurationOfBitmapCharacterSet class >> catalogKeyClassesAndExample [

	^ 'It is composed of a single class BitmapCharacter.'
]

{ #category : #catalog }
ConfigurationOfBitmapCharacterSet class >> catalogKeywords [
	^ #(data structure HTML web)
	
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

	spec for: #'common' version: '1.0'

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

	spec for: #'common' version: '1.1'.
	
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
		spec description: 'Speed Improvement from Monty'.
		
		spec package: 'Collections-BitmapCharacterSet' with: 'Collections-BitmapCharacterSet-Anonymous.6'.
		spec package: 'Collections-Tests-BitmapCharacterSet' with: 'Collections-Tests-BitmapCharacterSet-JAA.5'
		]
	


]
