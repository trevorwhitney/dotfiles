let
  twhitney = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";
  agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQeR4ucBEgCTMTJDuIg5M0cs1Cjw1Tl17LQtmzkpMXl trevorjwhitney@gmail.com";

in
{
  "openApiKey.age".publicKeys = [ twhitney agenix ];
}

