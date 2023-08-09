[
  :feat__apple_login
].each do|feat_name|
  Flipper.enable(feat_name) unless Flipper.exist?(feat_name)
end
