{ lib, mkTextDerivation }:

{ config, name, ... }:

with lib;

let
  fileName = file: last (splitString "/" file);
  mkDefaultIf = cond: value: mkIf cond (mkDefault value);

  drv = mkTextDerivation (fileName name) config.text;
in

{
  options = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether this file should be generated.
        This option allows specific files to be disabled.
      '';
    };

    text = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Text of the file.
      '';
    };

    target = mkOption {
      type = types.str;
      default = "/${name}";
      description = ''
        Name of symlink.  Defaults to the attribute name preceded by a slash (the root directory).
      '';
    };

    source = mkOption {
      type = types.path;
      description = ''
        Path of the source file.
      '';
    };

    knownSha256Hashes = mkOption {
      internal = true;
      type = types.listOf types.str;
      default = [];
    };

    copy = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to copy the file into place rather than create a symlink pointing to the Nix store.
      '';
    };

    hash = mkOption {
      type = types.str;
      default = "";
      description = ''
        The SHA256 hash of the file. Must be set when files are copied out of the Nix store.

        TODO: this maybe can be generated on the fly and not need to be explicitly set?
      '';
    };
  };

  config = {
    source = mkDefault drv;
  };
}
