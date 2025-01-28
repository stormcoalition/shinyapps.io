
pwqmn <- read_sf("https://raw.githubusercontent.com/stormcoalition/geojson/main/PWQMN_STORM.geojson", quiet=TRUE) %>%
  mutate(STATUS=str_replace(STATUS, "A", "Active")) %>%
  mutate(STATUS=str_replace(STATUS, "I", "Inactive"))



pwqmnPal <- colorFactor(
  c('blue','grey40'),
  domain = pwqmn$STATUS
)