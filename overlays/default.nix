_: _: final: prev: {
  discord-canary = prev.discord-canary.override {
    withVencord = true;
    withOpenASAR = true;
  };
}
