exiftool -s -q -c "%%d %%d %%.8f" -d "%%Y-%%m-%%d %%H:%%M:%%S" -AllDates -MWG:Creator -MWG:Copyright -MWG:Keywords -XMP:LocationCreatedWorldRegion -MWG:Country -XMP-iptcCore:CountryCode -MWG:State -MWG:City -MWG:Location -GPSLatitude -GPSLatitudeRef -GPSLongitude -GPSLongitudeRef -GPSAltitude -GPSAltitudeRef -XMP:CollectionName -XMP:CollectionURI -ImageUniqueID -IPTC:CodedCharacterSet %*