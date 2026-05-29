function __fish_ng_using_command
    set -l cmd (commandline -opc)
    test (count $cmd) -ge 1
    and test $cmd[1] = ng
end

complete -c ng -f -n __fish_ng_using_command -a add -d 'Add support for an external library'
complete -c ng -f -n __fish_ng_using_command -a analytics -d 'Configure analytics'
complete -c ng -f -n __fish_ng_using_command -a build -d 'Build Angular app'
complete -c ng -f -n __fish_ng_using_command -a cache -d 'Manage cache'
complete -c ng -f -n __fish_ng_using_command -a completion -d 'Generate shell completion script'
complete -c ng -f -n __fish_ng_using_command -a config -d 'Get or set Angular config values'
complete -c ng -f -n __fish_ng_using_command -a deploy -d 'Deploy Angular app'
complete -c ng -f -n __fish_ng_using_command -a doc -d 'Open Angular documentation'
complete -c ng -f -n __fish_ng_using_command -a e2e -d 'Run end-to-end tests'
complete -c ng -f -n __fish_ng_using_command -a extract-i18n -d 'Extract i18n messages'
complete -c ng -f -n __fish_ng_using_command -a generate -d 'Generate Angular artifacts'
complete -c ng -f -n __fish_ng_using_command -a g -d 'Alias for generate'
complete -c ng -f -n __fish_ng_using_command -a lint -d 'Lint project files'
complete -c ng -f -n __fish_ng_using_command -a new -d 'Create new Angular workspace'
complete -c ng -f -n __fish_ng_using_command -a serve -d 'Build and serve app locally'
complete -c ng -f -n __fish_ng_using_command -a s -d 'Alias for serve'
complete -c ng -f -n __fish_ng_using_command -a test -d 'Run unit tests'
complete -c ng -f -n __fish_ng_using_command -a update -d 'Update Angular dependencies'
complete -c ng -f -n __fish_ng_using_command -a version -d 'Show Angular CLI version'
complete -c ng -f -n __fish_ng_using_command -a v -d 'Alias for version'

# Global options
complete -c ng -l help -d 'Show help'
complete -c ng -s h -d 'Show help'
complete -c ng -l version -d 'Show version'
complete -c ng -l verbose -d 'Enable verbose logging'

# Generate subcommands
set -l generate_commands \
    application app class component config directive enum environment guard interceptor interface library module pipe resolver service web-worker

complete -c ng -n '__fish_seen_subcommand_from generate g' -a "$generate_commands"

# Serve options
complete -c ng -n '__fish_seen_subcommand_from serve s' -l open -s o -d 'Open browser automatically'
complete -c ng -n '__fish_seen_subcommand_from serve s' -l port -s p -d 'Port to listen on'
complete -c ng -n '__fish_seen_subcommand_from serve s' -l host -d 'Host to listen on'
complete -c ng -n '__fish_seen_subcommand_from serve s' -l ssl -d 'Enable SSL'

# Build options
complete -c ng -n '__fish_seen_subcommand_from build' -l configuration -s c -d 'Build configuration'
complete -c ng -n '__fish_seen_subcommand_from build' -l prod -d 'Production build'
complete -c ng -n '__fish_seen_subcommand_from build' -l watch -s w -d 'Watch for file changes'

# Test options
complete -c ng -n '__fish_seen_subcommand_from test' -l watch -d 'Run tests in watch mode'
complete -c ng -n '__fish_seen_subcommand_from test' -l code-coverage -d 'Generate code coverage report'

# Lint options
complete -c ng -n '__fish_seen_subcommand_from lint' -l fix -d 'Automatically fix lint issues'
