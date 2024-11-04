package renovate

#UpdateType: "minor" | "patch" | "pin" | "digest" | "replacement"
#DepType:    "*" | "indirect"
#Manager:    "gomod"

#PackageRule: {
	rangeStrategy?: string
	ignoreTests?:   bool
	matchDepTypes?: [...#DepType]
	matchManagers?: [...#Manager]
	matchUpdateTypes?: [...#UpdateType]
	enabled?:           bool
	automerge:          bool | *false
	automergeType?:     string
	automergeStrategy?: string
	recreateWhen?:      string

	if automerge {
		automergeStrategy: "merge-commit"
	}
}

#RenovateConfig: {
	"$schema": "https://docs.renovatebot.com/renovate-schema.json"
	extends?: [...string]
	prHourlyLimit:     0
	prConcurrentLimit: 0
	packageRules: [...#PackageRule]
	ignorePaths?: [...string]
	postUpdateOptions?: [...string]
	platformAutomerge: true
}

// Base configurations
let bestPracticesBase = {
	extends: [
		"config:best-practices",
		":dependencyDashboard",
	]
}

let recommendedBase = {
	extends: [
		"config:recommended",
		":dependencyDashboard",
	]
}

// Package rules building blocks
let packageRuleBlocks = {
	base: {
		matchDepTypes: ["indirect"]
		enabled: true
		matchManagers: ["gomod"]
	}
	automerge: {
		automerge: true
	}
	noTests: {
		ignoreTests:       true
		automergeType:     "branch"
		automergeStrategy: "merge-commit"
	}
	allDeps: {
		matchDepTypes: ["*"]
	}
	recreate: {
		recreateWhen: "always"
	}
}

updateTypes: {
	standard: ["minor", "patch", "pin", "digest"]
	withReplacement: standard + ["replacement"]
}

let goPostUpdateOptions = [
	"gomodTidyE",
	"gomodMassage",
	"gomodUpdateImportPaths",
]

// Common configuration patterns
let commonPatterns = {
	withGoPost: {
		postUpdateOptions: goPostUpdateOptions
	}
}

cat: #RenovateConfig & bestPracticesBase & {
	packageRules: [
		packageRuleBlocks.automerge &
		packageRuleBlocks.noTests &
		packageRuleBlocks.allDeps & {
			rangeStrategy:    "pin"
			matchUpdateTypes: updateTypes.standard
		},
	]
}

dog: #RenovateConfig & bestPracticesBase & commonPatterns.withGoPost & {
	packageRules: [
		packageRuleBlocks.automerge &
		packageRuleBlocks.recreate & {
			matchUpdateTypes: updateTypes.standard
		},
	]
}

owl: #RenovateConfig & bestPracticesBase & commonPatterns.withGoPost & {
	packageRules: [
		packageRuleBlocks.automerge &
		packageRuleBlocks.recreate & {
			matchUpdateTypes: updateTypes.withReplacement
		},
	]
	ignorePaths: ["**/testdata/go.mod"]
}

monkey: #RenovateConfig & bestPracticesBase & commonPatterns.withGoPost & {
	packageRules: [
		packageRuleBlocks.base,
		packageRuleBlocks.automerge &
		packageRuleBlocks.noTests &
		packageRuleBlocks.allDeps & {
			matchUpdateTypes: updateTypes.withReplacement
		},
	]
}

hamster: #RenovateConfig & recommendedBase & commonPatterns.withGoPost & {
	packageRules: [
		packageRuleBlocks.automerge &
		packageRuleBlocks.allDeps & {
			matchUpdateTypes: updateTypes.standard
		},
	]
}
