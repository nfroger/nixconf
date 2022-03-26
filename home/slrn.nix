{ pkgs, ... }:

{
  home.packages = with pkgs; [ slrn ];
  home.sessionVariables.NNTPSERVER = "snews://news.cri.epita.fr";

  home.file.".slrnrc" = {
    text = ''
      set realname "Nicolas Froger"
      set username "nico"
      set hostname "cri.epita.fr"

      set signature ".signature_cri"

      set sorting_method 9

      nnrpaccess "news.cri.epita.fr" "nico" ""

      charset display utf8
      charset outgoing utf8
    '';
  };
}
