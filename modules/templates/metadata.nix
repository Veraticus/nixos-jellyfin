{
  cfg,
  mkBool,
  ...
}:
/*
xml
*/
''
  <?xml version="1.0" encoding="utf-8"?>
  <MetadataConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    ${mkBool cfg.useFileCreationTimeForDateAdded "UseFileCreationTimeForDateAdded"}
  </MetadataConfiguration>
''
