source("preamble.R", local = TRUE)


##### Infratest laden -----

source("Daten/infratest.R") # Infratest-Daten laden

# Variablen ohne Dezimalstellen
infratest$AfD <- round(as.numeric(infratest$AfD), 0)
infratest$FDP <- round(as.numeric(infratest$FDP), 0)
infratest$Piraten <- round(as.numeric(infratest$Piraten), 0)

# Datum formatieren
infratest$Datum <- format(as.Date(infratest$Datum, format="%d.%m.%y"), "%d.%m.%y")

# Umwandlung ins Longformat
infratest_long <- infratest %>%
  pivot_longer(!Datum, names_to = "Partei", values_to = "Prozent") # In Longformat umwandeln

infratest_long$Partei <- as.factor(infratest_long$Partei)

infratest_long$Institut <- c("Infratest")


##### Allensbach laden -----

# CSV einlesen
allensbach <- read.csv("Daten/allensbach.csv", header = TRUE, sep = c(";", " - "), dec = ",")

# Datum formatieren
allensbach$Datum <- substr(allensbach$Zeitraum, 9, nchar(allensbach$Zeitraum))
allensbach$Datum <- format(as.Date(allensbach$Datum, format="%d.%m.%Y"), "%d.%m.%y")

# Variablen umbennenen
names(allensbach)[2] <- "Union"
names(allensbach)[5] <- "Grüne"
names(allensbach)[6] <- "Linke*"
names(allensbach)[7] <- "AfD"
names(allensbach)[8] <- "Andere"

# Variablen löschen
allensbach <- subset(allensbach, select = -c(Zeitraum))

# Umwandlung ins Longformat
allensbach_long <- allensbach %>%
  pivot_longer(!Datum, names_to = "Partei", values_to = "Prozent") # In Longformat umwandeln

allensbach_long$Institut <- c("Allensbach")


##### Forschungsgruppe Wahlen -----

# CSV einlesen
forschungsgruppe <- read.csv("Daten/forschungsgruppe.csv", header = TRUE, sep = c(";"), dec = ",", na.strings = "NA")

# Variablen entfernen
forschungsgruppe <- subset(forschungsgruppe, select = -c(X, n, Zeitraum)) # Überflüssige Variablen löschen

# Variablen umbenennen und formatieren
names(forschungsgruppe)[6] <- "Linke*" 

forschungsgruppe$Piraten <- as.numeric(forschungsgruppe$Piraten)
forschungsgruppe$Union <- as.numeric(forschungsgruppe$Union)
forschungsgruppe$FDP <- as.numeric(sub(",", ".", forschungsgruppe$FDP, fixed = TRUE))
forschungsgruppe$AfD <- as.numeric(sub(",", ".", forschungsgruppe$AfD, fixed = TRUE))

forschungsgruppe$Datum <- format(as.Date(forschungsgruppe$Datum, format="%d.%m.%Y"), "%d.%m.%y")

# Umwandlung ins Longformat
forschungsgruppe_long <- forschungsgruppe %>%
  pivot_longer(!Datum, names_to = "Partei", values_to = "Prozent") # In Longformat umwandeln

forschungsgruppe_long$Institut <- c("Forschungsgruppe Wahlen")

# Umwandlung in Dezimalwerte
forschungsgruppe_long$Prozent <- forschungsgruppe_long$Prozent*100


##### INSA / YouGov -----

# Daten einlesen
source("Daten/INSA-YouGov.R", local = TRUE)

# Umwandlung ins Longformat
INSA_YouGov_long <- INSA_YouGov %>%
  pivot_longer(!Datum, names_to = "Partei", values_to = "Prozent") # In Longformat umwandeln

INSA_YouGov_long$Institut <- c("INSA/YouGov")

##### Datensätze aggregieren -----

# Datensätze zeilenweise zusammenfügen
dataset <- data.frame(rbind(allensbach_long, infratest_long, forschungsgruppe_long, INSA_YouGov_long))

# Variablen formatieren
dataset$Institut <- as.factor(dataset$Institut)
dataset$Prozent <- as.numeric(round(dataset$Prozent, 0))
dataset$Datum <- as.Date(dataset$Datum, format = "%d.%m.%y")


##### Wahlergebnisse -----

# Wahlergebnisse speichern
wahl <- data.frame(Datum = c("22.09.2013", "24.09.2017"),
                   Name = c("Bundestagswahl 2013", "Bundestagswahl 2017"),
                   Union = c(41.5, 32.9),
                   SPD = c(25.7, 20.5),
                   FDP = c(4.8, 10.7),
                   Grüne = c(8.4, 8.9),
                   Linke = c(8.6, 9.2),
                   AfD = c(NA, 12.6))

# Variablen umbenennen und formatieren
wahl$Datum <- format(as.Date(wahl$Datum, format="%d.%m.%Y"), "%d.%m.%y")

names(wahl)[7] <- "Linke*"

# Umwandlung ins Longformat
wahl_long <- subset(wahl, select = -c(Name)) %>%
  pivot_longer(!Datum, names_to = "Partei", values_to = "Prozent") # In Longformat umwandeln

wahl_long$Datum <-  format(as.Date(wahl_long$Datum, format="%d.%m.%Y"), "%d.%m.%y")


