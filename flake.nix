{
  description = "Flake templates";

  outputs =
    { ... }:
    {
      templates = {
        python = {
          path = ./python;
          description = "A simple python template";
        };
        rust = {
          path = ./rust;
          description = "A simple rust template";
        };
      };
    };
}
