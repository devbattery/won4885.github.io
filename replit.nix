{ pkgs }: {
  deps = [
    pkgs.sudo
    pkgs.print(str(datetime.datetime.now(timezone)))\
    pkgs.sudo
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.nodePackages.typescript-language-server
  ];
}