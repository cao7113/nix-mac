```
rj@mac official % ./tmp-installer/nix-2.34.7-aarch64-darwin/install
Switching to the Multi-user Installer
Welcome to the Multi-User Nix Installation

This installation tool will set up your computer with the Nix package
manager. This will happen in a few stages:

1. Make sure your computer doesn't already have Nix. If it does, I
   will show you instructions on how to clean up your old install.

2. Show you what I am going to install and where. Then I will ask
   if you are ready to continue.

3. Create the system users (uids [351..382]) and groups (gid 350)
   that the Nix daemon uses to run builds. To create system users
   in a different range, exit and run this tool again with
   NIX_FIRST_BUILD_UID set.

4. Perform the basic installation of the Nix files daemon.

5. Configure your shell to import special Nix Profile files, so you
   can use Nix.

6. Start the Nix daemon.

Would you like to see a more detailed list of what I will do?
[y/n] y


I will:

 - make sure your computer doesn't already have Nix files
   (if it does, I will tell you how to clean them up.)
 - create local users (see the list above for the users I'll make)
 - create a local group (nixbld)
 - install Nix in /nix
 - create a configuration file in /etc/nix
 - set up the "default profile" by creating some Nix-related files in
   /var/root
 - back up /etc/bashrc to /etc/bashrc.backup-before-nix
 - update /etc/bashrc to include some Nix configuration
 - back up /etc/zshrc to /etc/zshrc.backup-before-nix
 - update /etc/zshrc to include some Nix configuration
 - create a Nix volume and a LaunchDaemon to mount it
 - create a LaunchDaemon (at /Library/LaunchDaemons/org.nixos.nix-daemon.plist) for nix-daemon

Ready to continue?
[y/n] y


---- let's talk about sudo -----------------------------------------------------
This script is going to call sudo a lot. Every time I do, it'll
output exactly what it'll do, and why.

Just like this:

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo echo

to demonstrate how our sudo prompts look


This might look scary, but everything can be undone by running just a
few commands. I used to ask you to confirm each time sudo ran, but it
was too many times. Instead, I'll just ask you this one time:

Can I use sudo?
[y/n] y

Yay! Thanks! Let's get going!

~~> Fixing any leftover Nix volume state
Before I try to install, I'll check for any existing Nix volume config
and ask for your permission to remove it (so that the installer can
start fresh). I'll also ask for permission to fix any issues I spot.

---- Found existing Nix volume -------------------------------------------------
  special:	disk3s7
     uuid:	F440032B-F9DC-4DC0-8E6F-14E3C5571AB0
encrypted:	yes


---- sudo execution ------------------------------------------------------------
I am executing:

---- sudo execution ------------------------------------------------------------
I am executing:
    $ sudo /usr/sbin/diskutil apfs unlockVolume disk3s7 -verify -stdinpassphrase -user F440032B-F9DC-4DC0-8E6F-14E3C5571AB0


to confirm the password actually unlocks the volume

    $ sudo security find-generic-password -s F440032B-F9DC-4DC0-8E6F-14E3C5571AB0 -w

to confirm keychain has a password that unlocks this volume

Password:
security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain.
Error: A zero-length passphrase is not supported

---- warning! ------------------------------------------------------------------

This volume is encrypted, but I don't see a password to decrypt it.
The quick fix is to let me delete this volume and make you a new one.
If that's okay, enter your (sudo) password to continue. If not, you
can ensure the decryption password is in your system keychain with a
"Where" (service) field set to this volume's UUID:
  F440032B-F9DC-4DC0-8E6F-14E3C5571AB0

Can I delete this volume?
[y/n] y

Enter your password to delete this volume:

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo /usr/sbin/diskutil unmount force disk3s7

to unmount the Nix volume

disk3s7 was already unmounted

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo /usr/sbin/diskutil apfs deleteVolume disk3s7

to delete the Nix volume

Started APFS operation
Deleting APFS Volume from its APFS Container
Unmounting disk3s7
Erasing any xART session referenced by F440032B-F9DC-4DC0-8E6F-14E3C5571AB0
Deleting Volume
Removing any Preboot and Recovery Directories
Finished APFS operation

During install, I add 'nix' to /etc/synthetic.conf, which instructs
macOS to create an empty root directory for mounting the Nix volume.

Nix isn't the only thing in /var/folders/r0/t1kgzm197y18n6jchmm8ft2r0000gn/T/tmp.wPjrFplpBL/synthetic.conf.edit,
but I think I know how to edit it out.
Here's the diff:

nix
Does the change above look right?
[y/n] y


---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo cp /etc/synthetic.conf /var/folders/r0/t1kgzm197y18n6jchmm8ft2r0000gn/T/tmp.wPjrFplpBL/synthetic.conf.edit

remove nix from /var/folders/r0/t1kgzm197y18n6jchmm8ft2r0000gn/T/tmp.wPjrFplpBL/synthetic.conf.edit


~~> Checking for artifacts of previous installs
Before I try to install, I'll check for signs Nix already is or has
been installed on this system.

---- Nix config report ---------------------------------------------------------
        Temp Dir:	/var/folders/r0/t1kgzm197y18n6jchmm8ft2r0000gn/T/tmp.wPjrFplpBL
        Nix Root:	/nix
     Build Users:	32
  Build Group ID:	350
Build Group Name:	nixbld

build users:
    Username:	UID
     _nixbld1:	351
     _nixbld2:	352
     _nixbld3:	353
     _nixbld4:	354
     _nixbld5:	355
     _nixbld6:	356
     _nixbld7:	357
     _nixbld8:	358
     _nixbld9:	359
     _nixbld10:	360
     _nixbld11:	361
     _nixbld12:	362
     _nixbld13:	363
     _nixbld14:	364
     _nixbld15:	365
     _nixbld16:	366
     _nixbld17:	367
     _nixbld18:	368
     _nixbld19:	369
     _nixbld20:	370
     _nixbld21:	371
     _nixbld22:	372
     _nixbld23:	373
     _nixbld24:	374
     _nixbld25:	375
     _nixbld26:	376
     _nixbld27:	377
     _nixbld28:	378
     _nixbld29:	379
     _nixbld30:	380
     _nixbld31:	381
     _nixbld32:	382

Ready to continue?
[y/n] y


---- Preparing a Nix volume ----------------------------------------------------
    Nix traditionally stores its data in the root directory /nix, but
    macOS now (starting in 10.15 Catalina) has a read-only root directory.
    To support Nix, I will create a volume and configure macOS to mount it
    at /nix.

~~> Creating a Nix volume

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo /usr/sbin/diskutil unmount force disk3s7

to ensure the Nix volume is not mounted

Unmount failed for disk3s7

~~> Configuring /etc/fstab to specify volume mount options

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo /usr/sbin/vifs

to add nix to fstab


~~> Encrypt the Nix volume

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo /usr/sbin/diskutil mount Nix Store

to mount your Nix volume for encrypting

Failed to find disk Nix Store

---- oh no! --------------------------------------------------------------------
Oh no, something went wrong. If you can take all the output and open
an issue, we'd love to fix the problem so nobody else has this issue.

:(

We'd love to help if you need it.

You can open an issue at
https://github.com/NixOS/nix/issues/new?labels=installer&template=installer.md

Or get in touch with the community: https://nixos.org/community
```