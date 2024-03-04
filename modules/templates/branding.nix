{cfg, ...}:
/*
xml
*/
''
  <?xml version="1.0" encoding="utf-8"?>
  <BrandingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <LoginDisclaimer${cfg.loginDisclaimer}/>
    <CustomCss${cfg.customCss}/>
    <SplashscreenEnabled>${toString cfg.splashscreenEnabled}</SplashscreenEnabled>
  </BrandingOptions>
''
