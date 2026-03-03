{
  description = "Flake templates";

  outputs =
    { ... }:
    {
      templates = {
        default = {
          path = ./default;
          description = "Default template";
        };
        python = {
          path = ./python;
          description = "A simple python template";
        };
        rust = {
          path = ./rust;
          description = "A simple rust template";
        };
        cpp = {
          path = ./cpp;
          description = "A simple cpp template";
        };
        zola = {
          path = ./zola;
          description = "A simple zola template";
        };
      };
    };
}
