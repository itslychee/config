{ alejandra, fetchpatch, ...}:
alejandra.overrideAttrs(old: {
    patches = old.patches ++ [ (fetchpatch {
        url = "https://github.com/itslychee/donationsfree-alejandra/commit/0f79fba4e4c8a15dea88b677d129846221017f13.patch";
        hash = "sha256-kJkktxKeC51nBkRt3eB+ZkQ/L67Pr6Y+zS+95pmlzUo=";
    }) ];
    }
)
