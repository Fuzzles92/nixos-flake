#--------------------------------#
#        Fuzzles Account
#--------------------------------#

{ ... }: {

  #--------------------------------#
  #    User & Group Membership
  #--------------------------------#
  users.users.fuzzles = {
    isNormalUser = true;
    description = "Fuzzles";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
