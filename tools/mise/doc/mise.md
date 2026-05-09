mise manages dev tools, env vars, and runs tasks. https://github.com/jdx/mise

Usage: mise [OPTIONS] [TASK] [COMMAND]

Commands:
  activate      Initializes mise in the current shell session
  tool-alias    Manage tool version aliases.
  backends      Manage backends [aliases: b]
  bin-paths     List all the active runtime bin paths
  cache         Manage the mise cache
  completion    Generate shell completions
  config        Manage config files [aliases: cfg]
  deactivate    Disable mise for current shell session
  doctor        Check mise installation for possible problems [aliases: dr]
  en            Starts a new shell with the mise environment built from the current configuration
  env           Exports env vars to activate mise a single time [aliases: e]
  exec          Execute a command with tool(s) set [aliases: x]
  fmt           Formats mise.toml
  generate      Generate files for various tools/services [aliases: gen]
  implode       Removes mise CLI and all related data
  edit          Edit mise.toml interactively
  install       Install a tool version [aliases: i]
  install-into  Install a tool version to a specific path
  latest        Gets the latest available version for a plugin
  link          Symlinks a tool version into mise [aliases: ln]
  lock          Update lockfile checksums and URLs for all specified platforms
  ls            List installed and active tool versions [aliases: list]
  ls-remote     List runtime versions available for install.
  mcp           [experimental] Run Model Context Protocol (MCP) server
  outdated      Shows outdated tool versions
  plugins       Manage plugins [aliases: p]
  prepare       [experimental] Ensure project dependencies are ready [aliases: prep]
  prune         Delete unused versions of tools
  registry      List available tools to install
  reshim        Creates new shims based on bin paths from currently installed tools.
  run           Run task(s) [aliases: r]
  search        Search for tools in the registry
  self-update   Updates mise itself.
  set           Set environment variables in mise.toml
  settings      Manage settings
  shell         Sets a tool version for the current session. [aliases: sh]
  shell-alias   Manage shell aliases.
  sync          Synchronize tools from other version managers with mise
  tasks         Manage tasks [aliases: t]
  test-tool     Test a tool installs and executes
  tool          Gets information about a tool
  tool-stub     Execute a tool stub
  trust         Marks a config file as trusted
  uninstall     Removes installed tool versions
  unset         Remove environment variable(s) from the config file.
  unuse         Removes installed tool versions from mise.toml [aliases: rm, remove]
  upgrade       Upgrades outdated tools [aliases: up]
  use           Installs a tool and adds the version to mise.toml. [aliases: u]
  version       Display the version of mise [aliases: v]
  watch         Run task(s) and watch for changes to rerun it [aliases: w]
  where         Display the installation path for a tool
  which         Shows the path that a tool's bin points to.
  help          Print this message or the help of the given subcommand(s)

Arguments:
  [TASK]
          Task to run.
          
          Shorthand for `mise tasks run <TASK>`.

Options:
  -C, --cd <DIR>
          Change directory before running command

  -E, --env <ENV>
          Set the environment for loading `mise.<ENV>.toml`

  -j, --jobs <JOBS>
          How many jobs to run in parallel [default: 8]
          
          [env: MISE_JOBS=]

  -q, --quiet
          Suppress non-error messages

  -v, --verbose...
          Show extra output (use -vv for even more)

  -y, --yes
          Answer yes to all confirmation prompts

      --no-config
          Do not load any config files
          
          Can also use `MISE_NO_CONFIG=1`

      --no-env
          Do not load environment variables from config files
          
          Can also use `MISE_NO_ENV=1`

      --no-hooks
          Do not execute hooks from config files
          
          Can also use `MISE_NO_HOOKS=1`

      --output <OUTPUT>
          

      --raw
          Read/write directly to stdin/stdout/stderr instead of by line

      --locked
          Require lockfile URLs to be present during installation
          
          Fails if tools don't have pre-resolved URLs in the lockfile for the current platform.
          This prevents API calls to GitHub, aqua registry, etc.
          Can also be enabled via MISE_LOCKED=1 or settings.locked=true

      --silent
          Suppress all task output and mise non-error messages

  -h, --help
          Print help (see a summary with '-h')

Examples:

    $ mise install node@20.0.0       Install a specific node version
    $ mise install node@20           Install a version matching a prefix
    $ mise install node              Install the node version defined in config
    $ mise install                   Install all plugins/tools defined in config

    $ mise install cargo:ripgrep            Install something via cargo
    $ mise install npm:prettier             Install something via npm

    $ mise use node@20               Use node-20.x in current project
    $ mise use -g node@20            Use node-20.x as default
    $ mise use node@latest           Use latest node in current directory

    $ mise up --interactive          Show a menu to upgrade tools

    $ mise x -- npm install          `npm install` w/ config loaded into PATH
    $ mise x node@20 -- node app.js  `node app.js` w/ config + node-20.x on PATH

    $ mise set NODE_ENV=production   Set NODE_ENV=production in config

    $ mise run build                 Run `build` tasks
    $ mise watch build               Run `build` tasks repeatedly when files change

    $ mise settings                  Show settings in use
    $ mise settings color=0          Disable color by modifying global config file

