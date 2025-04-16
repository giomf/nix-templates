{
  description = "Pepper's flake templates";

  outputs =
    { self, ... }:
    {
      templates = {
        python = {
          path = ./python;
          description = "A simple python template";
        };
      };
    };
}
