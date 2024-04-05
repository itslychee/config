{
  # https://github.com/lwfinger/rtw88/issues/61
  # "Fix" the kernel log spam for "h2c command failed" or whatever
  environment.etc."modprobe.d/rtw88_8821ce.conf".text = ''
    options rtw88_core disable_lps_deep=y
    options rtw88_pci disable_msi=y disable_aspm=y
    options rtw_core disable_lps_deep=y
    options rtw_pci disable_msi=y disable_aspm=y
  '';

}
