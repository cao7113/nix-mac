# Issues

```
accepted connection from pid <unknown>, user root (trusted)
accepted connection from pid <unknown>, user rj
  2026-06-09T04:17:44.183569Z  INFO determinate_nixd: Determinate Nixd, version: "3.20.0", args: Args { command: Daemon, nix_bin: "/nix/var/nix/profiles/default/bin", config_file: None, flakehub_api_addr: "https://api.flakehub.com/", flakehub_frontend_addr: "https://flakehub.com/", flakehub_cache_addr: "https://cache.flakehub.com/" }
    at src/main.rs:334

  2026-06-09T04:17:44.357863Z  INFO determinate_nixd::command::init: Updating Nix's trusted certificates from Keychain
    at src/command/init.rs:72
    in determinate_nixd::command::init::execute with args: InitArgs { stop_after: None, keep_mounted: false }, dissenter: Some(DiskArbitrationDissenter)
    in determinate_nixd::command::start_nix_daemon::start_nix_daemon_interior
    in determinate_nixd::command::start_nix_daemon::start_nix_daemon
    in determinate_nixd::task_cmd

  2026-06-09T04:17:44.366489Z  INFO determinate_nixd::command::start_nix_daemon: Spawned nix-daemon
    at src/command/start_nix_daemon.rs:421
    in determinate_nixd::command::start_nix_daemon::start_nix_daemon_interior
    in determinate_nixd::command::start_nix_daemon::start_nix_daemon
    in determinate_nixd::task_cmd

  2026-06-09T04:17:44.366540Z  INFO determinate_nixd::gc: enable_automatic_garbage_collection=true; GC task will auto collect
    at src/gc.rs:218
    in determinate_nixd::gc::garbage_collection_process with bin: "/nix/var/nix/profiles/default/bin"
    in determinate_nixd::command::start_nix_daemon::start_nix_daemon_interior
    in determinate_nixd::command::start_nix_daemon::start_nix_daemon
    in determinate_nixd::task_cmd

  2026-06-09T04:17:47.710726Z  WARN determinate_nixd::auth: Auth failed (transient error), trying again after 500ms, attempt: 1, max_attempts: 5
    at src/auth/mod.rs:708
    in determinate_nixd::auth::retry_auth
    in determinate_nixd::auth::try_token_refresh
    in determinate_nixd::auth::log_in_with_new_mechanism with write_state_file: Yes
    in determinate_nixd::auth::work

accepted connection from pid <unknown>, user root (trusted)
  2026-06-09T04:17:50.239249Z  WARN determinate_nixd::auth: Auth failed (transient error), trying again after 1000ms, attempt: 2, max_attempts: 5
    at src/auth/mod.rs:708
    in determinate_nixd::auth::retry_auth
    in determinate_nixd::auth::try_token_refresh
    in determinate_nixd::auth::log_in_with_new_mechanism with write_state_file: Yes
    in determinate_nixd::auth::work

  2026-06-09T04:17:53.268024Z  WARN determinate_nixd::auth: Auth failed (transient error), trying again after 2000ms, attempt: 3, max_attempts: 5
    at src/auth/mod.rs:708
    in determinate_nixd::auth::retry_auth
    in determinate_nixd::auth::try_token_refresh
    in determinate_nixd::auth::log_in_with_new_mechanism with write_state_file: Yes
    in determinate_nixd::auth::work

  2026-06-09T04:17:57.296191Z  WARN determinate_nixd::auth: Auth failed (transient error), trying again after 4000ms, attempt: 4, max_attempts: 5
    at src/auth/mod.rs:708
    in determinate_nixd::auth::retry_auth
    in determinate_nixd::auth::try_token_refresh
    in determinate_nixd::auth::log_in_with_new_mechanism with write_state_file: Yes
    in determinate_nixd::auth::work

  2026-06-09T04:18:03.486780Z ERROR determinate_nixd::auth: Authentication failure, s: Permanent
    at src/auth/mod.rs:542
    in determinate_nixd::auth::try_token_refresh_impl
    in determinate_nixd::auth::retry_auth
    in determinate_nixd::auth::try_token_refresh
    in determinate_nixd::auth::work

```